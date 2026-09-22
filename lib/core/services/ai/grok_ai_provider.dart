import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:lotus_ai/core/errors/exception.dart';
import 'package:lotus_ai/core/network/dio_client.dart';
import 'package:lotus_ai/core/services/ai/ai_provider.dart';

class GrokAiProvider implements AiProvider {
  GrokAiProvider({
    required DioClient dioClient,
    String? apiKey,
  })  : _dioClient = dioClient,
        _apiKey = apiKey?.trim() ?? '';

  final DioClient _dioClient;
  final String _apiKey;
  CancelToken? _cancelToken;

  static const String _endpoint = 'https://api.x.ai/v1/chat/completions';

  @override
  String get providerId => 'grok';

  @override
  String get displayName => 'xAI Grok';

  @override
  List<String> get availableModels => [
        'grok-2-latest',
        'grok-2-vision-latest',
        'grok-beta',
      ];

  @override
  Future<String> sendMessage({
    required String prompt,
    required String model,
    List<Map<String, String>>? history,
    String? systemPrompt,
  }) async {
    if (_apiKey.isEmpty) {
      throw const AiProviderException(
        'xAI Grok API Key is not set. Please configure it in Settings.',
      );
    }

    _cancelToken = CancelToken();
    try {
      final messages = <Map<String, String>>[];
      if (systemPrompt != null && systemPrompt.isNotEmpty) {
        messages.add({'role': 'system', 'content': systemPrompt});
      }
      if (history != null) {
        messages.addAll(history);
      }
      messages.add({'role': 'user', 'content': prompt});

      final response = await _dioClient.post<Map<String, dynamic>>(
        _endpoint,
        data: {
          'model': model,
          'messages': messages,
          'stream': false,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
        ),
        cancelToken: _cancelToken,
      );

      final choices = response.data?['choices'] as List<dynamic>?;
      if (choices != null && choices.isNotEmpty) {
        final message = choices[0]['message'] as Map<String, dynamic>?;
        return message?['content'] as String? ?? '';
      }
      return '';
    } on Object catch (e) {
      throw AiProviderException('Grok API call failed: $e', e);
    }
  }

  @override
  Stream<String> streamMessage({
    required String prompt,
    required String model,
    List<Map<String, String>>? history,
    String? systemPrompt,
  }) async* {
    if (_apiKey.isEmpty) {
      yield '⚠️ xAI Grok API Key is missing.\n\nPlease open Settings -> AI Engine Settings and paste your Grok API Key.';
      return;
    }

    _cancelToken = CancelToken();
    final messages = <Map<String, String>>[];
    if (systemPrompt != null && systemPrompt.isNotEmpty) {
      messages.add({'role': 'system', 'content': systemPrompt});
    }
    if (history != null) {
      messages.addAll(history);
    }
    messages.add({'role': 'user', 'content': prompt});

    try {
      final response = await _dioClient.dio.post<ResponseBody>(
        _endpoint,
        data: {
          'model': model,
          'messages': messages,
          'stream': true,
        },
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
        cancelToken: _cancelToken,
      );

      final stream = response.data?.stream;
      if (stream == null) return;

      if (response.statusCode != 200) {
        final rawError = await utf8.decodeStream(stream);
        try {
          final errorJson = jsonDecode(rawError) as Map<String, dynamic>;
          final errObj = errorJson['error'];
          if (errObj is Map) {
            yield '⚠️ Grok API Error (${response.statusCode}): ${errObj['message']}';
            return;
          }
        } on Object catch (_) {}
        yield '⚠️ Grok API Error (${response.statusCode}): $rawError';
        return;
      }

      var buffer = '';
      await for (final chunk in stream) {
        buffer += utf8.decode(chunk);
        final lines = buffer.split('\n');
        buffer = lines.last;

        for (final line in lines.sublist(0, lines.length - 1)) {
          final trimmed = line.trim();
          if (trimmed.startsWith('data: ')) {
            final jsonStr = trimmed.substring(6).trim();
            if (jsonStr == '[DONE]') continue;
            try {
              final data = jsonDecode(jsonStr) as Map<String, dynamic>;
              final choices = data['choices'] as List<dynamic>?;
              if (choices != null && choices.isNotEmpty) {
                final delta = choices[0]['delta'] as Map<String, dynamic>?;
                final text = delta?['content'] as String?;
                if (text != null && text.isNotEmpty) {
                  yield text;
                }
              }
            } on Object catch (_) {}
          }
        }
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) return;
      yield '⚠️ Grok API Error: ${e.message}';
    } on Object catch (e) {
      yield 'Error connecting to Grok API: $e';
    }
  }

  @override
  void cancel() {
    _cancelToken?.cancel('User cancelled request');
  }
}
