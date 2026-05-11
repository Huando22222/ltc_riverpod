import 'package:flutter/material.dart';
import 'package:ltc/core/extensions/context_ext.dart';

class DateCardWidget extends StatelessWidget {
  final bool isSelected;
  final bool isToday;
  final String weekDate;
  final String date;
  final String month;

  const DateCardWidget({
    super.key,
    required this.isSelected,
    required this.weekDate,
    required this.date,
    required this.month,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 52,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: isSelected ? cs.primary : cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? cs.primary
              : isToday
              ? cs.primary.withOpacity(0.4)
              : cs.outlineVariant,
          width: isSelected || isToday ? 1.5 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: cs.primary.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weekDate,
            style: tt.labelSmall!.copyWith(
              color: isSelected
                  ? cs.onPrimary.withOpacity(0.8)
                  : isToday
                  ? cs.primary
                  : cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isSelected ? cs.onPrimary : cs.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            month,
            style: TextStyle(
              fontSize: 11,
              color: isSelected
                  ? cs.onPrimary.withOpacity(0.8)
                  : isToday
                  ? cs.primary
                  : cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          if (isToday && !isSelected) ...[
            const SizedBox(height: 3),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: cs.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
