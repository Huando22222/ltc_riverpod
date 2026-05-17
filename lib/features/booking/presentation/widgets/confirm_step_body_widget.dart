import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/extensions/gender_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/booking/domain/entities/patient_booking_entity.dart';
import 'package:ltc/features/service/domain/entities/service_entity.dart';

class ConfirmStepBodyWidget extends ConsumerWidget {
  final List<ServiceEntity> services;
  final DateTime selectedDate;
  final TimeOfDay selectedSlot;
  final PatientBookingEntity patient;
  final VoidCallback onSubmit;
  final bool isLoading;

  const ConfirmStepBodyWidget({
    super.key,
    required this.services,
    required this.selectedDate,
    required this.selectedSlot,
    required this.patient,
    required this.onSubmit,
    this.isLoading = false,
  });

  double get _total => services.fold(0, (s, e) => s + e.serTotal);

  String _formatPrice(double price) {
    if (price <= 0) return 'Miễn phí';
    return '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}đ';
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final tr = ref.watch(stringsProvider);

    return StepBodyContainer(
      child: Column(
        spacing: AppSpacing.xs,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Dịch vụ ───────────────────────────
          _ConfirmSection(
            icon: FontAwesomeIcons.hospital,
            label: 'Dịch vụ',
            child: Column(
              children: [
                ...services.map(
                  (s) => _ConfirmRow(
                    label: s.serName,
                    value: _formatPrice(s.serTotal),
                  ),
                ),
                const SizedBox(height: 4),
                Divider(color: cs.outlineVariant, height: 1),
                const SizedBox(height: 4),
                _ConfirmRow(
                  label: tr.estimatedFee,
                  value: _formatPrice(_total),
                  isTotal: true,
                ),
              ],
            ),
          ),

          Divider(),

          // ── Thời gian ─────────────────────────
          _ConfirmSection(
            icon: FontAwesomeIcons.calendarDay,
            label: 'Thời gian',
            child: _ConfirmRow(
              label: tr.bookingSummary(selectedDate, selectedSlot),
              value: '',
            ),
          ),

          Divider(),

          // ── Bệnh nhân ─────────────────────────
          _ConfirmSection(
            icon: FontAwesomeIcons.user,
            label: 'Bệnh nhân',
            child: Column(
              children: [
                _ConfirmRow(label: 'Họ tên', value: patient.fullname),
                _ConfirmRow(
                  label: 'Giới tính',
                  value: patient.gender.genderLabel(),
                ),
                _ConfirmRow(
                  label: 'Ngày sinh',
                  value: _formatDate(patient.dob),
                ),
                _ConfirmRow(label: 'Điện thoại', value: patient.phoneNumber),
                if (patient.address != null)
                  _ConfirmRow(label: 'Địa chỉ', value: patient.address!),
              ],
            ),
          ),

          // ── Ghi chú & Triệu chứng ─────────────
          if (patient.symptom != null ||
              patient.request != null ||
              patient.note != null) ...[
            Divider(),
            _ConfirmSection(
              icon: FontAwesomeIcons.notesMedical,
              label: 'Ghi chú & Triệu chứng',
              child: Column(
                children: [
                  if (patient.symptom != null)
                    _ConfirmRow(label: 'Triệu chứng', value: patient.symptom!),
                  if (patient.request != null)
                    _ConfirmRow(label: 'Yêu cầu', value: patient.request!),
                  if (patient.note != null)
                    _ConfirmRow(label: 'Ghi chú', value: patient.note!),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // ── Submit ────────────────────────────
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isLoading ? null : onSubmit,
              icon: isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: cs.onPrimary,
                      ),
                    )
                  : const Icon(FontAwesomeIcons.circleCheck, size: 15),
              label: Text(isLoading ? 'Đang xử lý...' : 'Xác nhận đặt lịch'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CONFIRM SECTION
// ─────────────────────────────────────────────

class _ConfirmSection extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;

  const _ConfirmSection({
    required this.icon,
    required this.label,
    required this.child,
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
            Icon(icon, size: 12, color: cs.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: tt.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

// ─────────────────────────────────────────────
// CONFIRM ROW
// ─────────────────────────────────────────────

class _ConfirmRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _ConfirmRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: tt.bodySmall?.copyWith(
                color: isTotal ? cs.onSurface : cs.onSurfaceVariant,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          if (value.isNotEmpty)
            Expanded(
              flex: 3,
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: tt.bodySmall?.copyWith(
                  color: isTotal ? cs.primary : cs.onSurface,
                  fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
