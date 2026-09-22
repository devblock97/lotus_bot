import 'package:lotus_ai/core/network/dio_client.dart';
import 'package:lotus_ai/core/services/ai/ai_provider.dart';
import 'package:lotus_ai/core/services/ai/alibaba_ai_provider.dart';
import 'package:lotus_ai/core/services/ai/gemini_ai_provider.dart';
import 'package:lotus_ai/core/services/ai/grok_ai_provider.dart';
import 'package:lotus_ai/core/services/ai/local_ai_provider.dart';
import 'package:lotus_ai/core/services/ai/mock_ai_provider.dart';
import 'package:lotus_ai/core/services/ai/openai_compatible_provider.dart';
import 'package:lotus_ai/features/settings/entity/app_settings.dart';

class AiProviderRegistry {
  AiProviderRegistry({required DioClient dioClient}) : _dioClient = dioClient;

  final DioClient _dioClient;

  AiProvider getProvider(AppSettings settings) {
    switch (settings.activeAiProvider) {
      case 'gemini':
        return GeminiAiProvider(
          dioClient: _dioClient,
          apiKey: settings.geminiApiKey,
        );
      case 'grok':
        return GrokAiProvider(
          dioClient: _dioClient,
          apiKey: settings.grokApiKey,
        );
      case 'alibaba':
        return AlibabaAiProvider(
          dioClient: _dioClient,
          apiKey: settings.alibabaApiKey,
          endpoint: settings.customEndpoint.isNotEmpty
              ? settings.customEndpoint
              : null,
        );
      case 'local':
        return LocalAiProvider(
          dioClient: _dioClient,
          baseUrl: settings.localLlmBaseUrl,
        );
      case 'openai_compatible':
        return OpenAiCompatibleProvider(
          dioClient: _dioClient,
          baseUrl: settings.customEndpoint,
          apiKey: settings.customApiKey,
        );
      case 'mock':
      default:
        return MockAiProvider();
    }
  }

  static List<AiProviderDescriptor> get supportedProviders => const [
        AiProviderDescriptor(
          id: 'local',
          name: 'Local LLM (Ollama)',
          description: '100% Offline inference on your device / local network',
          isOfflineCapable: true,
          defaultModel: 'llama3.2',
        ),
        AiProviderDescriptor(
          id: 'gemini',
          name: 'Google Gemini',
          description: 'High-speed multimodal intelligence from Google AI Studio',
          isOfflineCapable: false,
          defaultModel: 'gemini-2.0-flash',
        ),
        AiProviderDescriptor(
          id: 'grok',
          name: 'xAI Grok',
          description: 'Frontier models with real-time knowledge and reasoning',
          isOfflineCapable: false,
          defaultModel: 'grok-2-latest',
        ),
        AiProviderDescriptor(
          id: 'alibaba',
          name: 'Alibaba Cloud (Qwen)',
          description: 'Industry-leading multilingual Qwen 2.5 series',
          isOfflineCapable: false,
          defaultModel: 'qwen-turbo',
        ),
        AiProviderDescriptor(
          id: 'openai_compatible',
          name: 'OpenAI / Custom Endpoint',
          description: 'Any OpenAI-compatible server (LM Studio, vLLM, DeepSeek, etc.)',
          isOfflineCapable: false,
          defaultModel: 'gpt-4o',
        ),
        AiProviderDescriptor(
          id: 'mock',
          name: 'Neural AI (Mock)',
          description: 'Simulated streaming for instant offline UI testing',
          isOfflineCapable: true,
          defaultModel: 'gpt-4o',
        ),
      ];
}

class AiProviderDescriptor {
  const AiProviderDescriptor({
    required this.id,
    required this.name,
    required this.description,
    required this.isOfflineCapable,
    required this.defaultModel,
  });

  final String id;
  final String name;
  final String description;
  final bool isOfflineCapable;
  final String defaultModel;
}
