import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final normalized = status.toUpperCase();

    final label = switch (normalized) {
      'DANGXULY' => 'Đang xử lý',
      'DONE' || 'COMPLETED' || 'HOANTHANH' => 'Hoàn thành',
      'CANCEL' || 'CANCELLED' || 'HUY' => 'Đã hủy',
      _ => status,
    };

    final color = switch (normalized) {
      'DONE' || 'COMPLETED' || 'HOANTHANH' => cs.tertiary,
      'CANCEL' || 'CANCELLED' || 'HUY' => cs.error,
      _ => cs.primary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
