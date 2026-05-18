// package_step_header_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/features/service/domain/entities/package_entity.dart';

class PackageStepHeaderWidget extends ConsumerWidget {
  final bool isActive;
  final bool isCheck;
  final VoidCallback? onTap;
  final List<PackageEntity> selectedPackages; // ← đổi thành list

  const PackageStepHeaderWidget({
    super.key,
    required this.isActive,
    required this.isCheck,
    required this.selectedPackages, // ← required
    this.onTap,
  });

  String get _subtitle {
    if (selectedPackages.isEmpty) return 'Chưa chọn';
    if (selectedPackages.length == 1) return selectedPackages.first.packageName;
    return '${selectedPackages.length} gói đã chọn';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = context.textTheme;
    final cs = context.colorScheme;
    final hasSelected = selectedPackages.isNotEmpty;

    return HeaderStepperContainerWidget(
      isActive: isActive,
      isCheck: isCheck,
      icon: FontAwesomeIcons.boxOpen,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Chọn gói dịch vụ',
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
            isActive && hasSelected
                ? _subtitle
                : isActive
                ? 'Chọn gói phù hợp với nhu cầu'
                : isCheck
                ? _subtitle
                : 'Chưa chọn',
            style: tt.bodySmall?.copyWith(
              color: hasSelected
                  ? cs.primary.withOpacity(0.85)
                  : isActive
                  ? cs.primary.withOpacity(0.6)
                  : cs.onSurfaceVariant.withOpacity(0.5),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
