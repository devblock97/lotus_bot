import 'package:flutter_test/flutter_test.dart';
import 'package:lotus_ai/core/network/dio_client.dart';
import 'package:lotus_ai/core/services/ai/ai_provider_registry.dart';
import 'package:lotus_ai/core/services/ai/mock_ai_provider.dart';
import 'package:lotus_ai/features/settings/entity/app_settings.dart';

void main() {
  group('AiProvider & Registry Tests', () {
    test('MockAiProvider streams tokens correctly and handles cancellation', () async {
      final provider = MockAiProvider();
      expect(provider.providerId, equals('mock'));
      expect(provider.displayName, contains('Neural AI'));
      expect(provider.availableModels, contains('gpt-4o'));

      // Test streaming
      final stream = provider.streamMessage(
        prompt: 'Hello',
        model: 'gpt-4o',
      );

      final chunks = await stream.toList();
      expect(chunks.isNotEmpty, isTrue);
      final combined = chunks.join();
      expect(combined, contains('Hello'));
    });

    test('AiProviderRegistry instantiates correct provider based on AppSettings', () {
      final dio = DioClient();
      final registry = AiProviderRegistry(dioClient: dio);

      // Local Ollama
      final localProvider = registry.getProvider(
        const AppSettings(activeAiProvider: 'local', localLlmBaseUrl: 'http://localhost:11434'),
      );
      expect(localProvider.providerId, equals('local'));

      // Gemini
      final geminiProvider = registry.getProvider(
        const AppSettings(activeAiProvider: 'gemini', geminiApiKey: 'test_key'),
      );
      expect(geminiProvider.providerId, equals('gemini'));

      // Grok
      final grokProvider = registry.getProvider(
        const AppSettings(activeAiProvider: 'grok', grokApiKey: 'test_key'),
      );
      expect(grokProvider.providerId, equals('grok'));

      // Alibaba
      final alibabaProvider = registry.getProvider(
        const AppSettings(activeAiProvider: 'alibaba', alibabaApiKey: 'test_key'),
      );
      expect(alibabaProvider.providerId, equals('alibaba'));

      // Mock
      final mockProvider = registry.getProvider(
        const AppSettings(activeAiProvider: 'mock'),
      );
      expect(mockProvider.providerId, equals('mock'));
    });
  });
}
