import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ltc/common/widgets/scaffold/app_scaffold_widget.dart';
import 'package:ltc/common/widgets/text_fields/field_wrapper_widget.dart';
import 'package:ltc/common/widgets/text_fields/text_input_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/formatters/formatters.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/core/validators/validators.dart';
import 'package:ltc/features/booking/domain/entities/patient_booking_entity.dart';

class PatientDeclarationScreen extends ConsumerStatefulWidget {
  const PatientDeclarationScreen({super.key});

  @override
  ConsumerState<PatientDeclarationScreen> createState() =>
      _PatientDeclarationScreenState();
}

class _PatientDeclarationScreenState
    extends ConsumerState<PatientDeclarationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _symptomCtrl = TextEditingController();
  final _requestCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  String? _gender;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dobCtrl.dispose();
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

  DateTime? _parseDob() {
    try {
      final parts = _dobCtrl.text.trim().split('/');
      if (parts.length != 3) return null;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final date = DateTime(year, month, day);

      if (date.day != day || date.month != month || date.year != year) {
        return null;
      }

      return date;
    } catch (_) {
      return null;
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_gender == null) return;

    final dob = _parseDob();
    if (dob == null) return;

    context.pop(
      PatientBookingEntity(
        fullname: _nameCtrl.text.trim(),
        gender: _toGender(_gender!),
        dob: dob,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(stringsProvider);
    final cs = context.colorScheme;

    return AppScaffoldWidget(
      title: 'Khai báo bệnh nhân',
      child: Expanded(
        child: Container(
          color: cs.surfaceContainerLowest,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.horizontalPaddingScreen,
                    16,
                    AppSpacing.horizontalPaddingScreen,
                    120,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionHeader(
                          icon: FontAwesomeIcons.idCard,
                          label: 'Thông tin cơ bản',
                          subtitle: 'Thông tin dùng để tạo lịch hẹn',
                        ),
                        const SizedBox(height: 14),

                        _FormCard(
                          children: [
                            _FormItem(
                              child: FieldWrapperWidget(
                                label: 'Họ và tên',
                                icon: FontAwesomeIcons.user,
                                isRequired: true,
                                child: TextInputWidget(
                                  controller: _nameCtrl,
                                  hint: 'Nguyễn Văn A',
                                  textCapitalization: TextCapitalization.words,
                                  inputFormatters: [CapitalFormatter()],
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty)
                                      ? 'Vui lòng nhập họ tên'
                                      : null,
                                ),
                              ),
                            ),
                            const _CardDivider(),
                            _FormItem(
                              child: FieldWrapperWidget(
                                label: 'Giới tính',
                                icon: FontAwesomeIcons.venusMars,
                                isRequired: true,
                                child: GenderSelector(
                                  selected: _gender,
                                  onChanged: (v) {
                                    setState(() => _gender = v);
                                  },
                                ),
                              ),
                            ),
                            const _CardDivider(),
                            _FormItem(
                              child: FieldWrapperWidget(
                                label: 'Ngày sinh',
                                icon: FontAwesomeIcons.cakeCandles,
                                isRequired: true,
                                child: TextInputWidget(
                                  controller: _dobCtrl,
                                  hint: 'DD/MM/YYYY',
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    DateInputFormatter(),
                                  ],
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Vui lòng nhập ngày sinh';
                                    }
                                    if (_parseDob() == null) {
                                      return 'Ngày sinh không hợp lệ';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const _CardDivider(),
                            _FormItem(
                              child: FieldWrapperWidget(
                                label: 'Số điện thoại',
                                icon: FontAwesomeIcons.phone,
                                isRequired: true,
                                child: TextInputWidget(
                                  controller: _phoneCtrl,
                                  hint: '0912 xxx xxx',
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  validator: Validators.phone,
                                ),
                              ),
                            ),
                            const _CardDivider(),
                            _FormItem(
                              child: FieldWrapperWidget(
                                label: 'Địa chỉ',
                                icon: FontAwesomeIcons.locationDot,
                                child: TextInputWidget(
                                  controller: _addressCtrl,
                                  hint: 'Số nhà, đường, phường/xã...',
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        const _SectionHeader(
                          icon: FontAwesomeIcons.stethoscope,
                          label: 'Thông tin khám',
                          subtitle:
                              'Mô tả tình trạng để bác sĩ chuẩn bị tốt hơn',
                        ),
                        const SizedBox(height: 14),

                        _FormCard(
                          children: [
                            _FormItem(
                              child: FieldWrapperWidget(
                                label: 'Triệu chứng',
                                icon: FontAwesomeIcons.heartPulse,
                                child: TextInputWidget(
                                  controller: _symptomCtrl,
                                  hint: 'Mô tả triệu chứng hiện tại...',
                                  maxLines: 3,
                                  maxLength: 500,
                                ),
                              ),
                            ),
                            const _CardDivider(),
                            _FormItem(
                              child: FieldWrapperWidget(
                                label: 'Yêu cầu khám',
                                icon: FontAwesomeIcons.clipboardList,
                                child: TextInputWidget(
                                  controller: _requestCtrl,
                                  hint: 'Yêu cầu đặc biệt với bác sĩ...',
                                  maxLines: 2,
                                  maxLength: 300,
                                ),
                              ),
                            ),
                            const _CardDivider(),
                            _FormItem(
                              child: FieldWrapperWidget(
                                label: 'Ghi chú',
                                icon: FontAwesomeIcons.noteSticky,
                                child: TextInputWidget(
                                  controller: _noteCtrl,
                                  hint: 'Thông tin thêm cần lưu ý...',
                                  maxLines: 2,
                                  maxLength: 300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              _BottomSubmitButton(label: tr.next, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;

  const _SectionHeader({
    required this.icon,
    required this.label,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Padding(
      padding: const EdgeInsets.only(left: 2, right: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 16, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle!,
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.25,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  final List<Widget> children;

  const _FormCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.55)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class _FormItem extends StatelessWidget {
  final Widget child;

  const _FormItem({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: child,
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: context.colorScheme.outlineVariant.withOpacity(0.45),
      height: 1,
      indent: 18,
      endIndent: 18,
    );
  }
}

class _BottomSubmitButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _BottomSubmitButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.horizontalPaddingScreen,
        12,
        AppSpacing.horizontalPaddingScreen,
        16,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          top: BorderSide(color: cs.outlineVariant.withOpacity(0.45)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton.icon(
          onPressed: onPressed,
          icon: const Icon(FontAwesomeIcons.arrowRight, size: 15),
          label: Text(label),
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
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
      children: List.generate(_options.length, (index) {
        final opt = _options[index];
        final value = opt.$1;
        final label = opt.$2;
        final icon = opt.$3;
        final isSelected = selected == value;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == _options.length - 1 ? 0 : 10,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onChanged(value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(
                  vertical: 13,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? cs.primary
                      : cs.surfaceContainerHighest.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? cs.primary
                        : cs.outlineVariant.withOpacity(0.75),
                    width: isSelected ? 1.4 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: isSelected ? cs.onPrimary : cs.primary,
                    ),
                    const SizedBox(height: 7),
                    Text(
                      label,
                      style: tt.labelMedium?.copyWith(
                        color: isSelected ? cs.onPrimary : cs.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
