import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotus_ai/features/chat/interactor/chat_interactor.dart';
import 'package:lotus_ai/features/chat/presenter/chat_bloc.dart';
import 'package:lotus_ai/features/chat/view/chat_screen.dart';
import 'package:lotus_ai/features/settings/interactor/settings_interactor.dart';
import 'package:lotus_ai/features/settings/router/settings_router.dart';

class ChatRouter {
  ChatRouter({
    required ChatInteractor interactor,
    required SettingsInteractor settingsInteractor,
  })  : _interactor = interactor,
        _settingsInteractor = settingsInteractor;

  final ChatInteractor _interactor;
  final SettingsInteractor _settingsInteractor;

  Widget buildChatView(
    String conversationId, {
    bool showBackButton = true,
    VoidCallback? onToggleSidebar,
    bool isSidebarOpen = true,
  }) {
    return BlocProvider<ChatBloc>(
      key: ValueKey(conversationId),
      create: (context) => ChatBloc(
        interactor: _interactor,
        initialConversationId: conversationId,
      ),
      child: ChatScreen(
        router: this,
        showBackButton: showBackButton,
        onToggleSidebar: onToggleSidebar,
        isSidebarOpen: isSidebarOpen,
      ),
    );
  }

  void navigateToSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SettingsRouter(interactor: _settingsInteractor).buildSettingsView(),
      ),
    );
  }

  void pop(BuildContext context) {
    Navigator.of(context).pop();
  }
}
