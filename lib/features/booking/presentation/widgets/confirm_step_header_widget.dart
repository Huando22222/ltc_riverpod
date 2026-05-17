import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';

class ConfirmStepHeaderWidget extends StatelessWidget {
  final bool isActive;
  final bool isCheck;
  final VoidCallback? onTap;

  const ConfirmStepHeaderWidget({
    super.key,
    required this.isActive,
    required this.isCheck,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = context.textTheme;
    final cs = context.colorScheme;

    return HeaderStepperContainerWidget(
      isActive: isActive,
      isCheck: isCheck,
      icon: FontAwesomeIcons.circleCheck,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Xác nhận đặt lịch',
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
          Text(
            isCheck
                ? 'Đã đặt lịch thành công'
                : isActive
                ? 'Kiểm tra và xác nhận thông tin'
                : 'Bước cuối cùng',
            style: tt.bodySmall?.copyWith(
              color: isCheck
                  ? cs.primary
                  : isActive
                  ? cs.primary.withOpacity(0.7)
                  : cs.onSurfaceVariant.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
