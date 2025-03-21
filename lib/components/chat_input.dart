import 'package:financial_data_analyst/components/common/text_area.dart';
import 'package:financial_data_analyst/components/file_preview.dart';
import 'package:financial_data_analyst/modules/finance/composables/chat_composable.dart';
import 'package:financial_data_analyst/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  late final chatComposable = context.get<ChatComposable>();
  late final enabledSubmit = Computed(() {
    final inputText = chatComposable.inputSignal();
    final currentUpload = chatComposable.currentUpload();
    return inputText.trim().isNotEmpty || currentUpload != null;
  });
  late final enabledUpload = Computed(() {
    return !chatComposable.isLoading() && !chatComposable.isUploading();
  });

  @override
  void initState() {
    chatComposable.toast.observe((previousValue, value) {
      if (value != null) {
        showToast(
          context,
          title: value.title,
          description: value.description,
          duration: value.duration,
          variant: value.variant,
        );
      } else {
        hideToast(context);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    enabledSubmit.dispose();
    enabledUpload.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SignalBuilder(
          signal: chatComposable.currentUpload,
          builder: (context, currentUpload, _) {
            if (currentUpload == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: FilePreview(
                file: currentUpload,
                onRemove: () {
                  chatComposable.currentUpload.value = null;
                },
              ),
            );
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(width: 8),
            SignalBuilder(
              signal: enabledUpload,
              builder: (context, enabled, _) {
                return ShadButton.ghost(
                  enabled: enabled,
                  onPressed: () => chatComposable.handleFileSelect(),
                  child: SignalBuilder(
                    signal: chatComposable.isUploading,
                    builder: (context, isUploading, _) {
                      if (isUploading) {
                        return SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                          ),
                        );
                      }
                      return const Icon(Icons.attach_file);
                    },
                  ),
                );
              },
            ),
            Expanded(child: TextArea(inputSignal: chatComposable.inputSignal)),
            SignalBuilder(
              signal: enabledSubmit,
              builder: (context, enabled, _) {
                return ShadButton(
                  enabled: enabled,
                  child: const Icon(Icons.send),
                  onPressed: () => chatComposable.handleSubmit(),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
