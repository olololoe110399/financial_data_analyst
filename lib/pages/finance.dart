import 'package:financial_data_analyst/components/common/scaffold.dart';
import 'package:financial_data_analyst/modules/finance/components/finance_left_panel.dart';
import 'package:financial_data_analyst/modules/finance/components/finance_right_panel.dart';
import 'package:financial_data_analyst/utils/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  @override
  Widget build(BuildContext context) {
    return Solid(
      child: MyScaffold(
        appBarTitle: 'Finance',
        body: Row(
          children: [
            FinanceLeftPanel(),
            if (context.isDesktop) FinanceRightPanel(),
          ],
        ),
      ),
    );
  }
}
