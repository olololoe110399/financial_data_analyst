import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:financial_data_analyst/components/chat_input.dart';
import 'package:financial_data_analyst/components/message_item.dart';
import 'package:financial_data_analyst/modules/finance/components/finance_menubar.dart';
import 'package:financial_data_analyst/modules/finance/components/finance_right_widget.dart';
import 'package:financial_data_analyst/modules/finance/composables/chat_composable.dart';
import 'package:financial_data_analyst/utils/context.dart';

class FinanceLeftPanel extends StatelessWidget {
  const FinanceLeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final panelWidth = context.isMobile ? size.width : size.width * 0.35;
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: context.isMobile ? 16 : 8,
        bottom: 16,
      ),
      width: panelWidth,
      height: double.infinity,
      child: ShadCard(
        columnMainAxisAlignment: MainAxisAlignment.end,
        rowMainAxisAlignment: MainAxisAlignment.end,
        padding: EdgeInsets.zero,
        width: double.infinity,
        footer: ChatInput(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [_FinanceLeftHeader(), _FinanceLeftContent()],
              ),
            ),
            ShadSeparator.horizontal(margin: EdgeInsets.zero),
            if (context.isMobile)
              _FinanceRightModal()
            else
              const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _FinanceRightModal extends StatelessWidget {
  const _FinanceRightModal();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      child: ShadButton.outline(
        leading: Icon(Icons.code),
        child: Text('Analyst & Visualizations'),
        onPressed: () {
          showShadDialog(
            context: context,
            builder: (context) => const FinanceRightWidget(),
          );
        },
      ),
    );
  }
}

class _FinanceLeftContent extends StatelessWidget {
  const _FinanceLeftContent();

  @override
  Widget build(BuildContext context) {
    final chatComposable = context.get<ChatComposable>();

    return Expanded(
      child: SignalBuilder(
        signal: chatComposable.messages,
        builder: (context, messages, _) {
          return messages.isEmpty
              ? _FinanceLeftContentTutorial()
              : ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(height: 4);
                },
                controller: chatComposable.messagesController,
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageItem(message: messages[index]);
                },
              );
        },
      ),
    );
  }
}

class _FinanceLeftHeader extends StatelessWidget {
  const _FinanceLeftHeader();

  List<Widget> _buildContentHeader(
    ShadThemeData theme,
    Computed<bool> isMessageEmpty,
  ) {
    return [
      SignalBuilder(
        signal: isMessageEmpty,
        builder: (context, isMsgEmpty, _) {
          if (isMsgEmpty) return SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Financial Assistant"),
              Text(
                "Powered by Duynn",
                style: theme.textTheme.muted.copyWith(fontSize: 12),
              ),
            ],
          );
        },
      ),
      const SizedBox(width: 8),
      FinanceMenubar(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final chatComposable = context.get<ChatComposable>();
    final theme = ShadTheme.of(context);
    if (context.isMobile) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 8, right: 8, left: 8),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          runAlignment: WrapAlignment.start,
          spacing: 8,
          runSpacing: 8,
          children: _buildContentHeader(theme, chatComposable.isMessageEmpty),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 8, right: 8, left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildContentHeader(theme, chatComposable.isMessageEmpty),
      ),
    );
  }
}

class _FinanceLeftContentTutorial extends StatelessWidget {
  const _FinanceLeftContentTutorial();

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(28),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Financial Assistant', style: theme.textTheme.h4),
          const SizedBox(height: 8),
          Text(
            'I can analyze financial data and create visualizations from your files.',
            style: theme.textTheme.muted.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            'Upload CSVs, PDFs, or images and I\'ll help you understand the data.',
            style: theme.textTheme.muted.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            'Ask questions about your financial data and I\'ll create insightful charts.',
            style: theme.textTheme.muted.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
