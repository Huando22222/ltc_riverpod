import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';

class PatientInfoStepHeaderWidget extends ConsumerWidget {
  final bool isActive;
  final bool isCheck;
  final VoidCallback? onTap;

  /// Tên bệnh nhân đã điền, null nếu chưa
  final String? patientName;

  const PatientInfoStepHeaderWidget({
    super.key,
    required this.isActive,
    required this.isCheck,
    this.onTap,
    this.patientName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = context.textTheme;
    final cs = context.colorScheme;
    final tr = ref.watch(stringsProvider);
    return HeaderStepperContainerWidget(
      isActive: isActive,
      isCheck: isCheck,
      icon: FontAwesomeIcons.userPen,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tr.patientInfo,
            style: tt.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isActive
                  ? cs.primary
                  : isCheck
                  ? cs.onSurface
                  : cs.onSurfaceVariant,
            ),
          ),
          if (isCheck && patientName != null) ...[
            const SizedBox(height: 2),
            Text(
              patientName!,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ] else if (isActive) ...[
            const SizedBox(height: 2),
            Text(
              tr.fillPatientInfo,
              style: tt.bodySmall?.copyWith(color: cs.primary.withOpacity(0.7)),
            ),
          ],
        ],
      ),
    );
  }
}
