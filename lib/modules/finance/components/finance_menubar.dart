import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:financial_data_analyst/configs/constants.dart';
import 'package:financial_data_analyst/modules/finance/composables/chat_composable.dart';
import 'package:financial_data_analyst/types/model_option.dart';
import 'package:financial_data_analyst/utils/context.dart';

class FinanceMenubar extends StatelessWidget {
  const FinanceMenubar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final chatComposable = context.get<ChatComposable>();
    final overlayAlignment =
        context.isMobile ? Alignment.bottomCenter : Alignment.bottomRight;
    final childAlignment =
        context.isMobile ? Alignment.topCenter : Alignment.topRight;
    return ShadMenubar(
      selectOnHover: false,
      items: [
        SignalBuilder(
          signal: chatComposable.selectedModel,
          builder: (context, selectedModel, _) {
            return ShadMenubarItem(
              anchor: ShadAnchor(
                childAlignment: childAlignment,
                overlayAlignment: overlayAlignment,
                offset: Offset(context.isMobile ? 0 : 8, 8),
              ),
              padding: const EdgeInsets.all(8),
              height: 26,
              buttonPadding: const EdgeInsets.symmetric(horizontal: 8),
              trailing: const Icon(Icons.arrow_drop_down),
              items: _buildMenus(selectedModel, chatComposable, theme),
              child: Text(selectedModel.name, style: theme.textTheme.small),
            );
          },
        ),
      ],
    );
  }

  List<ShadContextMenuItem> _buildMenus(
    ModelOption selectedModel,
    ChatComposable chatComposable,
    ShadThemeData theme,
  ) {
    return models.map((model) {
      final variant =
          model.id == selectedModel.id
              ? ShadContextMenuItemVariant.primary
              : ShadContextMenuItemVariant.inset;
      final leading =
          model.id == selectedModel.id ? const Icon(Icons.check) : null;
      return ShadContextMenuItem.raw(
        variant: variant,
        padding: EdgeInsets.zero,
        onPressed: () => chatComposable.selectedModel.value = model,
        leading: leading,
        child: Text(model.name, style: theme.textTheme.small),
      );
    }).toList();
  }
}
