// section_divider.dart
import 'package:flutter/material.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_spacing.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider({
    super.key,
    this.label,
    this.margin = const EdgeInsets.symmetric(vertical: AppSpacing.md),
  });

  // Tuỳ chọn — hiện label ở giữa divider
  final String? label;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      // ── Divider đơn giản ──────────────────────
      return Padding(
        padding: margin,
        child: Divider(
          color: context.colorScheme.outlineVariant,
          thickness: 1,
          height: 1,
        ),
      );
    }

    // ── Divider có label ────────────────────────
    return Padding(
      padding: margin,
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: context.colorScheme.outlineVariant,
              thickness: 1,
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              label!,
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: context.colorScheme.outlineVariant,
              thickness: 1,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
