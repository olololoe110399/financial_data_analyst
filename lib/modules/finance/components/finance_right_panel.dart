import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:financial_data_analyst/modules/finance/components/finance_right_content.dart';
import 'package:financial_data_analyst/utils/context.dart';

class FinanceRightPanel extends StatelessWidget {
  const FinanceRightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final panelWidth = context.isMobile ? size.width : size.width * 0.65;
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 16, bottom: 16),
      width: panelWidth,
      height: double.infinity,
      child: ShadCard(
        padding: EdgeInsets.zero,
        rowMainAxisAlignment: MainAxisAlignment.start,
        columnMainAxisAlignment: MainAxisAlignment.start,
        width: double.infinity,
        child: const FinanceRightContent(),
      ),
    );
  }
}
