// patient_info_step_body_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
// import 'package:ltc/common/widgets/form/app_form_field.dart';
// import 'package:ltc/common/widgets/form/app_text_field.dart';
// import 'package:ltc/common/widgets/form/dob_picker.dart';
// import 'package:ltc/common/widgets/form/gender_selector.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/common/widgets/text_fields/text_input_widget.dart';
import 'package:ltc/core/config/routes.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/validators/validators.dart';
import 'package:ltc/features/auth/domain/entities/user_entity.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';
import 'package:ltc/features/booking/domain/entities/patient_booking_entity.dart';
import 'package:ltc/features/booking/presentation/screens/patient_declaration_screen.dart';

class PatientInfoStepBodyWidget extends ConsumerStatefulWidget {
  final PatientBookingEntity? selected; // ← nhận từ cha
  final ValueChanged<PatientBookingEntity> onConfirm;

  const PatientInfoStepBodyWidget({
    super.key,
    required this.onConfirm,
    this.selected,
  });

  @override
  ConsumerState<PatientInfoStepBodyWidget> createState() =>
      _PatientInfoStepBodyWidgetState();
}

class _PatientInfoStepBodyWidgetState
    extends ConsumerState<PatientInfoStepBodyWidget> {
  String _mode = 'self';

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    // ── Đã có selection → hiển thị summary + nút sửa ──
    if (widget.selected != null) {
      return StepBodyContainer(
        child: _SelectedPatientCard(
          patient: widget.selected!,
          onEdit: () => widget.onConfirm(widget.selected!), // hoặc mở lại form
        ),
      );
    }

    // ── Chưa chọn → hiển thị option ──────────────────
    return StepBodyContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PatientCard(
            key: const ValueKey('self'),
            user: user,
            onConfirm: widget.onConfirm,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              final result = await context.pushNamed(
                RouteName.patientDeclaration,
              );
            },
            icon: const Icon(FontAwesomeIcons.userPlus, size: 13),
            label: const Text('Khai báo bệnh nhân'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                PatientBookingEntity.fromUser(user!);
              },
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
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) => Divider(
    color: context.colorScheme.outlineVariant.withOpacity(0.4),
    height: .1,
  );
}

class _SelectedPatientCard extends StatelessWidget {
  final PatientBookingEntity patient;
  final VoidCallback onEdit;

  const _SelectedPatientCard({required this.patient, required this.onEdit});

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';

  String _genderLabel(Gender g) => switch (g) {
    Gender.male => 'Nam',
    Gender.female => 'Nữ',
    Gender.other => 'Khác',
  };

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.primary.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              _InfoRow(
                icon: FontAwesomeIcons.user,
                label: 'Họ và tên',
                value: patient.fullname,
              ),
              const Divider(),
              _InfoRow(
                icon: FontAwesomeIcons.venusMars,
                label: 'Giới tính',
                value: _genderLabel(patient.gender),
              ),
              const Divider(),
              _InfoRow(
                icon: FontAwesomeIcons.cakeCandles,
                label: 'Ngày sinh',
                value: _formatDate(patient.dob),
              ),
              const Divider(),
              _InfoRow(
                icon: FontAwesomeIcons.phone,
                label: 'Số điện thoại',
                value: patient.phoneNumber,
              ),
              if (patient.address != null) ...[
                const Divider(),
                _InfoRow(
                  icon: FontAwesomeIcons.locationDot,
                  label: 'Địa chỉ',
                  value: patient.address!,
                ),
              ],
              if (patient.symptom != null) ...[
                const Divider(),
                _InfoRow(
                  icon: FontAwesomeIcons.heartPulse,
                  label: 'Triệu chứng',
                  value: patient.symptom!,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
// ─────────────────────────────────────────────
// MODE SELECTOR
// ─────────────────────────────────────────────

class _PatientModeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _PatientModeSelector({required this.selected, required this.onChanged});

  static const _options = [
    ('self', 'Bản thân', FontAwesomeIcons.user),
    ('other', 'Người khác', FontAwesomeIcons.userPlus),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Row(
      children: _options.map((opt) {
        final (value, label, icon) = opt;
        final isSel = selected == value;

        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: isSel ? cs.primary : cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSel ? cs.primary : cs.outlineVariant,
                  width: isSel ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 13,
                    color: isSel ? cs.onPrimary : cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    label,
                    style: tt.labelMedium?.copyWith(
                      color: isSel ? cs.onPrimary : cs.onSurface,
                      fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
// SELF PATIENT CARD
// ─────────────────────────────────────────────

class _PatientCard extends StatelessWidget {
  final UserEntity? user;
  final ValueChanged<PatientBookingEntity> onConfirm;

  const _PatientCard({super.key, required this.user, required this.onConfirm});

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';

  String _genderLabel(String sex) => switch (sex.toLowerCase()) {
    'male' || 'nam' || 'm' => 'Nam',
    'female' || 'nữ' || 'f' => 'Nữ',
    _ => 'Khác',
  };

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    if (user == null) {
      return Center(
        child: Text(
          'Không tìm thấy thông tin tài khoản',
          style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Column(
            children: [
              _InfoRow(
                icon: FontAwesomeIcons.user,
                label: 'Họ và tên',
                value: user!.fullname,
              ),
              const _RowDivider(),
              _InfoRow(
                icon: FontAwesomeIcons.venusMars,
                label: 'Giới tính',
                value: _genderLabel(user!.sex),
              ),
              const _RowDivider(),
              _InfoRow(
                icon: FontAwesomeIcons.cakeCandles,
                label: 'Ngày sinh',
                value: _formatDate(user!.bod),
              ),
              const _RowDivider(),
              _InfoRow(
                icon: FontAwesomeIcons.phone,
                label: 'Số điện thoại',
                value: user!.phoneNumber,
              ),
              if (user!.address != null && user!.address!.isNotEmpty) ...[
                const _RowDivider(),
                _InfoRow(
                  icon: FontAwesomeIcons.locationDot,
                  label: 'Địa chỉ',
                  value: user!.address!,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Icon(icon, size: 13, color: cs.primary),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: tt.bodySmall?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
