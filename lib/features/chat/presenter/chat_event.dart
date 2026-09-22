import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:lotus_ai/features/chat/entity/message.dart';

@immutable
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class InitChatEvent extends ChatEvent {
  const InitChatEvent(this.conversationId);
  final String conversationId;

  @override
  List<Object?> get props => [conversationId];
}

class MessagesUpdatedEvent extends ChatEvent {
  const MessagesUpdatedEvent(this.messages);
  final List<Message> messages;

  @override
  List<Object?> get props => [messages];
}

class SendMessageEvent extends ChatEvent {
  const SendMessageEvent(this.text);
  final String text;

  @override
  List<Object?> get props => [text];
}

class StreamChunkEvent extends ChatEvent {
  const StreamChunkEvent(this.chunk);
  final String chunk;

  @override
  List<Object?> get props => [chunk];
}

class StreamCompletedEvent extends ChatEvent {
  const StreamCompletedEvent();
}

class StreamErrorEvent extends ChatEvent {
  const StreamErrorEvent(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}

class StopGenerationEvent extends ChatEvent {
  const StopGenerationEvent();
}

class RegenerateResponseEvent extends ChatEvent {
  const RegenerateResponseEvent();
}

class RetryMessageEvent extends ChatEvent {
  const RetryMessageEvent(this.message);
  final Message message;

  @override
  List<Object?> get props => [message];
}

class UpdateDraftEvent extends ChatEvent {
  const UpdateDraftEvent(this.draft);
  final String draft;

  @override
  List<Object?> get props => [draft];
}

class DeleteMessageEvent extends ChatEvent {
  const DeleteMessageEvent(this.messageId);
  final String messageId;

  @override
  List<Object?> get props => [messageId];
}

class SwitchModelEvent extends ChatEvent {
  const SwitchModelEvent(this.model);
  final String model;

  @override
  List<Object?> get props => [model];
}
