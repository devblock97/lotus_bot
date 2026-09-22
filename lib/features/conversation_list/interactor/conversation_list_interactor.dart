import 'dart:async';
import 'package:lotus_ai/features/chat/entity/conversation.dart';
import 'package:lotus_ai/features/chat/entity/message.dart';
import 'package:lotus_ai/features/chat/interactor/chat_repository.dart';

class ConversationListInteractor {
  ConversationListInteractor({required ChatRepository repository})
      : _repository = repository;

  final ChatRepository _repository;

  Stream<List<Conversation>> watchConversations() =>
      _repository.watchConversations();

  Future<List<Conversation>> getConversations() =>
      _repository.getConversations();

  Future<Conversation> createConversation({
    String? title,
    String? modelName,
  }) {
    return _repository.createConversation(
      title: title ?? 'New Conversation',
      modelName: modelName ?? 'gemini-1.5-flash',
    );
  }

  Future<void> renameConversation(String id, String newTitle) =>
      _repository.renameConversation(id, newTitle);

  Future<void> deleteConversation(String id) =>
      _repository.deleteConversation(id);

  Future<void> togglePin(String id) => _repository.togglePin(id);

  Future<void> toggleFavourite(String id) =>
      _repository.toggleFavourite(id);

  Stream<List<Message>> watchMessages(String conversationId) =>
      _repository.watchMessages(conversationId);
}
