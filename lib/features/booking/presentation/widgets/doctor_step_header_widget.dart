// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/features/doctor/domain/entities/doctor_entity.dart';

class DoctorStepHeaderWidget extends ConsumerWidget {
  final bool isActive;
  final bool isCheck;
  final DoctorEntity? doctor;
  final VoidCallback? onTap;

  const DoctorStepHeaderWidget({
    super.key,
    required this.isActive,
    required this.isCheck,
    this.doctor,
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
      icon: FontAwesomeIcons.userDoctor,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Title ─────────────────────────────
          Text(
            'Bác sĩ',
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
          if (isCheck && doctor != null) ...[
            Text(
              doctor!.title != null
                  ? '${doctor!.title} ${doctor!.name}'
                  : 'Bs. ${doctor!.name}',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ] else if (isActive) ...[
            Text(
              doctor == null
                  ? 'Chọn bác sĩ'
                  : doctor!.title != null
                  ? '${doctor!.title} ${doctor!.name}'
                  : 'Bs. ${doctor!.name}',
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
