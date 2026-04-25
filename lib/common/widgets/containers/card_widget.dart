// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_spacing.dart';

class CardWidget extends StatelessWidget {
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final Widget child;
  const CardWidget({
    super.key,
    this.padding,
    this.margin,
    this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = this.color ?? context.colorScheme.surface;
    final EdgeInsets padding = this.padding ?? EdgeInsets.all(AppSpacing.md);

    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(color: color),
      child: child,
    );
  }
}
