import 'package:flutter/material.dart';
import 'package:ltc/core/theme/app_colors.dart';

extension AppGradients on ColorScheme {
  LinearGradient get primaryGradient => LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, secondary], // tertiary = #56CCF2
    stops: [0.7, 1.0],
  );

  LinearGradient get primaryGradientSubtle => LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryContainer, secondaryContainer],
  );

  List<BoxShadow> get softShadow => AppColors.softShadow;
}
