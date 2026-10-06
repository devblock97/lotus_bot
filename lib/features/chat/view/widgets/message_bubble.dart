import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lotus_ai/app/theme/theme_extensions.dart';
import 'package:lotus_ai/features/chat/entity/message.dart';
import 'package:lotus_ai/features/chat/view/widgets/markdown_message_view.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    this.onRegenerate,
    this.onRetry,
    super.key,
  });

  final Message message;
  final VoidCallback? onRegenerate;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatTheme = theme.extension<AppChatTheme>();
    final isUser = message.role.isUser;
    final timeStr = DateFormat('h:mm a').format(message.timestamp);

    if (isUser) {
      final content = message.content;
      String? imagePath;
      String displayText = content;

      if (content.startsWith('[INVOICE_IMAGE:') && content.contains(']\n')) {
        final endIndex = content.indexOf(']\n');
        imagePath = content.substring('[INVOICE_IMAGE:'.length, endIndex);
        displayText = content.substring(endIndex + 2);
      } else if (content.startsWith('[INVOICE_IMAGE:') && content.endsWith(']')) {
        imagePath =
            content.substring('[INVOICE_IMAGE:'.length, content.length - 1);
        displayText = '';
      }

      final hasImage = imagePath != null && File(imagePath).existsSync();

      return Padding(
        padding: const EdgeInsets.only(left: 56, right: 16, top: 6, bottom: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: chatTheme?.userBubbleBg ?? Colors.black,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasImage) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 220),
                        child: Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.receipt_long_rounded,
                            size: 13,
                            color: chatTheme?.userBubbleFg ?? Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Invoice Attached',
                            style: TextStyle(
                              color: chatTheme?.userBubbleFg ?? Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (displayText.isNotEmpty) const SizedBox(height: 8),
                  ],
                  if (displayText.isNotEmpty)
                    Text(
                      displayText,
                      style: TextStyle(
                        color: chatTheme?.userBubbleFg ?? Colors.white,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeStr,
                  style: TextStyle(
                    color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.done_all_rounded,
                  size: 14,
                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // AI Assistant message
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 48, top: 6, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
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
              Text(
                'Lotus AI',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: message.isError
                  ? theme.colorScheme.errorContainer.withValues(alpha: 0.2)
                  : (chatTheme?.aiBubbleBg ?? theme.cardColor),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: message.isError
                    ? theme.colorScheme.error.withValues(alpha: 0.4)
                    : theme.dividerColor.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarkdownMessageView(
                  content: message.content,
                  textColor: chatTheme?.aiBubbleFg ??
                      (theme.textTheme.bodyLarge?.color ?? Colors.black),
                ),
                const SizedBox(height: 10),
                Divider(
                  height: 1,
                  color: theme.dividerColor.withValues(alpha: 0.1),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (onRegenerate != null)
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        onPressed: onRegenerate,
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Regenerate',
                      ),
                    if (message.isError && onRetry != null)
                      TextButton.icon(
                        icon: const Icon(Icons.replay_rounded, size: 16),
                        label: const Text('Retry', style: TextStyle(fontSize: 12)),
                        onPressed: onRetry,
                      ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: message.content));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Copied to clipboard'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Copy',
                    ),
                    const Spacer(),
                    Text(
                      timeStr,
                      style: TextStyle(
                        color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
