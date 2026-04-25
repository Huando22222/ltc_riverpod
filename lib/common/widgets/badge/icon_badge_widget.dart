import 'package:flutter/material.dart';
import 'package:ltc/core/theme/app_spacing.dart';

class IconBadgeWidget extends StatelessWidget {
  const IconBadgeWidget({
    super.key,
    required this.icon,
    required this.color,
    this.size = AppSpacing.iconLg,
    this.padding = AppSpacing.sm,
    this.borderRadius,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double padding;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(
          borderRadius ?? (padding + size) * 0.35,
        ),
      ),
      child: Icon(icon, color: color, size: size),
    );
  }
}
