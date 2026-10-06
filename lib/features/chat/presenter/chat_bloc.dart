import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotus_ai/core/logging/app_logger.dart';
import 'package:lotus_ai/features/chat/entity/message.dart';
import 'package:lotus_ai/features/chat/interactor/chat_interactor.dart';
import 'package:lotus_ai/features/chat/presenter/chat_event.dart';
import 'package:lotus_ai/features/chat/presenter/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required ChatInteractor interactor,
    String? initialConversationId,
  })  : _interactor = interactor,
        super(ChatState(conversationId: initialConversationId)) {
    on<InitChatEvent>(_onInitChat);
    on<MessagesUpdatedEvent>(_onMessagesUpdated);
    on<SendMessageEvent>(_onSendMessage);
    on<StreamChunkEvent>(_onStreamChunk);
    on<StreamCompletedEvent>(_onStreamCompleted);
    on<StreamErrorEvent>(_onStreamError);
    on<StopGenerationEvent>(_onStopGeneration);
    on<RegenerateResponseEvent>(_onRegenerateResponse);
    on<RetryMessageEvent>(_onRetryMessage);
    on<UpdateDraftEvent>(_onUpdateDraft);
    on<DeleteMessageEvent>(_onDeleteMessage);
    on<SwitchModelEvent>(_onSwitchModel);

    if (initialConversationId != null) {
      add(InitChatEvent(initialConversationId));
    }
  }

  final ChatInteractor _interactor;
  StreamSubscription<List<Message>>? _messagesSubscription;
  StreamSubscription<String>? _aiStreamSubscription;

  Future<void> _onInitChat(
    InitChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    await _messagesSubscription?.cancel();
    await _aiStreamSubscription?.cancel();

    emit(state.copyWith(
      conversationId: event.conversationId,
      isLoading: true,
      clearError: true,
    ));

    final conversation =
        await _interactor.getConversation(event.conversationId);

    _messagesSubscription = _interactor
        .watchMessages(event.conversationId)
        .listen((messages) {
      add(MessagesUpdatedEvent(messages));
    });

    emit(state.copyWith(
      conversation: conversation,
      draftInput: conversation?.draftMessage ?? '',
      currentModel: conversation?.modelName ?? state.currentModel,
      isLoading: false,
    ));
  }

  void _onMessagesUpdated(
    MessagesUpdatedEvent event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(messages: event.messages));
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final convId = state.conversationId;
    if (convId == null) return;

    var text = event.text.trim();
    final imagePath = event.attachedImagePath;
    if (text.isEmpty && imagePath == null) return;

    emit(state.copyWith(clearError: true));

    try {
      String promptForAi;
      String messageContentForStorage;

      if (imagePath != null) {
        final imageFile = File(imagePath);
        emit(state.copyWith(
          isGenerating: true,
          streamingContent: 'Scanning invoice on-device with ML Kit...',
        ));

        // Run on-device OCR asynchronously
        final ocrResult = await _interactor.extractInvoiceText(imageFile);

        final userPrompt = text.isNotEmpty
            ? text
            : 'Please analyze and extract all key information from this invoice (merchant, date, line items, amounts, subtotal, tax, and total).';

        // Format AI prompt with user prompt and OCR recognized data
        promptForAi = '''
$userPrompt

--- Attached Invoice OCR Data ---
${ocrResult.rawText}
---------------------------------
Please extract and structure the key information from this invoice cleanly using Markdown (including a table of line items, merchant, date, amounts, taxes, and total).
''';

        messageContentForStorage = '[INVOICE_IMAGE:$imagePath]\n$userPrompt';
      } else {
        promptForAi = text;
        messageContentForStorage = text;
      }

      // Persist user message to SQLite immediately (Offline-First)
      await _interactor.saveUserMessage(
        conversationId: convId,
        content: messageContentForStorage,
      );

      // Start streaming AI tokens
      _startStreaming(convId, promptForAi, emit);
    } catch (e, st) {
      AppLogger.error('Failed to send message', e, st);
      emit(state.copyWith(
        isGenerating: false,
        streamingContent: '',
        errorMessage: 'Failed to send message: $e',
      ));
    }
  }

  void _startStreaming(String convId, String userPrompt, Emitter<ChatState> emit) {
    _aiStreamSubscription?.cancel();

    emit(state.copyWith(
      isGenerating: true,
      streamingContent: '',
      clearError: true,
    ));

    var accumulatedText = '';
    final history = List<Message>.from(state.messages);

    final stream = _interactor.streamAiResponse(
      prompt: userPrompt,
      model: state.currentModel,
      history: history,
      systemPrompt: state.conversation?.systemPrompt,
    );

    _aiStreamSubscription = stream.listen(
      (chunk) {
        accumulatedText += chunk;
        add(StreamChunkEvent(accumulatedText));
      },
      onDone: () {
        add(const StreamCompletedEvent());
      },
      onError: (Object error) {
        add(StreamErrorEvent(error.toString()));
      },
    );
  }

  void _onStreamChunk(
    StreamChunkEvent event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(
      isGenerating: true,
      streamingContent: event.chunk,
    ));
  }

  Future<void> _onStreamCompleted(
    StreamCompletedEvent event,
    Emitter<ChatState> emit,
  ) async {
    final convId = state.conversationId;
    final content = state.streamingContent;

    if (convId != null && content.isNotEmpty) {
      await _interactor.saveAssistantMessage(
        conversationId: convId,
        content: content,
        isError: false,
      );
    }

    emit(state.copyWith(
      isGenerating: false,
      streamingContent: '',
    ));
  }

  Future<void> _onStreamError(
    StreamErrorEvent event,
    Emitter<ChatState> emit,
  ) async {
    final convId = state.conversationId;
    final partial = state.streamingContent;
    final errorMsg = event.error;

    if (convId != null) {
      final savedText = partial.isNotEmpty
          ? '$partial\n\n⚠️ Error: $errorMsg'
          : '⚠️ Failed to generate response: $errorMsg';
      await _interactor.saveAssistantMessage(
        conversationId: convId,
        content: savedText,
        isError: true,
      );
    }

    emit(state.copyWith(
      isGenerating: false,
      streamingContent: '',
      errorMessage: errorMsg,
    ));
  }

  Future<void> _onStopGeneration(
    StopGenerationEvent event,
    Emitter<ChatState> emit,
  ) async {
    await _aiStreamSubscription?.cancel();
    _interactor.stopGeneration();

    final convId = state.conversationId;
    final content = state.streamingContent;

    if (convId != null && content.isNotEmpty) {
      await _interactor.saveAssistantMessage(
        conversationId: convId,
        content: '$content [Stopped]',
        isError: false,
      );
    }

    emit(state.copyWith(
      isGenerating: false,
      streamingContent: '',
    ));
  }

  void _onRegenerateResponse(
    RegenerateResponseEvent event,
    Emitter<ChatState> emit,
  ) {
    final convId = state.conversationId;
    if (convId == null || state.messages.isEmpty) return;

    final lastUserMsg = state.messages.lastWhere(
      (m) => m.role.isUser,
      orElse: () => state.messages.last,
    );

    _startStreaming(convId, lastUserMsg.content, emit);
  }

  void _onRetryMessage(
    RetryMessageEvent event,
    Emitter<ChatState> emit,
  ) {
    if (event.message.role.isUser) {
      add(SendMessageEvent(event.message.content));
    } else {
      add(const RegenerateResponseEvent());
    }
  }

  Future<void> _onUpdateDraft(
    UpdateDraftEvent event,
    Emitter<ChatState> emit,
  ) async {
    final convId = state.conversationId;
    emit(state.copyWith(draftInput: event.draft));
    if (convId != null) {
      await _interactor.saveDraft(convId, event.draft);
    }
  }

  Future<void> _onDeleteMessage(
    DeleteMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    await _interactor.deleteMessage(event.messageId);
  }

  void _onSwitchModel(
    SwitchModelEvent event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(currentModel: event.model));
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    _aiStreamSubscription?.cancel();
    return super.close();
  }
}
