import 'package:flutter/material.dart';
import 'package:ltc/core/extensions/color_schema_ext.dart';

extension ContextExt on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  LinearGradient get primaryGradient => colorScheme.primaryGradient;
  LinearGradient get primaryGradientSubtle => colorScheme.primaryGradientSubtle;
  LinearGradient get imageOverlayGradient => colorScheme.imageOverlayGradient;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  List<BoxShadow> get softShadow => colorScheme.softShadow;
}
