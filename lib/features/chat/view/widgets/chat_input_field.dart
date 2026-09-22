import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({
    required this.isGenerating,
    required this.onSend,
    required this.onStop,
    this.initialText = '',
    this.onChanged,
    this.hintText = 'Ask anything...',
    super.key,
  });

  final bool isGenerating;
  final ValueChanged<String> onSend;
  final VoidCallback onStop;
  final String initialText;
  final ValueChanged<String>? onChanged;
  final String hintText;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _focusNode = FocusNode(onKeyEvent: _handleKeyEvent);
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter &&
        !HardwareKeyboard.instance.isShiftPressed) {
      _handleSend();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void didUpdateWidget(covariant ChatInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialText != oldWidget.initialText &&
        _controller.text != widget.initialText) {
      _controller.text = widget.initialText;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.isGenerating) {
      widget.onSend(text);
      _controller.clear();
      widget.onChanged?.call('');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      minLines: 1,
                      maxLines: 5,
                      onChanged: widget.onChanged,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _handleSend(),
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: TextStyle(
                          color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.mic_none_rounded, size: 20),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Voice input ready'),
                                duration: Duration(milliseconds: 800),
                              ),
                            );
                          },
                          tooltip: 'Voice Input',
                        ),
                        IconButton(
                          icon: const Icon(Icons.attach_file_rounded, size: 20),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Attachments ready'),
                                duration: Duration(milliseconds: 800),
                              ),
                            );
                          },
                          tooltip: 'Add Attachment',
                        ),
                        const Spacer(),
                        if (widget.isGenerating)
                          IconButton.filled(
                            onPressed: widget.onStop,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.stop_rounded, size: 20),
                            tooltip: 'Stop Generating',
                          )
                        else
                          IconButton.filled(
                            onPressed: _handleSend,
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                            ),
                            icon: const Icon(Icons.arrow_upward_rounded, size: 20),
                            tooltip: 'Send Prompt (Enter)',
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Lotus AI can make mistakes. Verify critical facts.',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
