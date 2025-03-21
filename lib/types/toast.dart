import 'package:shadcn_ui/shadcn_ui.dart';

class Toast {
  final String? title;
  final String? description;
  final Duration? duration;
  final ShadToastVariant variant;

  Toast({
    this.title,
    this.description,
    this.duration,
    this.variant = ShadToastVariant.primary,
  });
}
