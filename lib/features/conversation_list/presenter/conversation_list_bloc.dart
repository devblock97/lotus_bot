import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotus_ai/core/logging/app_logger.dart';
import 'package:lotus_ai/features/chat/entity/conversation.dart';
import 'package:lotus_ai/features/conversation_list/interactor/conversation_list_interactor.dart';
import 'package:lotus_ai/features/conversation_list/presenter/conversation_list_event.dart';
import 'package:lotus_ai/features/conversation_list/presenter/conversation_list_state.dart';

class ConversationListBloc
    extends Bloc<ConversationListEvent, ConversationListState> {
  ConversationListBloc({
    required ConversationListInteractor interactor,
  })  : _interactor = interactor,
        super(const ConversationListState()) {
    on<LoadConversationsEvent>(_onLoadConversations);
    on<ConversationsUpdatedEvent>(_onConversationsUpdated);
    on<SearchConversationsEvent>(_onSearchConversations);
    on<CreateConversationEvent>(_onCreateConversation);
    on<DeleteConversationEvent>(_onDeleteConversation);
    on<TogglePinEvent>(_onTogglePin);
    on<ToggleFavouriteEvent>(_onToggleFavourite);
    on<RenameConversationEvent>(_onRenameConversation);

    add(const LoadConversationsEvent());
  }

  final ConversationListInteractor _interactor;
  StreamSubscription<List<Conversation>>? _conversationsSubscription;

  Future<void> _onLoadConversations(
    LoadConversationsEvent event,
    Emitter<ConversationListState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await _conversationsSubscription?.cancel();

    _conversationsSubscription =
        _interactor.watchConversations().listen((conversations) {
      add(ConversationsUpdatedEvent(conversations));
    });
  }

  void _onConversationsUpdated(
    ConversationsUpdatedEvent event,
    Emitter<ConversationListState> emit,
  ) {
    final filtered = _applyFilter(event.conversations, state.searchQuery);
    emit(state.copyWith(
      conversations: event.conversations,
      filteredConversations: filtered,
      isLoading: false,
    ));
  }

  void _onSearchConversations(
    SearchConversationsEvent event,
    Emitter<ConversationListState> emit,
  ) {
    final filtered = _applyFilter(state.conversations, event.query);
    emit(state.copyWith(
      searchQuery: event.query,
      filteredConversations: filtered,
    ));
  }

  Future<void> _onCreateConversation(
    CreateConversationEvent event,
    Emitter<ConversationListState> emit,
  ) async {
    try {
      final newConv = await _interactor.createConversation(
        title: event.title,
        modelName: event.modelName,
      );
      emit(state.copyWith(selectedConversationId: newConv.id));
    } catch (e, st) {
      AppLogger.error('Failed to create conversation', e, st);
      emit(state.copyWith(errorMessage: 'Failed to create conversation: $e'));
    }
  }

  Future<void> _onDeleteConversation(
    DeleteConversationEvent event,
    Emitter<ConversationListState> emit,
  ) async {
    try {
      await _interactor.deleteConversation(event.id);
    } catch (e, st) {
      AppLogger.error('Failed to delete conversation', e, st);
      emit(state.copyWith(errorMessage: 'Failed to delete conversation: $e'));
    }
  }

  Future<void> _onTogglePin(
    TogglePinEvent event,
    Emitter<ConversationListState> emit,
  ) async {
    try {
      await _interactor.togglePin(event.id);
    } catch (e, st) {
      AppLogger.error('Failed to pin conversation', e, st);
    }
  }

  Future<void> _onToggleFavourite(
    ToggleFavouriteEvent event,
    Emitter<ConversationListState> emit,
  ) async {
    try {
      await _interactor.toggleFavourite(event.id);
    } catch (e, st) {
      AppLogger.error('Failed to favorite conversation', e, st);
    }
  }

  Future<void> _onRenameConversation(
    RenameConversationEvent event,
    Emitter<ConversationListState> emit,
  ) async {
    try {
      await _interactor.renameConversation(event.id, event.title);
    } catch (e, st) {
      AppLogger.error('Failed to rename conversation', e, st);
    }
  }

  List<Conversation> _applyFilter(
    List<Conversation> list,
    String query,
  ) {
    if (query.trim().isEmpty) return list;
    final lower = query.toLowerCase();
    return list
        .where((c) => c.title.toLowerCase().contains(lower))
        .toList();
  }

  @override
  Future<void> close() {
    _conversationsSubscription?.cancel();
    return super.close();
  }
}
