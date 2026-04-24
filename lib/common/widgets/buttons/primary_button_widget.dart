import 'package:flutter/material.dart';
import 'package:ltc/common/widgets/splash_tap_widget.dart';
import 'package:ltc/core/extensions/color_schema_ext.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_spacing.dart';

class PrimaryButtonWidget extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback? onPressed;
  final String? title;
  final IconData? icon;
  final double? width;
  final double? radius;
  final EdgeInsets? padding;
  const PrimaryButtonWidget({
    super.key,
    required this.isEnabled,
    this.onPressed,
    this.title,
    this.icon,
    this.width,
    this.radius,
    this.padding,
  });

  @override
  State<PrimaryButtonWidget> createState() => _PrimaryButtonWidgetState();
}

class _PrimaryButtonWidgetState extends State<PrimaryButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return SplashTapWidget(
      onTap: widget.isEnabled ? widget.onPressed : null, // ✅
      borderRadius: BorderRadius.circular(widget.radius ?? AppSpacing.radiusMd),
      child: Ink(
        padding:
            widget.padding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: widget.width ?? double.infinity,
        decoration: BoxDecoration(
          boxShadow: context.colorScheme.softShadow,
          borderRadius: BorderRadius.circular(
            widget.radius ?? AppSpacing.radiusMd,
          ),
          gradient: context.colorScheme.primaryGradient,
        ),
        child: Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) Icon(widget.icon, color: Colors.white),
            if (widget.title != null)
              Text(
                widget.title!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
