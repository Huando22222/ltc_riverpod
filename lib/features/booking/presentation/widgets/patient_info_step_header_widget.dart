import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';

class PatientInfoStepHeaderWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final tt = context.textTheme;
    final cs = context.colorScheme;

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
            'Thông tin bệnh nhân',
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
              'Điền thông tin người đặt khám',
              style: tt.bodySmall?.copyWith(color: cs.primary.withOpacity(0.7)),
            ),
          ],
        ],
      ),
    );
  }
}
