import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/features/service/domain/entities/service_entity.dart';

class ServiceStepHeaderWidget extends ConsumerWidget {
  final bool isActive;
  final bool isCheck;
  final VoidCallback? onTap;
  final List<ServiceEntity> selectedServices;

  const ServiceStepHeaderWidget({
    super.key,
    required this.isActive,
    required this.isCheck,
    required this.selectedServices,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = context.textTheme;
    final tr = ref.watch(stringsProvider);
    final cs = context.colorScheme;

    final int count = selectedServices.length;

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
          const SizedBox(height: 2),
          Text(
            tr.selectedServiceCount(count),
            style: tt.bodySmall?.copyWith(
              color: count > 0
                  ? cs.primary.withOpacity(0.85)
                  : cs.primary.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
