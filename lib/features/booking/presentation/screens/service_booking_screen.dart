import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/common/widgets/scaffold/app_scaffold_widget.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/theme/app_spacing.dart';

// ─────────────────────────────────────────────
// SERVICE BOOKING SCREEN
// ─────────────────────────────────────────────

class ServiceBookingScreen extends ConsumerStatefulWidget {
  const ServiceBookingScreen({super.key});

  @override
  ConsumerState<ServiceBookingScreen> createState() =>
      _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends ConsumerState<ServiceBookingScreen> {
  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(stringsProvider);
    return AppScaffoldWidget(
      title: tr.service,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.horizontalPaddingScreen,
          vertical: AppSpacing.md,
        ),
        child: VerticalStepperWidget(
          stepper: [
            VerticalStepperItemWidget(
              isActive: true,
              isCheck: true,
              isFirst: true,
              isLast: false,
              header: HeaderStepperContainer(
                isActive: true,
                isCheck: true,
                icon: Icons.calendar_today,
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Chọn thời gian'),
                    Text('Thứ Ba, 06/05/2025'),
                  ],
                ),
              ),
              body: StepBodyContainer(child: _TimePickerBody()),
            ),
            VerticalStepperItemWidget(
              isActive: false,
              isCheck: false,
              isFirst: false,
              isLast: true,
              header: // Cách dùng
              HeaderStepperContainer(
                isActive: true,
                isCheck: false,
                icon: Icons.calendar_today,
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Chọn thời gian'),
                    Text('Thứ Ba, 06/05/2025'),
                  ],
                ),
              ),
              body: StepBodyContainer(child: _TimePickerBody()),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SAMPLE BODY: TIME PICKER
// ─────────────────────────────────────────────

class _TimePickerBody extends StatefulWidget {
  @override
  State<_TimePickerBody> createState() => _TimePickerBodyState();
}

class _TimePickerBodyState extends State<_TimePickerBody> {
  int? selectedSlot;
  final List<String> slots = [
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '14:00',
    '14:30',
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thứ Ba, 06 tháng 5, 2025',
          style: tt.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(slots.length, (i) {
            final isSelected = selectedSlot == i;
            return GestureDetector(
              onTap: () => setState(() => selectedSlot = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? cs.primary : cs.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? cs.primary : cs.outlineVariant,
                  ),
                ),
                child: Text(
                  slots[i],
                  style: tt.bodySmall?.copyWith(
                    color: isSelected ? cs.onPrimary : cs.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: selectedSlot != null ? () {} : null,
            child: const Text('Xác nhận giờ hẹn'),
          ),
        ),
      ],
    );
  }
}
