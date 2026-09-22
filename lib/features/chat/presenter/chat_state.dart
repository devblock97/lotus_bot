import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:lotus_ai/features/chat/entity/conversation.dart';
import 'package:lotus_ai/features/chat/entity/message.dart';

@immutable
class ChatState extends Equatable {
  const ChatState({
    this.conversationId,
    this.conversation,
    this.messages = const [],
    this.isLoading = false,
    this.isGenerating = false,
    this.streamingContent = '',
    this.errorMessage,
    this.draftInput = '',
    this.currentModel = 'gemini-1.5-flash',
  });

  final String? conversationId;
  final Conversation? conversation;
  final List<Message> messages;
  final bool isLoading;
  final bool isGenerating;
  final String streamingContent;
  final String? errorMessage;
  final String draftInput;
  final String currentModel;

  ChatState copyWith({
    String? conversationId,
    Conversation? conversation,
    List<Message>? messages,
    bool? isLoading,
    bool? isGenerating,
    String? streamingContent,
    String? errorMessage,
    String? draftInput,
    String? currentModel,
    bool clearError = false,
  }) {
    return ChatState(
      conversationId: conversationId ?? this.conversationId,
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isGenerating: isGenerating ?? this.isGenerating,
      streamingContent: streamingContent ?? this.streamingContent,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      draftInput: draftInput ?? this.draftInput,
      currentModel: currentModel ?? this.currentModel,
    );
  }

  @override
  List<Object?> get props => [
        conversationId,
        conversation,
        messages,
        isLoading,
        isGenerating,
        streamingContent,
        errorMessage,
        draftInput,
        currentModel,
      ];
}
