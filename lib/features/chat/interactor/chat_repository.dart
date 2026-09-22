import 'dart:async';
import 'package:lotus_ai/core/services/ai/ai_provider_registry.dart';
import 'package:lotus_ai/features/chat/entity/conversation.dart';
import 'package:lotus_ai/features/chat/entity/message.dart';
import 'package:lotus_ai/features/chat/interactor/chat_local_data_source.dart';
import 'package:lotus_ai/features/settings/interactor/settings_local_data_source.dart';

abstract class ChatRepository {
  Stream<List<Conversation>> watchConversations();
  Future<List<Conversation>> getConversations();
  Future<Conversation?> getConversation(String id);
  Future<Conversation> createConversation({
    required String title,
    String? modelName,
    String? id,
  });
  Future<void> renameConversation(String id, String newTitle);
  Future<void> deleteConversation(String id);
  Future<void> togglePin(String id);
  Future<void> toggleFavourite(String id);
  Future<void> saveDraft(String id, String draft);

  Stream<List<Message>> watchMessages(String conversationId);
  Future<List<Message>> getMessages(String conversationId);
  Future<void> saveMessage(Message message);
  Future<void> deleteMessage(String messageId);

  Stream<String> streamAiResponse({
    required String prompt,
    required String model,
    required List<Message> history,
    String? systemPrompt,
  });
  void cancelGeneration();
}

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required ChatLocalDataSource localDataSource,
    required SettingsLocalDataSource settingsDataSource,
    required AiProviderRegistry aiRegistry,
  })  : _localDataSource = localDataSource,
        _settingsDataSource = settingsDataSource,
        _aiRegistry = aiRegistry;

  final ChatLocalDataSource _localDataSource;
  final SettingsLocalDataSource _settingsDataSource;
  final AiProviderRegistry _aiRegistry;

  @override
  Stream<List<Conversation>> watchConversations() =>
      _localDataSource.watchConversations();

  @override
  Future<List<Conversation>> getConversations() =>
      _localDataSource.getConversations();

  @override
  Future<Conversation?> getConversation(String id) =>
      _localDataSource.getConversation(id);

  @override
  Future<Conversation> createConversation({
    required String title,
    String? modelName,
    String? id,
  }) =>
      _localDataSource.createConversation(
        title: title,
        modelName: modelName,
        id: id,
      );

  @override
  Future<void> renameConversation(String id, String newTitle) =>
      _localDataSource.renameConversation(id, newTitle);

  @override
  Future<void> deleteConversation(String id) =>
      _localDataSource.deleteConversation(id);

  @override
  Future<void> togglePin(String id) => _localDataSource.togglePin(id);

  @override
  Future<void> toggleFavourite(String id) =>
      _localDataSource.toggleFavourite(id);

  @override
  Future<void> saveDraft(String id, String draft) =>
      _localDataSource.saveDraft(id, draft);

  @override
  Stream<List<Message>> watchMessages(String conversationId) =>
      _localDataSource.watchMessages(conversationId);

  @override
  Future<List<Message>> getMessages(String conversationId) =>
      _localDataSource.getMessages(conversationId);

  @override
  Future<void> saveMessage(Message message) =>
      _localDataSource.saveMessage(message);

  @override
  Future<void> deleteMessage(String messageId) =>
      _localDataSource.deleteMessage(messageId);

  @override
  Stream<String> streamAiResponse({
    required String prompt,
    required String model,
    required List<Message> history,
    String? systemPrompt,
  }) async* {
    final settings = await _settingsDataSource.getSettings();
    final provider = _aiRegistry.getProvider(settings);

    final formattedHistory = history
        .map((m) => {'role': m.role.name, 'content': m.content})
        .toList();

    yield* provider.streamMessage(
      prompt: prompt,
      model: model,
      history: formattedHistory,
      systemPrompt: systemPrompt ?? settings.systemPrompt,
    );
  }

  @override
  void cancelGeneration() {
    // Read current settings and cancel active provider
    _settingsDataSource.getSettings().then((settings) {
      final provider = _aiRegistry.getProvider(settings);
      provider.cancel();
    });
  }
}
