import 'dart:async';
import 'dart:io';
import 'package:lotus_ai/core/services/ocr/ocr_service.dart';
import 'package:lotus_ai/features/chat/entity/conversation.dart';
import 'package:lotus_ai/features/chat/entity/message.dart';
import 'package:lotus_ai/features/chat/interactor/chat_repository.dart';
import 'package:lotus_ai/features/invoice_ocr/entity/invoice_ocr_result.dart';

class ChatInteractor {
  ChatInteractor({
    required ChatRepository repository,
    OcrService? ocrService,
  })  : _repository = repository,
        _ocrService = ocrService ?? MlKitOcrService();

  final ChatRepository _repository;
  final OcrService _ocrService;

  /// Runs on-device OCR on the attached invoice image
  Future<InvoiceOcrResult> extractInvoiceText(File imageFile) =>
      _ocrService.processImage(imageFile);

  Stream<List<Message>> watchMessages(String conversationId) =>
      _repository.watchMessages(conversationId);

  Future<Conversation?> getConversation(String conversationId) =>
      _repository.getConversation(conversationId);

  Future<Message> saveUserMessage({
    required String conversationId,
    required String content,
  }) async {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: conversationId,
      role: MessageRole.user,
      content: content.trim(),
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    await _repository.saveMessage(message);
    await _repository.saveDraft(conversationId, '');
    return message;
  }

  /// Streams chunks from the selected AI provider.
  Stream<String> streamAiResponse({
    required String prompt,
    required String model,
    required List<Message> history,
    String? systemPrompt,
  }) {
    return _repository.streamAiResponse(
      prompt: prompt,
      model: model,
      history: history,
      systemPrompt: systemPrompt,
    );
  }

  Future<Message> saveAssistantMessage({
    required String conversationId,
    required String content,
    bool isError = false,
  }) async {
    final message = Message(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      conversationId: conversationId,
      role: MessageRole.assistant,
      content: content,
      timestamp: DateTime.now(),
      isError: isError,
      status: isError ? MessageStatus.error : MessageStatus.sent,
    );

    await _repository.saveMessage(message);
    return message;
  }

  void stopGeneration() {
    _repository.cancelGeneration();
  }

  Future<void> saveDraft(String conversationId, String draft) =>
      _repository.saveDraft(conversationId, draft);

  Future<void> deleteMessage(String messageId) =>
      _repository.deleteMessage(messageId);
}
