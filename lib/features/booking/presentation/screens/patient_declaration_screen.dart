import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ltc/common/widgets/scaffold/app_scaffold_widget.dart';
import 'package:ltc/common/widgets/text_fields/field_wrapper_widget.dart';
import 'package:ltc/common/widgets/text_fields/text_input_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/validators/validators.dart';
import 'package:ltc/features/booking/domain/entities/patient_booking_entity.dart';

class PatientDeclarationScreen extends ConsumerStatefulWidget {
  const PatientDeclarationScreen({super.key});

  @override
  ConsumerState<PatientDeclarationScreen> createState() =>
      _OtherPatientFormState();
}

class _OtherPatientFormState extends ConsumerState<PatientDeclarationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _symptomCtrl = TextEditingController();
  final _requestCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  DateTime? _dob;
  String? _gender;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _symptomCtrl.dispose();
    _requestCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Gender _toGender(String v) => switch (v) {
    'male' => Gender.male,
    'female' => Gender.female,
    _ => Gender.other,
  };

  void _submit() {
    if (_gender == null || _dob == null) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.pop({
      'patient': PatientBookingEntity(
        fullname: _nameCtrl.text.trim(),
        gender: _toGender(_gender!),
        dob: _dob!,
        phoneNumber: _phoneCtrl.text.trim(),
        address: _addressCtrl.text.trim().isEmpty
            ? null
            : _addressCtrl.text.trim(),
        symptom: _symptomCtrl.text.trim().isEmpty
            ? null
            : _symptomCtrl.text.trim(),
        request: _requestCtrl.text.trim().isEmpty
            ? null
            : _requestCtrl.text.trim(),
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(stringsProvider);
    return AppScaffoldWidget(
      title: 'Khai báo',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            FieldWrapperWidget(
              label: 'Họ và tên',
              icon: FontAwesomeIcons.user,
              isRequired: true,
              child: TextInputWidget(
                controller: _nameCtrl,
                hint: 'Nguyễn Văn A',
                textCapitalization: TextCapitalization.words,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Vui lòng nhập họ tên'
                    : null,
              ),
            ),
            const Divider(),
            FieldWrapperWidget(
              label: 'Giới tính',
              icon: FontAwesomeIcons.venusMars,
              isRequired: true,
              child: GenderSelector(
                selected: _gender,
                onChanged: (v) => setState(() => _gender = v),
              ),
            ),
            const Divider(),
            FieldWrapperWidget(
              label: 'Ngày sinh',
              icon: FontAwesomeIcons.cakeCandles,
              isRequired: true,
              child: Text("data"),
            ),
            const Divider(),
            FieldWrapperWidget(
              label: 'Số điện thoại',
              icon: FontAwesomeIcons.phone,
              isRequired: true,
              child: TextInputWidget(
                controller: _phoneCtrl,
                hint: '0912 345 678',
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  return Validators.phone(value);
                },
              ),
            ),
            Divider(),
            FieldWrapperWidget(
              label: 'Địa chỉ',
              icon: FontAwesomeIcons.locationDot,
              child: TextInputWidget(
                controller: _addressCtrl,
                hint: 'Số nhà, đường, phường/xã...',
                maxLines: 2,
              ),
            ),
            const Divider(),
            FieldWrapperWidget(
              label: 'Triệu chứng',
              icon: FontAwesomeIcons.heartPulse,
              child: TextInputWidget(
                controller: _symptomCtrl,
                hint: 'Mô tả triệu chứng hiện tại...',
                maxLines: 3,
                maxLength: 500,
              ),
            ),
            const Divider(),
            FieldWrapperWidget(
              label: 'Yêu cầu khám',
              icon: FontAwesomeIcons.clipboardList,
              child: TextInputWidget(
                controller: _requestCtrl,
                hint: 'Yêu cầu đặc biệt với bác sĩ (nếu có)...',
                maxLines: 2,
                maxLength: 300,
              ),
            ),
            const Divider(),
            FieldWrapperWidget(
              label: 'Ghi chú',
              icon: FontAwesomeIcons.noteSticky,
              child: TextInputWidget(
                controller: _noteCtrl,
                hint: 'Thông tin thêm cần lưu ý...',
                maxLines: 2,
                maxLength: 300,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(tr.next),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GenderSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onChanged;

  const GenderSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _options = [
    ('male', 'Nam', FontAwesomeIcons.mars),
    ('female', 'Nữ', FontAwesomeIcons.venus),
    ('other', 'Khác', FontAwesomeIcons.genderless),
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
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSel ? cs.primary : cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSel ? cs.primary : cs.outlineVariant,
                  width: isSel ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: 14,
                    color: isSel ? cs.onPrimary : cs.onSurfaceVariant,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: tt.labelSmall?.copyWith(
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
