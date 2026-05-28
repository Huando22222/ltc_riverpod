import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final normalized = status.trim().toUpperCase();

    final label = switch (normalized) {
      'CHUATOI' => 'Chưa tới',
      'CHUAXULY' => 'Chưa xử lý',
      'DANGXULY' => 'Đang xử lý',
      'DATOI' => 'Đã tới',
      'DENMUON' => 'Đến muộn',
      'HUYLICH' => 'Hủy lịch',
      'DONE' || 'COMPLETED' || 'HOANTHANH' => 'Hoàn thành',
      'CANCEL' || 'CANCELLED' || 'HUY' => 'Đã hủy',
      _ => status,
    };

    final color = switch (normalized) {
      'CHUATOI' => cs.primary,
      'CHUAXULY' => cs.secondary,
      'DANGXULY' => cs.tertiary,
      'DATOI' || 'DONE' || 'COMPLETED' || 'HOANTHANH' => cs.primary,
      'DENMUON' => cs.error,
      'HUYLICH' || 'CANCEL' || 'CANCELLED' || 'HUY' => cs.error,
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
