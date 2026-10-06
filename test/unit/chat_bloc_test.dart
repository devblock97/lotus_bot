import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotus_ai/core/database/app_database.dart';
import 'package:lotus_ai/core/network/dio_client.dart';
import 'package:lotus_ai/core/services/ai/ai_provider_registry.dart';
import 'package:lotus_ai/core/services/ocr/ocr_service.dart';
import 'package:lotus_ai/features/chat/interactor/chat_interactor.dart';
import 'package:lotus_ai/features/chat/interactor/chat_local_data_source.dart';
import 'package:lotus_ai/features/chat/interactor/chat_repository.dart';
import 'package:lotus_ai/features/chat/presenter/chat_bloc.dart';
import 'package:lotus_ai/features/chat/presenter/chat_event.dart';
import 'package:lotus_ai/features/conversation_list/interactor/conversation_list_interactor.dart';
import 'package:lotus_ai/features/invoice_ocr/entity/invoice_ocr_result.dart';
import 'package:lotus_ai/features/settings/interactor/settings_local_data_source.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(File('dummy.jpg'));
  });
  late AppDatabase db;
  late ChatLocalDataSource chatLocalDS;
  late SettingsLocalDataSource settingsDS;
  late ChatRepository chatRepo;
  late ChatInteractor chatInteractor;
  late ConversationListInteractor convListInteractor;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    chatLocalDS = ChatLocalDataSourceImpl(db);
    settingsDS = SettingsLocalDataSourceImpl(db);
    final dio = DioClient();
    final aiRegistry = AiProviderRegistry(dioClient: dio);

    chatRepo = ChatRepositoryImpl(
      localDataSource: chatLocalDS,
      settingsDataSource: settingsDS,
      aiRegistry: aiRegistry,
    );

    chatInteractor = ChatInteractor(repository: chatRepo);
    convListInteractor = ConversationListInteractor(repository: chatRepo);
  });

  tearDown(() async {
    await db.close();
  });

  group('Offline-First Database & VIPER Interactor Tests', () {
    test('Create conversation, save message, and query messages offline', () async {
      // 1. Create conversation
      final conversation = await convListInteractor.createConversation(
        title: 'Test Offline Chat',
        modelName: 'gpt-4o',
      );
      expect(conversation.id.isNotEmpty, isTrue);
      expect(conversation.title, equals('Test Offline Chat'));

      // 2. Save user message offline
      final userMessage = await chatInteractor.saveUserMessage(
        conversationId: conversation.id,
        content: 'Hello, offline AI!',
      );
      expect(userMessage.content, equals('Hello, offline AI!'));

      // 3. Save assistant message offline
      final assistantMsg = await chatInteractor.saveAssistantMessage(
        conversationId: conversation.id,
        content: 'Hello! I am ready.',
      );
      expect(assistantMsg.content, equals('Hello! I am ready.'));

      // 4. Query messages from SQLite
      final messages = await chatRepo.getMessages(conversation.id);
      expect(messages.length, equals(2));
      expect(messages.first.content, equals('Hello, offline AI!'));
      expect(messages.last.content, equals('Hello! I am ready.'));
    });
  });

  group('ChatBloc VIPER Presenter Tests', () {
    test('ChatBloc emits messages when initialized with conversation', () async {
      final conv = await convListInteractor.createConversation(title: 'ChatBloc Test');
      await chatInteractor.saveUserMessage(
        conversationId: conv.id,
        content: 'Initial user query',
      );

      final bloc = ChatBloc(
        interactor: chatInteractor,
        initialConversationId: conv.id,
      );

      // Allow async stream to pipe messages
      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(bloc.state.conversationId, equals(conv.id));
      expect(bloc.state.messages.isNotEmpty, isTrue);
      expect(bloc.state.messages.first.content, equals('Initial user query'));

      await bloc.close();
    });

    test('ChatBloc sendMessage triggers streaming and emits chunks', () async {
      final conv = await convListInteractor.createConversation(title: 'Streaming Test');
      final bloc = ChatBloc(
        interactor: chatInteractor,
        initialConversationId: conv.id,
      );

      bloc.add(const SendMessageEvent('hi'));

      // Wait for mock AI streaming to progress
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(bloc.state.isGenerating, isTrue);

      // Wait for mock AI streaming to complete
      await Future<void>.delayed(const Duration(milliseconds: 600));
      expect(bloc.state.isGenerating, isFalse);

      final storedMsgs = await chatRepo.getMessages(conv.id);
      expect(storedMsgs.length, greaterThanOrEqualTo(2));

      await bloc.close();
    });

    test('ChatBloc sendMessage with attached invoice triggers on-device OCR and AI extraction', () async {
      final mockOcr = MockOcrService();
      when(() => mockOcr.processImage(any())).thenAnswer(
        (_) async => const InvoiceOcrResult(
          rawText: 'Starbucks Coffee\nTotal: \$5.50\nDate: 2026-10-05',
          blocks: [],
        ),
      );

      final ocrChatInteractor = ChatInteractor(
        repository: chatRepo,
        ocrService: mockOcr,
      );

      final conv = await convListInteractor.createConversation(title: 'Invoice Test');
      final bloc = ChatBloc(
        interactor: ocrChatInteractor,
        initialConversationId: conv.id,
      );

      bloc.add(const SendMessageEvent('Analyze this bill', attachedImagePath: 'sample_bill.jpg'));

      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(bloc.state.isGenerating, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 600));
      expect(bloc.state.isGenerating, isFalse);

      final storedMsgs = await chatRepo.getMessages(conv.id);
      expect(storedMsgs.first.content, contains('[INVOICE_IMAGE:sample_bill.jpg]'));
      expect(storedMsgs.first.content, contains('Analyze this bill'));

      await bloc.close();
    });
  });
}

class MockOcrService extends Mock implements OcrService {}
