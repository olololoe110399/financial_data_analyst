import 'package:financial_data_analyst/components/common/app_bar.dart';
import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({
    super.key,
    this.leading,
    required this.appBarTitle,
    required this.body,
  });

  final String appBarTitle;
  final Widget body;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: appBarTitle, leading: leading),
      body: body,
    );
  }
}
