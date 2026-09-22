import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotus_ai/core/database/app_database.dart';
import 'package:lotus_ai/core/network/dio_client.dart';
import 'package:lotus_ai/core/services/ai/ai_provider_registry.dart';
import 'package:lotus_ai/features/chat/interactor/chat_interactor.dart';
import 'package:lotus_ai/features/chat/interactor/chat_local_data_source.dart';
import 'package:lotus_ai/features/chat/interactor/chat_repository.dart';
import 'package:lotus_ai/features/conversation_list/interactor/conversation_list_interactor.dart';
import 'package:lotus_ai/features/settings/interactor/settings_interactor.dart';
import 'package:lotus_ai/features/settings/interactor/settings_local_data_source.dart';
import 'package:lotus_ai/features/settings/interactor/settings_repository.dart';
import 'package:lotus_ai/main.dart';

void main() {
  late AppDatabase db;
  late SettingsInteractor settingsInteractor;
  late ChatInteractor chatInteractor;
  late ConversationListInteractor conversationListInteractor;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    final chatLocalDS = ChatLocalDataSourceImpl(db);
    final settingsDS = SettingsLocalDataSourceImpl(db);
    final dio = DioClient();
    final aiRegistry = AiProviderRegistry(dioClient: dio);

    final settingsRepo = SettingsRepositoryImpl(
      localDataSource: settingsDS,
      aiRegistry: aiRegistry,
    );
    final chatRepo = ChatRepositoryImpl(
      localDataSource: chatLocalDS,
      settingsDataSource: settingsDS,
      aiRegistry: aiRegistry,
    );

    settingsInteractor = SettingsInteractor(repository: settingsRepo);
    chatInteractor = ChatInteractor(repository: chatRepo);
    conversationListInteractor =
        ConversationListInteractor(repository: chatRepo);
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('LotusAiApp renders adaptive single-pane on mobile viewport', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      LotusAiApp(
        settingsInteractor: settingsInteractor,
        chatInteractor: chatInteractor,
        conversationListInteractor: conversationListInteractor,
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Lotus AI'), findsOneWidget);
    expect(find.text('New Chat'), findsOneWidget);

    // Cleanly unmount and drain timers
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('LotusAiApp renders adaptive dual-pane master-detail on desktop viewport', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      LotusAiApp(
        settingsInteractor: settingsInteractor,
        chatInteractor: chatInteractor,
        conversationListInteractor: conversationListInteractor,
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Lotus AI'), findsWidgets);
    expect(find.text('New Chat'), findsOneWidget);
    expect(find.text('Welcome to Lotus AI'), findsOneWidget);

    // Cleanly unmount and drain timers
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
