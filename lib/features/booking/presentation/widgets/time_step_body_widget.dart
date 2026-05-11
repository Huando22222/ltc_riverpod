import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/common/util/date_time_util.dart';
import 'package:ltc/common/widgets/card/date_card_widget.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/theme/app_spacing.dart';

class TimeStepBodyWidget extends ConsumerWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedSlot;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onSlotChanged;
  final VoidCallback onConfirm;

  const TimeStepBodyWidget({
    super.key,
    required this.selectedDate,
    required this.selectedSlot,
    required this.onDateChanged,
    required this.onSlotChanged,
    required this.onConfirm,
  });
  // Static data — computed once, shared across rebuilds
  static final List<DateTime> _dates = DateTimeUtil.upcomingDays(count: 14);
  static final List<TimeOfDay> _slots = DateTimeUtil.generate();
  static final List<TimeOfDay> _morning = _slots
      .where(DateTimeUtil.isMorning)
      .toList();
  static final List<TimeOfDay> _afternoon = _slots
      .where(DateTimeUtil.isAfternoon)
      .toList();
  bool get _canConfirm => selectedDate != null && selectedSlot != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(stringsProvider);
    return StepBodyContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Date picker ───────────────────────
          _SectionLabel(label: tr.pickDate, icon: Icons.calendar_month_rounded),
          const SizedBox(height: 8),

          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _dates.length,
              separatorBuilder: (_, i) => const SizedBox(width: AppSpacing.xs),
              itemBuilder: (_, i) {
                final d = _dates[i];
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    return onDateChanged(d);
                  },
                  child: DateCardWidget(
                    isSelected:
                        selectedDate != null &&
                        DateTimeUtil.isSameDay(d, selectedDate!),
                    weekDate: tr.shortWeekday(d.weekday),
                    date: d.day.toString(),
                    month: tr.shortMonth(d.month),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // ── Time slots ────────────────────────
          _SectionLabel(label: tr.pickTime, icon: Icons.access_time_rounded),
          const SizedBox(height: 10),
          _SlotGroup(
            label: tr.morning,
            slots: _morning,
            selectedSlot: selectedSlot,
            onTap: onSlotChanged,
          ),
          const SizedBox(height: 12),
          _SlotGroup(
            label: tr.afternoon,
            slots: _afternoon,
            selectedSlot: selectedSlot,
            onTap: onSlotChanged,
          ),

          // ── Confirm ───────────────────────────
          if (_canConfirm) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onConfirm,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Tiếp theo'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SlotGroup extends StatelessWidget {
  final String label;
  final List<TimeOfDay> slots;
  final TimeOfDay? selectedSlot;
  final ValueChanged<TimeOfDay> onTap;

  const _SlotGroup({
    required this.label,
    required this.slots,
    required this.selectedSlot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 13,
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: tt.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: slots.map((slot) {
            final isSel =
                selectedSlot != null &&
                slot.hour == selectedSlot!.hour &&
                slot.minute == selectedSlot!.minute;
            return _SlotChip(
              slot: slot,
              isSelected: isSel,
              onTap: () => onTap(slot),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SLOT CHIP
// ─────────────────────────────────────────────

class _SlotChip extends StatelessWidget {
  final TimeOfDay slot;
  final bool isSelected;
  final VoidCallback onTap;

  const _SlotChip({
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          DateTimeUtil.formatTimeOfDay(slot),
          style: tt.bodySmall?.copyWith(
            color: isSelected ? cs.onPrimary : cs.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SECTION LABEL
// ─────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SectionLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Row(
      children: [
        Icon(icon, size: 14, color: cs.primary),
        const SizedBox(width: 6),
        Text(
          label,
          style: tt.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}
