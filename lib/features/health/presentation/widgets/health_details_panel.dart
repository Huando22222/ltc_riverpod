import 'package:flutter/material.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/health/presentation/utils/health_overview_ui_models.dart';

class HealthDetailsPanel extends StatelessWidget {
  const HealthDetailsPanel({super.key, required this.items});

  final List<HealthDetailInfo> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _HealthDetailRow(item: items[i]),
            if (i != items.length - 1)
              Divider(
                height: 1,
                indent: AppSpacing.md,
                endIndent: AppSpacing.md,
                color: context.colorScheme.outlineVariant,
              ),
          ],
        ],
      ),
    );
  }
}

class _HealthDetailRow extends StatelessWidget {
  const _HealthDetailRow({required this.item});

  final HealthDetailInfo item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Icon(item.icon, color: context.colorScheme.primary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              item.label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              item.value,
              textAlign: TextAlign.right,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
