import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:lotus_ai/features/chat/entity/conversation.dart';

@immutable
class ConversationListState extends Equatable {
  const ConversationListState({
    this.conversations = const [],
    this.filteredConversations = const [],
    this.searchQuery = '',
    this.isLoading = false,
    this.errorMessage,
    this.selectedConversationId,
  });

  final List<Conversation> conversations;
  final List<Conversation> filteredConversations;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;
  final String? selectedConversationId;

  ConversationListState copyWith({
    List<Conversation>? conversations,
    List<Conversation>? filteredConversations,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
    String? selectedConversationId,
    bool clearError = false,
  }) {
    return ConversationListState(
      conversations: conversations ?? this.conversations,
      filteredConversations:
          filteredConversations ?? this.filteredConversations,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedConversationId:
          selectedConversationId ?? this.selectedConversationId,
    );
  }

  @override
  List<Object?> get props => [
        conversations,
        filteredConversations,
        searchQuery,
        isLoading,
        errorMessage,
        selectedConversationId,
      ];
}
