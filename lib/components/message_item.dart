import 'package:financial_data_analyst/components/file_preview.dart';
import 'package:financial_data_analyst/configs/images.dart';
import 'package:financial_data_analyst/types/message.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({super.key, required this.message});

  final MyMessage message;

  bool get _isUser => message.role == "user";

  bool get _isThinking => message.content == "thinking";

  Color _textColor(ShadThemeData theme) =>
      _isUser ? theme.colorScheme.secondary : theme.colorScheme.primary;

  Color _backgroundColor(ShadThemeData theme) =>
      _isUser ? theme.colorScheme.primary : theme.colorScheme.secondary;

  Widget _buildAvatar(ShadThemeData theme) {
    return ShadAvatar(
      'https://app.requestly.io/delay/0/avatars.githubusercontent.com/u/124599?v=4',
      size: Size.square(32),
      placeholder: CircleAvatar(
        backgroundImage: AssetImage(Assets.logo),
        radius: 16,
      ),
    );
  }

  Widget _buildThinkingIndicator(ShadThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.hasToolUse)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShadBadge.secondary(child: Icon(Icons.insert_chart_outlined)),
                  Text(
                    'Generated Chart',
                    style: TextStyle(color: _textColor(theme)),
                  ),
                ],
              ),
            Text('Thinking...', style: TextStyle(color: _textColor(theme))),
          ],
        ),
      ],
    );
  }

  Widget _buildMessageContent(ShadThemeData theme) {
    return _isThinking
        ? _buildThinkingIndicator(theme)
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.hasToolUse)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShadBadge.secondary(child: Icon(Icons.insert_chart_outlined)),
                  Text(
                    'Generated Chart',
                    style: TextStyle(color: _textColor(theme)),
                  ),
                ],
              ),
            Text(message.content, style: TextStyle(color: _textColor(theme))),
          ],
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final mainAxisAlignment =
        _isUser ? MainAxisAlignment.end : MainAxisAlignment.start;
    final crossAxisAlignment =
        _isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        if (!_isUser) _buildAvatar(theme),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: _backgroundColor(theme),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _buildMessageContent(theme),
              ),
              if (message.file != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  child: FilePreview(
                    size: FilePreviewSize.small,
                    file: message.file!,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
