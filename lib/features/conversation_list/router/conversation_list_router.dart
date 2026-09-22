import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotus_ai/core/utils/responsive.dart';
import 'package:lotus_ai/features/chat/interactor/chat_interactor.dart';
import 'package:lotus_ai/features/chat/router/chat_router.dart';
import 'package:lotus_ai/features/conversation_list/interactor/conversation_list_interactor.dart';
import 'package:lotus_ai/features/conversation_list/presenter/conversation_list_bloc.dart';
import 'package:lotus_ai/features/conversation_list/view/adaptive_home_screen.dart';
import 'package:lotus_ai/features/conversation_list/view/conversation_list_screen.dart';
import 'package:lotus_ai/features/settings/interactor/settings_interactor.dart';
import 'package:lotus_ai/features/settings/router/settings_router.dart';

class ConversationListRouter {
  ConversationListRouter({
    required ConversationListInteractor conversationListInteractor,
    required ChatInteractor chatInteractor,
    required SettingsInteractor settingsInteractor,
  })  : _conversationListInteractor = conversationListInteractor,
        _chatInteractor = chatInteractor,
        _settingsInteractor = settingsInteractor;

  final ConversationListInteractor _conversationListInteractor;
  final ChatInteractor _chatInteractor;
  final SettingsInteractor _settingsInteractor;

  /// Builds the adaptive home view (phone single-pane, tablet/desktop dual-pane).
  Widget buildAdaptiveHome() {
    return BlocProvider<ConversationListBloc>(
      create: (context) => ConversationListBloc(
        interactor: _conversationListInteractor,
      ),
      child: AdaptiveHomeScreen(
        router: this,
        interactor: _conversationListInteractor,
        chatRouter: ChatRouter(
          interactor: _chatInteractor,
          settingsInteractor: _settingsInteractor,
        ),
      ),
    );
  }

  /// Builds standard conversation list view.
  Widget buildConversationListView() {
    return BlocProvider<ConversationListBloc>(
      create: (context) => ConversationListBloc(
        interactor: _conversationListInteractor,
      ),
      child: ConversationListScreen(
        router: this,
        interactor: _conversationListInteractor,
      ),
    );
  }

  /// Navigates to the active Chat screen for a given conversation.
  void openChat(BuildContext context, String conversationId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChatRouter(
          interactor: _chatInteractor,
          settingsInteractor: _settingsInteractor,
        ).buildChatView(conversationId),
      ),
    );
  }

  /// Navigates to the AI Settings screen (adaptive dialog on desktop, page on mobile).
  void openSettings(BuildContext context) {
    final isWide = Responsive.isWide(context);
    final settingsView =
        SettingsRouter(interactor: _settingsInteractor).buildSettingsView();

    if (isWide) {
      showDialog<void>(
        context: context,
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650, maxHeight: 750),
            child: settingsView,
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => settingsView),
      );
    }
  }
}
