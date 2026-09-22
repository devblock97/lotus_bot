import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotus_ai/app/theme/app_theme.dart';
import 'package:lotus_ai/core/database/app_database.dart';
import 'package:lotus_ai/core/network/dio_client.dart';
import 'package:lotus_ai/core/services/ai/ai_provider_registry.dart';
import 'package:lotus_ai/features/chat/interactor/chat_interactor.dart';
import 'package:lotus_ai/features/chat/interactor/chat_local_data_source.dart';
import 'package:lotus_ai/features/chat/interactor/chat_repository.dart';
import 'package:lotus_ai/features/conversation_list/interactor/conversation_list_interactor.dart';
import 'package:lotus_ai/features/conversation_list/router/conversation_list_router.dart';
import 'package:lotus_ai/features/settings/interactor/settings_interactor.dart';
import 'package:lotus_ai/features/settings/interactor/settings_local_data_source.dart';
import 'package:lotus_ai/features/settings/interactor/settings_repository.dart';
import 'package:lotus_ai/features/settings/presenter/settings_bloc.dart';
import 'package:lotus_ai/features/settings/presenter/settings_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Local Drift SQLite Database (Offline-First)
  final database = AppDatabase();

  // Initialize Networking & AI Engines
  final dioClient = DioClient();
  final aiRegistry = AiProviderRegistry(dioClient: dioClient);

  // Initialize Data Sources
  final chatLocalDataSource = ChatLocalDataSourceImpl(database);
  final settingsLocalDataSource = SettingsLocalDataSourceImpl(database);

  // Initialize Repositories
  final settingsRepository = SettingsRepositoryImpl(
    localDataSource: settingsLocalDataSource,
    aiRegistry: aiRegistry,
  );
  final chatRepository = ChatRepositoryImpl(
    localDataSource: chatLocalDataSource,
    settingsDataSource: settingsLocalDataSource,
    aiRegistry: aiRegistry,
  );

  // Initialize VIPER Interactors
  final settingsInteractor = SettingsInteractor(repository: settingsRepository);
  final chatInteractor = ChatInteractor(repository: chatRepository);
  final conversationListInteractor =
      ConversationListInteractor(repository: chatRepository);

  runApp(
    LotusAiApp(
      settingsInteractor: settingsInteractor,
      chatInteractor: chatInteractor,
      conversationListInteractor: conversationListInteractor,
    ),
  );
}

class LotusAiApp extends StatelessWidget {
  const LotusAiApp({
    required this.settingsInteractor,
    required this.chatInteractor,
    required this.conversationListInteractor,
    super.key,
  });

  final SettingsInteractor settingsInteractor;
  final ChatInteractor chatInteractor;
  final ConversationListInteractor conversationListInteractor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (_) => SettingsBloc(interactor: settingsInteractor),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (prev, curr) =>
            prev.settings.themeMode != curr.settings.themeMode,
        builder: (context, state) {
          final router = ConversationListRouter(
            conversationListInteractor: conversationListInteractor,
            chatInteractor: chatInteractor,
            settingsInteractor: settingsInteractor,
          );

          return MaterialApp(
            title: 'Lotus AI',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getTheme(state.settings.themeMode),
            home: router.buildAdaptiveHome(),
          );
        },
      ),
    );
  }
}
