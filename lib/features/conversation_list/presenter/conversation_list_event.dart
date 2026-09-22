import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:lotus_ai/features/chat/entity/conversation.dart';

@immutable
abstract class ConversationListEvent extends Equatable {
  const ConversationListEvent();

  @override
  List<Object?> get props => [];
}

class LoadConversationsEvent extends ConversationListEvent {
  const LoadConversationsEvent();
}

class ConversationsUpdatedEvent extends ConversationListEvent {
  const ConversationsUpdatedEvent(this.conversations);
  final List<Conversation> conversations;

  @override
  List<Object?> get props => [conversations];
}

class SearchConversationsEvent extends ConversationListEvent {
  const SearchConversationsEvent(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

class CreateConversationEvent extends ConversationListEvent {
  const CreateConversationEvent({this.title, this.modelName});
  final String? title;
  final String? modelName;

  @override
  List<Object?> get props => [title, modelName];
}

class DeleteConversationEvent extends ConversationListEvent {
  const DeleteConversationEvent(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class TogglePinEvent extends ConversationListEvent {
  const TogglePinEvent(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class ToggleFavouriteEvent extends ConversationListEvent {
  const ToggleFavouriteEvent(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class RenameConversationEvent extends ConversationListEvent {
  const RenameConversationEvent(this.id, this.title);
  final String id;
  final String title;

  @override
  List<Object?> get props => [id, title];
}
