import 'package:flutter/material.dart';
import 'package:ltc/common/widgets/states/loading_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_spacing.dart';

class HealthLoadingContent extends StatelessWidget {
  const HealthLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        110,
      ),
      children: [
        Container(
          height: 168,
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: const LoadingWidget(),
        ),
      ],
    );
  }
}

class HealthStateContent extends StatelessWidget {
  const HealthStateContent({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        SizedBox(height: MediaQuery.sizeOf(context).height * .18),
        Icon(icon, size: 48, color: context.colorScheme.primary),
        const SizedBox(height: AppSpacing.md),
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          message,
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: FilledButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.refresh_outlined),
            label: Text(actionLabel),
          ),
        ),
      ],
    );
  }
}
