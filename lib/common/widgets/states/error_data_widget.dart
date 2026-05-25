import 'package:flutter/material.dart';

class ErrorDataWidget extends StatelessWidget {
  final VoidCallback onRetry;
  const ErrorDataWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline_rounded, size: 54, color: cs.error),
        const SizedBox(height: 12),
        Text(
          'Không tải được dữ liệu',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Tải lại'),
        ),
      ],
    );
  }
}
