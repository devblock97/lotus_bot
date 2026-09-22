import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:lotus_ai/core/errors/exception.dart';
import 'package:lotus_ai/core/network/dio_client.dart';
import 'package:lotus_ai/core/services/ai/ai_provider.dart';

class OpenAiCompatibleProvider implements AiProvider {
  OpenAiCompatibleProvider({
    required DioClient dioClient,
    String? baseUrl,
    String? apiKey,
    List<String>? models,
  })  : _dioClient = dioClient,
        _baseUrl = baseUrl?.isNotEmpty ?? false
            ? (baseUrl!.endsWith('/chat/completions')
                ? baseUrl
                : (baseUrl.endsWith('/')
                    ? '${baseUrl}chat/completions'
                    : '$baseUrl/chat/completions'))
            : 'https://api.openai.com/v1/chat/completions',
        _apiKey = apiKey?.trim() ?? '',
        _models = models ?? ['gpt-4o', 'gpt-4o-mini', 'deepseek-chat', 'claude-3-5-sonnet'];

  final DioClient _dioClient;
  final String _baseUrl;
  final String _apiKey;
  final List<String> _models;
  CancelToken? _cancelToken;

  @override
  String get providerId => 'openai_compatible';

  @override
  String get displayName => 'Custom / OpenAI Compatible';

  @override
  List<String> get availableModels => _models;

  @override
  Future<String> sendMessage({
    required String prompt,
    required String model,
    List<Map<String, String>>? history,
    String? systemPrompt,
  }) async {
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

      final headers = <String, dynamic>{'Content-Type': 'application/json'};
      if (_apiKey.isNotEmpty) {
        headers['Authorization'] = 'Bearer $_apiKey';
      }

      final response = await _dioClient.post<Map<String, dynamic>>(
        _baseUrl,
        data: {
          'model': model,
          'messages': messages,
          'stream': false,
        },
        options: Options(headers: headers),
        cancelToken: _cancelToken,
      );

      final choices = response.data?['choices'] as List<dynamic>?;
      if (choices != null && choices.isNotEmpty) {
        final message = choices[0]['message'] as Map<String, dynamic>?;
        return message?['content'] as String? ?? '';
      }
      return '';
    } on Object catch (e) {
      throw AiProviderException('API call failed: $e', e);
    }
  }

  @override
  Stream<String> streamMessage({
    required String prompt,
    required String model,
    List<Map<String, String>>? history,
    String? systemPrompt,
  }) async* {
    _cancelToken = CancelToken();
    final messages = <Map<String, String>>[];
    if (systemPrompt != null && systemPrompt.isNotEmpty) {
      messages.add({'role': 'system', 'content': systemPrompt});
    }
    if (history != null) {
      messages.addAll(history);
    }
    messages.add({'role': 'user', 'content': prompt});

    final headers = <String, dynamic>{'Content-Type': 'application/json'};
    if (_apiKey.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_apiKey';
    }

    try {
      final response = await _dioClient.dio.post<ResponseBody>(
        _baseUrl,
        data: {
          'model': model,
          'messages': messages,
          'stream': true,
        },
        options: Options(
          responseType: ResponseType.stream,
          headers: headers,
          validateStatus: (status) => status != null && status < 500,
        ),
        cancelToken: _cancelToken,
      );

      final stream = response.data?.stream;
      if (stream == null) return;

      if (response.statusCode != 200) {
        final rawError = await utf8.decodeStream(stream);
        yield '⚠️ API Error (${response.statusCode}): $rawError';
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
      yield '⚠️ Connection failed: ${e.message}';
    } on Object catch (e) {
      yield 'Error: $e';
    }
  }

  @override
  void cancel() {
    _cancelToken?.cancel('User cancelled request');
  }
}
