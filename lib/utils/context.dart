import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

extension ExtContext on BuildContext {
  bool get isDesktop => breakpoint > ShadTheme.of(this).breakpoints.md;
  bool get isMobile => breakpoint <= ShadTheme.of(this).breakpoints.md;
}
