import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ltc/common/widgets/size/animated_size_widget.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/common/widgets/text_fields/field_wrapper_widget.dart';
import 'package:ltc/common/widgets/text_fields/text_input_widget.dart';
import 'package:ltc/core/config/routes.dart';
import 'package:ltc/core/extensions/color_schema_ext.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/extensions/gender_ext.dart';
import 'package:ltc/core/validators/validators.dart';
import 'package:ltc/features/auth/domain/entities/user_entity.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';
import 'package:ltc/features/booking/domain/entities/patient_booking_entity.dart';

class PatientInfoStepBodyWidget extends ConsumerStatefulWidget {
  final PatientBookingEntity? selected;
  final ValueChanged<PatientBookingEntity?> onChanged;
  final VoidCallback onConfirm;

  const PatientInfoStepBodyWidget({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.onConfirm,
  });

  @override
  ConsumerState<PatientInfoStepBodyWidget> createState() =>
      _PatientInfoStepBodyWidgetState();
}

class _PatientInfoStepBodyWidgetState
    extends ConsumerState<PatientInfoStepBodyWidget> {
  final List<PatientBookingEntity> _patients = [];
  late final TextEditingController _symptomCtrl;
  late final TextEditingController _requestCtrl;
  late final TextEditingController _noteCtrl;
  @override
  void initState() {
    super.initState();
    _symptomCtrl = TextEditingController(text: widget.selected?.symptom ?? '');
    _requestCtrl = TextEditingController(text: widget.selected?.request ?? '');
    _noteCtrl = TextEditingController(text: widget.selected?.note ?? '');

    _symptomCtrl.addListener(_onNoteChanged);
    _requestCtrl.addListener(_onNoteChanged);
    _noteCtrl.addListener(_onNoteChanged);
  }

  void _onNoteChanged() {
    final current = widget.selected;
    if (current == null) return;

    widget.onChanged(
      PatientBookingEntity(
        fullname: current.fullname,
        gender: current.gender,
        dob: current.dob,
        phoneNumber: current.phoneNumber,
        address: current.address,
        symptom: _symptomCtrl.text.trim().isEmpty
            ? null
            : _symptomCtrl.text.trim(),
        request: _requestCtrl.text.trim().isEmpty
            ? null
            : _requestCtrl.text.trim(),
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      ),
    );
  }

  bool _isSamePatient(PatientBookingEntity a, PatientBookingEntity b) {
    return a.fullname == b.fullname &&
        a.phoneNumber == b.phoneNumber &&
        a.dob == b.dob;
  }

  void _togglePatient(PatientBookingEntity patient) {
    final selected = widget.selected;

    if (selected != null && _isSamePatient(selected, patient)) {
      // Bỏ chọn → clear notes
      _symptomCtrl.clear();
      _requestCtrl.clear();
      _noteCtrl.clear();
      widget.onChanged(null);
      return;
    }

    // Chọn patient mới → giữ notes nếu cùng người, reset nếu khác
    if (selected == null || !_isSamePatient(selected, patient)) {
      _symptomCtrl.clear();
      _requestCtrl.clear();
      _noteCtrl.clear();
    }

    widget.onChanged(patient);
  }

  void _addPatient(PatientBookingEntity patient) {
    final existed = _patients.any((e) => _isSamePatient(e, patient));

    if (!existed) {
      setState(() {
        _patients.add(patient);
      });
    }

    widget.onChanged(patient);
  }

  @override
  void dispose() {
    _symptomCtrl.dispose();
    _requestCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    final PatientBookingEntity? selfPatient = user == null
        ? null
        : PatientBookingEntity.fromUser(user);

    final patients = [?selfPatient, ..._patients];

    return StepBodyContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderNote(),

          const SizedBox(height: 14),

          if (patients.isEmpty)
            const _EmptyPatientView()
          else
            ...List.generate(patients.length, (index) {
              final patient = patients[index];
              final isSelf = index == 0 && selfPatient != null;
              final isSelected =
                  widget.selected != null &&
                  _isSamePatient(widget.selected!, patient);

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == patients.length - 1 ? 0 : 12,
                ),
                child: _PatientSelectCard(
                  patient: patient,
                  isSelf: isSelf,
                  isSelected: isSelected,
                  onTap: () => _togglePatient(patient),
                ),
              );
            }),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final result = await context.pushNamed(
                  RouteName.patientDeclaration,
                );

                if (result is PatientBookingEntity) {
                  _addPatient(result);
                }
              },
              icon: const Icon(FontAwesomeIcons.userPlus, size: 13),
              label: const Text('Khai báo bệnh nhân khác'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          AnimatedSizeWidget(
            isExpanded: widget.selected != null,
            child: Column(
              children: [
                FieldWrapperWidget(
                  label: 'Triệu chứng',
                  icon: FontAwesomeIcons.heartPulse,
                  child: TextInputWidget(
                    controller: _symptomCtrl,
                    onChanged: (value) {},
                    hint: 'Mô tả triệu chứng hiện tại...',
                  ),
                ),

                FieldWrapperWidget(
                  label: 'Yêu cầu khám',
                  icon: FontAwesomeIcons.clipboardList,
                  child: TextInputWidget(
                    controller: _requestCtrl,
                    hint: 'Yêu cầu đặc biệt với bác sĩ (nếu có)...',
                    keyboardType: TextInputType.phone,
                  ),
                ),

                FieldWrapperWidget(
                  label: 'Ghi chú',
                  icon: FontAwesomeIcons.noteSticky,
                  child: TextInputWidget(
                    controller: _noteCtrl,
                    hint: 'Thông tin thêm cần lưu ý...',
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.selected == null ? null : widget.onConfirm,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
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

class _HeaderNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withOpacity(0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(FontAwesomeIcons.users, size: 14, color: cs.onPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Chọn người sẽ sử dụng dịch vụ khám. Bạn có thể chọn tài khoản hiện tại hoặc khai báo thêm người thân.',
              style: tt.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientSelectCard extends StatelessWidget {
  final PatientBookingEntity patient;
  final bool isSelf;
  final bool isSelected;
  final VoidCallback onTap;

  const _PatientSelectCard({
    required this.patient,
    required this.isSelf,
    required this.isSelected,
    required this.onTap,
  });

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? cs.primaryContainer.withOpacity(0.5) : cs.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: cs.softShadow,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          patient.fullname,
                          style: tt.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                      if (isSelf)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: cs.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Tôi',
                            style: tt.labelSmall?.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    children: [
                      _InfoChip(
                        icon: FontAwesomeIcons.venusMars,
                        text: patient.gender.genderLabel(),
                      ),
                      _InfoChip(
                        icon: FontAwesomeIcons.cakeCandles,
                        text: _formatDate(patient.dob),
                      ),
                      _InfoChip(
                        icon: FontAwesomeIcons.phone,
                        text: patient.phoneNumber,
                      ),
                    ],
                  ),

                  if (patient.address != null &&
                      patient.address!.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _SmallInfoLine(
                      icon: FontAwesomeIcons.locationDot,
                      text: patient.address!,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 8),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              child: Icon(
                isSelected
                    ? FontAwesomeIcons.circleCheck
                    : FontAwesomeIcons.circle,
                key: ValueKey(isSelected),
                size: 20,
                color: isSelected ? cs.primary : cs.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: cs.primary),
          const SizedBox(width: 5),
          Text(
            text,
            style: tt.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallInfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SmallInfoLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Row(
      children: [
        Icon(icon, size: 12, color: cs.primary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: tt.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyPatientView extends StatelessWidget {
  const _EmptyPatientView();

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(
        'Chưa có thông tin bệnh nhân.',
        style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
      ),
    );
  }
}
