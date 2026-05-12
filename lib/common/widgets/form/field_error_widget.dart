import 'package:flutter/material.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_spacing.dart';

class FieldErrorWidget extends StatelessWidget {
  final String? message;
  const FieldErrorWidget(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();
    final cs = context.colorScheme;
    final tt = context.textTheme;
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.gapXs,
        left: AppSpacing.gapXs,
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, size: 13, color: cs.error),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              message!,
              style: tt.bodySmall?.copyWith(color: cs.error),
            ),
          ),
        ],
      ),
    );
  }
}
