import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lotus_ai/features/chat/entity/conversation.dart';
import 'package:lotus_ai/features/chat/entity/message.dart';
import 'package:lotus_ai/features/conversation_list/interactor/conversation_list_interactor.dart';
import 'package:lotus_ai/features/conversation_list/presenter/conversation_list_bloc.dart';
import 'package:lotus_ai/features/conversation_list/presenter/conversation_list_event.dart';
import 'package:lotus_ai/features/conversation_list/presenter/conversation_list_state.dart';
import 'package:lotus_ai/features/conversation_list/router/conversation_list_router.dart';

class ConversationListScreen extends StatelessWidget {
  const ConversationListScreen({
    required this.router,
    required this.interactor,
    this.isSidebar = false,
    this.selectedConversationId,
    this.onSelectConversation,
    this.onCreateConversation,
    super.key,
  });

  final ConversationListRouter router;
  final ConversationListInteractor interactor;
  final bool isSidebar;
  final String? selectedConversationId;
  final ValueChanged<String>? onSelectConversation;
  final VoidCallback? onCreateConversation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final content = BlocBuilder<ConversationListBloc, ConversationListState>(
      builder: (context, state) {
        return Column(
          children: [
            // Sidebar Header / Actions
            if (isSidebar) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.smart_toy_outlined,
                        size: 16,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Lotus AI',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune_rounded, size: 20),
                      tooltip: 'AI Engine Settings',
                      onPressed: () => router.openSettings(context),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonalIcon(
                    onPressed: () async {
                      if (onCreateConversation != null) {
                        onCreateConversation!();
                      } else {
                        final newConv = await interactor.createConversation();
                        if (onSelectConversation != null) {
                          onSelectConversation!(newConv.id);
                        } else if (context.mounted) {
                          router.openChat(context, newConv.id);
                        }
                      }
                    },
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('New Chat'),
                  ),
                ),
              ),
            ],

            // Search Input
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                onChanged: (val) => context
                    .read<ConversationListBloc>()
                    .add(SearchConversationsEvent(val)),
                decoration: InputDecoration(
                  hintText: 'Search chats...',
                  prefixIcon: const Icon(Icons.search, size: 18),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.4),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Conversation List
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.filteredConversations.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  size: 40,
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.4),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  state.searchQuery.isEmpty
                                      ? 'No conversations yet'
                                      : 'No conversations match "${state.searchQuery}"',
                                  style: theme.textTheme.titleSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          itemCount: state.filteredConversations.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            indent: 68,
                            color: theme.dividerColor.withValues(alpha: 0.08),
                          ),
                          itemBuilder: (context, index) {
                            final conv = state.filteredConversations[index];
                            final isSelected =
                                selectedConversationId == conv.id;

                            return _ConversationTile(
                              conversation: conv,
                              interactor: interactor,
                              isSelected: isSelected,
                              onTap: () {
                                if (onSelectConversation != null) {
                                  onSelectConversation!(conv.id);
                                } else {
                                  router.openChat(context, conv.id);
                                }
                              },
                              onPin: () => context
                                  .read<ConversationListBloc>()
                                  .add(TogglePinEvent(conv.id)),
                              onFavourite: () => context
                                  .read<ConversationListBloc>()
                                  .add(ToggleFavouriteEvent(conv.id)),
                              onDelete: () => context
                                  .read<ConversationListBloc>()
                                  .add(DeleteConversationEvent(conv.id)),
                              onRename: (newTitle) => context
                                  .read<ConversationListBloc>()
                                  .add(RenameConversationEvent(
                                      conv.id, newTitle)),
                            );
                          },
                        ),
            ),
          ],
        );
      },
    );

    if (isSidebar) {
      return Material(
        color: theme.scaffoldBackgroundColor,
        child: SafeArea(right: false, child: content),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lotus AI',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings & AI Engines',
            onPressed: () => router.openSettings(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newConv = await interactor.createConversation();
          if (context.mounted) {
            router.openChat(context, newConv.id);
          }
        },
        icon: const Icon(Icons.add_comment_rounded),
        label: const Text('New Chat'),
      ),
      body: content,
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.conversation,
    required this.interactor,
    required this.onTap,
    required this.onPin,
    required this.onFavourite,
    required this.onDelete,
    required this.onRename,
    this.isSelected = false,
  });

  final Conversation conversation;
  final ConversationListInteractor interactor;
  final VoidCallback onTap;
  final VoidCallback onPin;
  final VoidCallback onFavourite;
  final VoidCallback onDelete;
  final ValueChanged<String> onRename;
  final bool isSelected;

  void _showRenameDialog(BuildContext context) {
    final controller = TextEditingController(text: conversation.title);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Conversation'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty) {
                onRename(newTitle);
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<Message>>(
      stream: interactor.watchMessages(conversation.id),
      builder: (context, snapshot) {
        final messages = snapshot.data ?? [];
        final lastMessage = messages.isNotEmpty ? messages.last : null;
        final subtitle = lastMessage == null
            ? 'No messages yet'
            : lastMessage.content.replaceAll(RegExp(r'\s+'), ' ');
        final time = lastMessage?.timestamp ?? conversation.updatedAt;

        return ListTile(
          selected: isSelected,
          selectedTileColor:
              theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.smart_toy_outlined,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onPrimaryContainer,
                  size: 18,
                ),
              ),
              if (conversation.isPinned)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.push_pin,
                      size: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  conversation.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              if (conversation.isFavourite)
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                ),
            ],
          ),
          subtitle: Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('h:mm a').format(time),
                style: TextStyle(
                  fontSize: 10,
                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded, size: 16),
                padding: EdgeInsets.zero,
                onSelected: (action) {
                  switch (action) {
                    case 'pin':
                      onPin();
                      break;
                    case 'favourite':
                      onFavourite();
                      break;
                    case 'rename':
                      _showRenameDialog(context);
                      break;
                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'pin',
                    child: Row(
                      children: [
                        Icon(conversation.isPinned
                            ? Icons.push_pin_outlined
                            : Icons.push_pin),
                        const SizedBox(width: 8),
                        Text(conversation.isPinned ? 'Unpin' : 'Pin'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'favourite',
                    child: Row(
                      children: [
                        Icon(conversation.isFavourite
                            ? Icons.star_border
                            : Icons.star),
                        const SizedBox(width: 8),
                        Text(conversation.isFavourite
                            ? 'Unfavourite'
                            : 'Favourite'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'rename',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 8),
                        Text('Rename'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: onTap,
        );
      },
    );
  }
}
