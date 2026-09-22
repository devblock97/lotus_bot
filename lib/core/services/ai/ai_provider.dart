import 'dart:async';

abstract class AiProvider {
  String get providerId;

  String get displayName;

  List<String> get availableModels;

  Future<String> sendMessage({
    required String prompt,
    required String model,
    List<Map<String, String>>? history,
    String? systemPrompt,
  });

  Stream<String> streamMessage({
    required String prompt,
    required String model,
    List<Map<String, String>>? history,
    String? systemPrompt,
  });

  void cancel();
}
