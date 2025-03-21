import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, this.title, this.leading})
    : assert((title != null), 'Must provide either title or titleWidget');

  final String? title;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return AppBar(
      title: Text(title!, style: theme.textTheme.h4),
      centerTitle: false,
      leading: leading,
      actions: [
        ShadMenubar(
          selectOnHover: false,
          items: [
            ShadMenubarItem(
              height: 26,
              width: 26,
              anchor: ShadAnchor(
                childAlignment: Alignment.topRight,
                overlayAlignment: Alignment.bottomRight,
                offset: Offset(8, 8),
              ),
              padding: const EdgeInsets.all(8),
              buttonPadding: EdgeInsets.zero,
              items: [
                ShadContextMenuItem(
                  padding: EdgeInsets.zero,
                  child: Text('Light', style: theme.textTheme.small),
                  onPressed: () {
                    context.update<ThemeMode>((value) => ThemeMode.light);
                  },
                ),
                ShadContextMenuItem(
                  padding: EdgeInsets.zero,
                  child: Text('Dark', style: theme.textTheme.small),
                  onPressed: () {
                    context.update<ThemeMode>((value) => ThemeMode.dark);
                  },
                ),
                ShadContextMenuItem(
                  padding: EdgeInsets.zero,
                  child: Text('System', style: theme.textTheme.small),
                  onPressed: () {
                    context.update<ThemeMode>((value) => ThemeMode.system);
                  },
                ),
              ],
              child: SignalBuilder(
                signal: context.get<Signal<ThemeMode>>(),
                builder: (context, themeMode, child) {
                  return Icon(
                    themeMode == ThemeMode.light
                        ? Icons.light_mode
                        : themeMode == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.auto_awesome,
                    size: 18,
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
