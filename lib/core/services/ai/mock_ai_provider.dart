import 'dart:async';
import 'package:lotus_ai/core/services/ai/ai_provider.dart';

class MockAiProvider implements AiProvider {
  bool _cancelled = false;

  @override
  String get providerId => 'mock';

  @override
  String get displayName => 'Neural AI (Mock)';

  @override
  List<String> get availableModels => [
        'gpt-4o',
        'gemini-1.5-pro',
        'claude-3-5-sonnet',
        'deepseek-r1',
      ];

  @override
  Future<String> sendMessage({
    required String prompt,
    required String model,
    List<Map<String, String>>? history,
    String? systemPrompt,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _generateResponseForPrompt(prompt);
  }

  @override
  Stream<String> streamMessage({
    required String prompt,
    required String model,
    List<Map<String, String>>? history,
    String? systemPrompt,
  }) async* {
    _cancelled = false;
    final fullResponse = _generateResponseForPrompt(prompt);
    final words = fullResponse.split(' ');

    for (var i = 0; i < words.length; i++) {
      if (_cancelled) break;
      await Future<void>.delayed(const Duration(milliseconds: 25));
      yield (i == 0) ? words[i] : ' ${words[i]}';
    }
  }

  @override
  void cancel() {
    _cancelled = true;
  }

  String _generateResponseForPrompt(String prompt) {
    final lower = prompt.toLowerCase();
    if (lower.contains('code') ||
        lower.contains('flutter') ||
        lower.contains('dart') ||
        lower.contains('python')) {
      return '''
Here is an example demonstrating VIPER architecture in Flutter using `flutter_bloc`:

```dart
// VIPER Presenter Bloc handling streaming tokens
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatInteractor _interactor;

  ChatBloc(this._interactor) : super(const ChatState()) {
    on<SendMessageEvent>(_onSendMessage);
  }
}
```

Key principles implemented:
- **View**: Pure Flutter widget tree without direct data access.
- **Interactor**: Executes business logic and database persistence.
- **Presenter**: Uses BLoC state streams to update UI reactively.
- **Entity**: Plain immutable Dart objects.
- **Router**: Wires up dependencies and screen navigation.''';
    } else if (lower.contains('hello') || lower.contains('hi')) {
      return 'Hello! I am your AI assistant running on Lotus AI. How can I assist you today?';
    }

    return 'Thank you for your message! Here is what you should know:\n\n'
        '1. **Offline-First**: All conversation data is stored locally in SQLite with Drift.\n'
        '2. **Local & Remote LLMs**: You can run Ollama locally or connect to Gemini, Grok, Alibaba Qwen, and custom models.\n'
        '3. **VIPER Architecture**: Separation of concerns gives you clean testability and modularity.\n\n'
        'What would you like to explore next?';
  }
}
