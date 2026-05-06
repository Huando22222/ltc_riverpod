import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';

class TimeStepHeaderWidget extends StatelessWidget {
  final bool isActive;
  final bool isCheck;
  final VoidCallback? onTap;
  final String? dateTime;

  const TimeStepHeaderWidget({
    super.key,
    required this.isActive,
    required this.isCheck,
    this.onTap,
    this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    final tt = context.textTheme;
    final cs = context.colorScheme;

    return HeaderStepperContainerWidget(
      isActive: isActive,
      isCheck: isCheck,
      icon: FontAwesomeIcons.calendarDay,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Chọn thời gian',
            style: tt.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isActive
                  ? cs.primary
                  : isCheck
                  ? cs.onSurface
                  : cs.onSurfaceVariant,
            ),
          ),
          if (isCheck && dateTime != null) ...[
            const SizedBox(height: 2),
            Text(
              dateTime!,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ] else if (isActive) ...[
            const SizedBox(height: 2),
            Text(
              'Chọn ngày và khung giờ khám',
              style: tt.bodySmall?.copyWith(color: cs.primary.withOpacity(0.7)),
            ),
          ],
        ],
      ),
    );
  }
}
