import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotus_ai/core/utils/responsive.dart';
import 'package:lotus_ai/features/chat/router/chat_router.dart';
import 'package:lotus_ai/features/conversation_list/interactor/conversation_list_interactor.dart';
import 'package:lotus_ai/features/conversation_list/presenter/conversation_list_bloc.dart';
import 'package:lotus_ai/features/conversation_list/presenter/conversation_list_state.dart';
import 'package:lotus_ai/features/conversation_list/router/conversation_list_router.dart';
import 'package:lotus_ai/features/conversation_list/view/conversation_list_screen.dart';

class AdaptiveHomeScreen extends StatefulWidget {
  const AdaptiveHomeScreen({
    required this.router,
    required this.interactor,
    required this.chatRouter,
    super.key,
  });

  final ConversationListRouter router;
  final ConversationListInteractor interactor;
  final ChatRouter chatRouter;

  @override
  State<AdaptiveHomeScreen> createState() => _AdaptiveHomeScreenState();
}

class _AdaptiveHomeScreenState extends State<AdaptiveHomeScreen> {
  String? _selectedConversationId;
  bool _isSidebarOpen = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = Responsive.isWide(context);

    // Mobile View: standard single-pane navigation
    if (!isWide) {
      return ConversationListScreen(
        router: widget.router,
        interactor: widget.interactor,
      );
    }

    // Tablet & Desktop View: Master-Detail Split Pane
    return BlocConsumer<ConversationListBloc, ConversationListState>(
      listenWhen: (prev, curr) =>
          prev.conversations != curr.conversations &&
          curr.conversations.isNotEmpty &&
          _selectedConversationId == null,
      listener: (context, state) {
        if (_selectedConversationId == null &&
            state.conversations.isNotEmpty) {
          setState(() {
            _selectedConversationId = state.conversations.first.id;
          });
        }
      },
      builder: (context, state) {
        // Auto-select first conversation if available and none is currently selected
        final effectiveSelectedId = _selectedConversationId ??
            (state.conversations.isNotEmpty ? state.conversations.first.id : null);

        return Scaffold(
          body: Row(
            children: [
              // Collapsible Sidebar (Left Pane)
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                width: _isSidebarOpen ? 310 : 0,
                child: ClipRect(
                  child: OverflowBox(
                    minWidth: 310,
                    maxWidth: 310,
                    alignment: Alignment.topLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        border: Border(
                          right: BorderSide(
                            color: theme.dividerColor.withValues(alpha: 0.12),
                          ),
                        ),
                      ),
                      child: ConversationListScreen(
                        router: widget.router,
                        interactor: widget.interactor,
                        isSidebar: true,
                        selectedConversationId: effectiveSelectedId,
                        onSelectConversation: (id) {
                          setState(() {
                            _selectedConversationId = id;
                          });
                        },
                        onCreateConversation: () async {
                          final newConv =
                              await widget.interactor.createConversation();
                          setState(() {
                            _selectedConversationId = newConv.id;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // Detail Pane (Right Pane)
              Expanded(
                child: effectiveSelectedId != null
                    ? widget.chatRouter.buildChatView(
                        effectiveSelectedId,
                        showBackButton: false,
                        onToggleSidebar: () {
                          setState(() {
                            _isSidebarOpen = !_isSidebarOpen;
                          });
                        },
                        isSidebarOpen: _isSidebarOpen,
                      )
                    : _buildEmptyDetailView(theme),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyDetailView(ThemeData theme) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(_isSidebarOpen
              ? Icons.view_sidebar_rounded
              : Icons.view_sidebar_outlined),
          tooltip: _isSidebarOpen ? 'Collapse Sidebar' : 'Expand Sidebar',
          onPressed: () {
            setState(() {
              _isSidebarOpen = !_isSidebarOpen;
            });
          },
        ),
        title: const Text('Lotus AI'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 550),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.psychology_outlined,
                    size: 36,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Welcome to Lotus AI',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your offline-first AI assistant powered by local and remote LLMs with VIPER architecture.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color
                        ?.withValues(alpha: 0.65),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: () async {
                    final newConv =
                        await widget.interactor.createConversation();
                    setState(() {
                      _selectedConversationId = newConv.id;
                    });
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Start New Conversation'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
