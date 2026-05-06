import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';

// ─────────────────────────────────────────────
// STEP 1 — Chọn dịch vụ
// ─────────────────────────────────────────────

class ServiceStepHeader extends ConsumerWidget {
  final bool isActive;
  final bool isCheck;
  final VoidCallback? onTap;

  /// Tên dịch vụ đã chọn, null nếu chưa chọn
  final String? serviceName;

  const ServiceStepHeader({
    super.key,
    required this.isActive,
    required this.isCheck,
    this.onTap,
    this.serviceName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = context.textTheme;
    final tr = ref.watch(stringsProvider);
    final cs = context.colorScheme;

    return HeaderStepperContainerWidget(
      isActive: isActive,
      isCheck: isCheck,
      icon: FontAwesomeIcons.hospital,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tr.service,
            style: tt.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isActive
                  ? cs.primary
                  : isCheck
                  ? cs.onSurface
                  : cs.onSurfaceVariant,
            ),
          ),
          if (isCheck && serviceName != null) ...[
            const SizedBox(height: 2),
            Text(
              serviceName!,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ] else if (isActive) ...[
            const SizedBox(height: 2),
            Text(
              'Chọn dịch vụ',
              style: tt.bodySmall?.copyWith(color: cs.primary.withOpacity(0.7)),
            ),
          ],
        ],
      ),
    );
  }
}
