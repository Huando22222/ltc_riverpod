import 'package:flutter/material.dart';
import 'package:ltc/core/extensions/context_ext.dart';

class FieldWrapperWidget extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isRequired;
  final Widget child;

  const FieldWrapperWidget({
    super.key,
    required this.label,
    required this.icon,
    required this.child,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: cs.primary),
              const SizedBox(width: 6),
              Text(
                label,
                style: tt.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 3),
                Text('*', style: tt.labelMedium?.copyWith(color: cs.error)),
              ],
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
