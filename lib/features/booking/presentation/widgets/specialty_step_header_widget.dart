// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/features/service/domain/entities/service_entity.dart';
import 'package:ltc/features/specialty/domain/entities/specialty_entity.dart';

class SpecialtyStepHeaderWidget extends ConsumerWidget {
  final bool isActive;
  final bool isCheck;
  final List<ServiceEntity> selectedServices;
  final SpecialtyEntity? selectedSpecialty;
  final VoidCallback? onTap;

  const SpecialtyStepHeaderWidget({
    super.key,
    required this.isActive,
    required this.isCheck,
    required this.selectedServices,
    this.selectedSpecialty,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = context.textTheme;
    final tr = ref.watch(stringsProvider);
    final cs = context.colorScheme;

    return HeaderStepperContainerWidget(
      isActive: isActive,
      isCheck: isCheck,
      icon: FontAwesomeIcons.hospitalUser,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Title ─────────────────────────────
          Text(
            'Chuyên khoa',
            style: tt.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isActive
                  ? cs.primary
                  : isCheck
                  ? cs.onSurface
                  : cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),

          // ── Subtitle theo trạng thái ──────────
          if (isCheck && selectedSpecialty != null) ...[
            // Đã hoàn thành — hiển thị tên chuyên khoa + số dịch vụ
            Text(
              '${selectedSpecialty!.name} · ${selectedServices.length} dịch vụ',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ] else if (isActive) ...[
            Text(
              selectedSpecialty == null
                  ? 'Chọn dịch vụ chuyên khoa'
                  : '${selectedSpecialty!.name} · ${selectedServices.length} dịch vụ',

              style: tt.bodySmall?.copyWith(
                color: cs.primary.withOpacity(0.75),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ] else ...[
            Text(
              'Chưa chọn',
              style: tt.bodySmall?.copyWith(
                color: cs.onSurfaceVariant.withOpacity(0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
