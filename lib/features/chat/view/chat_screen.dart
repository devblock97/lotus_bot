import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotus_ai/core/utils/responsive.dart';
import 'package:lotus_ai/features/chat/entity/message.dart';
import 'package:lotus_ai/features/chat/presenter/chat_bloc.dart';
import 'package:lotus_ai/features/chat/presenter/chat_event.dart';
import 'package:lotus_ai/features/chat/presenter/chat_state.dart';
import 'package:lotus_ai/features/chat/router/chat_router.dart';
import 'package:lotus_ai/features/chat/view/widgets/chat_input_field.dart';
import 'package:lotus_ai/features/chat/view/widgets/message_bubble.dart';
import 'package:lotus_ai/features/chat/view/widgets/typing_indicator.dart';

/// VIPER View for active Chat session with adaptive layout.
class ChatScreen extends StatefulWidget {
  const ChatScreen({
    required this.router,
    this.showBackButton = true,
    this.onToggleSidebar,
    this.isSidebarOpen = true,
    super.key,
  });

  final ChatRouter router;
  final bool showBackButton;
  final VoidCallback? onToggleSidebar;
  final bool isSidebarOpen;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatModelDisplayName(String id) {
    switch (id) {
      case 'gemini-2.0-flash':
        return 'Gemini 2.0 Flash';
      case 'gemini-1.5-flash':
        return 'Gemini 1.5 Flash';
      case 'gemini-1.5-pro':
        return 'Gemini 1.5 Pro';
      case 'grok-2-latest':
        return 'Grok 2';
      case 'grok-beta':
        return 'Grok Beta';
      case 'qwen-turbo':
        return 'Qwen Turbo';
      case 'qwen-plus':
        return 'Qwen Plus';
      case 'qwen-max':
        return 'Qwen Max';
      case 'llama3.2':
        return 'Llama 3.2';
      case 'llama3':
        return 'Llama 3';
      case 'gpt-4o':
        return 'GPT-4o';
      case 'claude-3-5-sonnet':
        return 'Claude 3.5 Sonnet';
      default:
        return id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 420;

    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state.isGenerating || state.messages.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        }
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: theme.colorScheme.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        final title = state.conversation?.title ?? 'AI Chat';
        final allModels = [
          'gemini-2.0-flash',
          'gemini-1.5-flash',
          'gemini-1.5-pro',
          'grok-2-latest',
          'qwen-turbo',
          'qwen-plus',
          'llama3.2',
          'gpt-4o',
          'claude-3-5-sonnet',
        ];

        final selectedModel = allModels.contains(state.currentModel)
            ? state.currentModel
            : allModels.first;

        Widget? leadingWidget;
        if (widget.showBackButton) {
          leadingWidget = IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: 'Back',
            onPressed: () => widget.router.pop(context),
          );
        } else if (widget.onToggleSidebar != null) {
          leadingWidget = IconButton(
            icon: Icon(widget.isSidebarOpen
                ? Icons.view_sidebar_rounded
                : Icons.view_sidebar_outlined),
            tooltip: widget.isSidebarOpen ? 'Collapse Sidebar' : 'Expand Sidebar',
            onPressed: widget.onToggleSidebar,
          );
        }

        return Scaffold(
          appBar: AppBar(
            titleSpacing: leadingWidget != null ? 0 : 16,
            leading: leadingWidget,
            automaticallyImplyLeading: leadingWidget != null,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isCompact ? 120 : 165),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButton<String>(
                    value: selectedModel,
                    underline: const SizedBox(),
                    isDense: true,
                    isExpanded: true,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                    items: allModels.map((m) {
                      return DropdownMenuItem(
                        value: m,
                        child: Text(
                          _formatModelDisplayName(m),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        context.read<ChatBloc>().add(SwitchModelEvent(val));
                      }
                    },
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                tooltip: 'AI Engine Settings',
                onPressed: () => widget.router.navigateToSettings(context),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: Column(
            children: [
              // Message Feed (centered with max width on desktop/tablet)
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state.messages.isEmpty && !state.isGenerating
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.psychology_outlined,
                                    size: 48,
                                    color: theme.colorScheme.primary
                                        .withValues(alpha: 0.6),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Start your conversation with Lotus AI',
                                    style: theme.textTheme.titleMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Supports local Ollama offline, Gemini, Grok, and Alibaba models.',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.textTheme.bodySmall?.color
                                          ?.withValues(alpha: 0.6),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Align(
                            alignment: Alignment.topCenter,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: Responsive.maxContentWidth,
                              ),
                              child: ListView(
                                controller: _scrollController,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                children: [
                                  ...state.messages.map(
                                    (msg) => MessageBubble(
                                      message: msg,
                                      onRegenerate: () => context
                                          .read<ChatBloc>()
                                          .add(const RegenerateResponseEvent()),
                                      onRetry: () => context
                                          .read<ChatBloc>()
                                          .add(RetryMessageEvent(msg)),
                                    ),
                                  ),

                                  // Streaming Response Bubble
                                  if (state.isGenerating &&
                                      state.streamingContent.isNotEmpty)
                                    MessageBubble(
                                      message: Message(
                                        id: 'streaming',
                                        conversationId:
                                            state.conversationId ?? '',
                                        role: MessageRole.assistant,
                                        content: state.streamingContent,
                                        timestamp: DateTime.now(),
                                        status: MessageStatus.streaming,
                                      ),
                                    ),

                                  // Animated Typing Dots before first token
                                  if (state.isGenerating &&
                                      state.streamingContent.isEmpty)
                                    const TypingIndicator(),
                                ],
                              ),
                            ),
                          ),
              ),

              // Bottom Input Field (centered with max width on desktop/tablet)
              Align(
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: Responsive.maxContentWidth,
                  ),
                  child: ChatInputField(
                    isGenerating: state.isGenerating,
                    initialText: state.draftInput,
                    onSend: (text, {attachedImagePath}) => context
                        .read<ChatBloc>()
                        .add(SendMessageEvent(text, attachedImagePath: attachedImagePath)),
                    onStop: () => context
                        .read<ChatBloc>()
                        .add(const StopGenerationEvent()),
                    onChanged: (draft) =>
                        context.read<ChatBloc>().add(UpdateDraftEvent(draft)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
