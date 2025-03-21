import 'dart:ui';

import 'package:financial_data_analyst/modules/finance/composables/chat_composable.dart';
import 'package:financial_data_analyst/pages/finance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  SolidartConfig.devToolsEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Solid(
      providers: [
        Provider<Signal<ThemeMode>>(create: () => Signal(ThemeMode.light)),
        Provider<ChatComposable>(
          create: () => ChatComposable(),
          dispose: (composable) => composable.dispose(),
        ),
      ],
      builder: (context) {
        final themeMode = context.observe<ThemeMode>();
        return ShadApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          scrollBehavior: ShadScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
              PointerDeviceKind.unknown,
              PointerDeviceKind.trackpad,
            },
          ),
          theme: ShadThemeData(
            brightness: Brightness.light,
            colorScheme: const ShadZincColorScheme.light(),
            textTheme: ShadTextTheme(family: kDefaultFontFamily),
          ),
          darkTheme: ShadThemeData(
            brightness: Brightness.dark,
            colorScheme: const ShadZincColorScheme.dark(),
            textTheme: ShadTextTheme(family: kDefaultFontFamily),
          ),
          home: const FinancePage(),
        );
      },
    );
  }
}
