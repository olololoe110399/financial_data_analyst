import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:financial_data_analyst/components/common/scaffold.dart';
import 'package:financial_data_analyst/modules/finance/components/finance_right_content.dart';

class FinanceRightWidget extends StatelessWidget {
  const FinanceRightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBarTitle: 'Analysis & Visualizations',
      leading: Builder(
        builder: (BuildContext context) {
          return ShadIconButton.ghost(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          );
        },
      ),
      body: SizedBox(
        width: double.infinity,
        child: const FinanceRightContent(),
      ),
    );
  }
}
