import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/common/util/currency_util.dart';
import 'package:ltc/common/widgets/states/empty_data_widget.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/features/booking/presentation/widgets/estimated_fee_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/select_button_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/service_group_widget.dart';
import 'package:ltc/features/service/domain/entities/service_entity.dart';
// service_step_body.dart

class ServiceStepBodyWidget extends ConsumerWidget {
  final String dcomId;
  final List<ServiceEntity> selectedServices;
  final List<ServiceEntity> allServices;
  final bool isLoading;
  final VoidCallback onOpenModal;
  final VoidCallback onConfirm;

  const ServiceStepBodyWidget({
    super.key,
    required this.dcomId,
    required this.selectedServices,
    required this.allServices,
    required this.isLoading,
    required this.onOpenModal,
    required this.onConfirm,
  });

  double get _total => selectedServices.fold(0, (s, e) => s + e.serTotal);

  // Group selectedServices by serGroupName
  Map<String, List<ServiceEntity>> get _grouped {
    final map = <String, List<ServiceEntity>>{};
    for (final s in selectedServices) {
      map.putIfAbsent(s.serGroupName, () => []).add(s);
    }
    return map;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final tr = ref.watch(stringsProvider);
    final grouped = _grouped;

    return StepBodyContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectButtonWidget(
            hasSelected: selectedServices.isNotEmpty,
            isLoading: isLoading,
            onTap: onOpenModal,
          ),

          if (selectedServices.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...grouped.entries.map(
              (entry) => ServiceGroupWidget(
                groupName: entry.key,
                services: entry.value,
              ),
            ),
            EstimatedFeeWidget(total: _total),
            const SizedBox(height: 14),

            // ── Nút tiếp theo ─────────────────
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onConfirm,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Tiếp theo'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
