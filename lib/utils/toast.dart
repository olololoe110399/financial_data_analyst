import 'package:flutter/cupertino.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void showToast(
  BuildContext context, {
  String? title,
  String? description,
  Duration? duration,
  ShadToastVariant variant = ShadToastVariant.primary,
}) {
  assert(title != null || description != null);
  final widgetTitle = title != null ? Text(title) : null;
  final widgetDescription = description != null ? Text(description) : null;
  ShadToaster.of(context).show(
    ShadToast.raw(
      variant: variant,
      title: widgetTitle,
      description: widgetDescription,
      duration: duration,
    ),
  );
}

void hideToast(BuildContext context) {
  ShadToaster.of(context).hide();
}
