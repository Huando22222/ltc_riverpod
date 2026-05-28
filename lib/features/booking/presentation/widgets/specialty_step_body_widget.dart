import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/common/helper/modal_helper.dart';
import 'package:ltc/common/util/currency_util.dart';
import 'package:ltc/common/widgets/drop_down/drop_down_widget.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/features/booking/presentation/providers/booking_provider.dart';
import 'package:ltc/features/booking/presentation/widgets/estimated_fee_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/select_button_widget.dart';
import 'package:ltc/features/booking/presentation/widgets/service_group_widget.dart';
import 'package:ltc/features/service/domain/entities/service_entity.dart';
import 'package:ltc/features/specialty/domain/entities/specialty_entity.dart';

class SpecialtyStepBodyWidget extends ConsumerWidget {
  final List<SpecialtyEntity> specialties;
  final List<ServiceEntity> allServices;
  final List<ServiceEntity> selectedServices;
  final SpecialtyEntity? selectedSpecialty;
  final bool isLoadingSpecialty;
  final bool isLoadingServices;
  final VoidCallback onConfirm;
  final String dcomId;

  const SpecialtyStepBodyWidget({
    super.key,
    required this.specialties,
    required this.allServices,
    required this.selectedServices,
    required this.selectedSpecialty,
    required this.isLoadingSpecialty,
    required this.isLoadingServices,
    required this.onConfirm,
    required this.dcomId,
  });

  /// Chỉ giữ lại specialty có ít nhất 1 service
  List<SpecialtyEntity> get _filteredSpecialties {
    final specIdsWithServices = allServices
        .where((s) => s.specId != null && s.isActive && !s.isLogicDel)
        .map((s) => s.specId!)
        .toSet();
    return specialties
        .where((sp) => specIdsWithServices.contains(sp.id))
        .toList();
  }

  /// Services thuộc specialty đang chọn
  List<ServiceEntity> get _servicesOfSelectedSpecialty {
    if (selectedSpecialty == null) return [];
    return allServices
        .where(
          (s) =>
              s.specId == selectedSpecialty!.id && s.isActive && !s.isLogicDel,
        )
        .toList();
  }

  bool get _canConfirm =>
      selectedSpecialty != null && selectedServices.isNotEmpty;

  double get _total => selectedServices.fold(0, (s, e) => s + e.serTotal);

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
    final filtered = _filteredSpecialties;
    final specialtyNames = filtered.map((e) => e.name).toList();
    return StepBodyContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLoadingSpecialty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            DropDownWidget(
              categories: specialtyNames,
              selectedCategory: selectedSpecialty?.name,
              onChanged: (name) {
                final SpecialtyEntity sp = filtered.firstWhere(
                  (e) => e.name == name,
                );
                log('pick sp $sp');
                // Khi đổi chuyên khoa → clear selected services
                ref.read(bookingProvider(dcomId).notifier)
                  ..selectSpecialty(sp)
                  ..removeServices(
                    ref.read(bookingProvider(dcomId)).selectedServices,
                  );
              },
            ),

          const SizedBox(height: 12),

          if (selectedSpecialty != null)
            SelectButtonWidget(
              hasSelected: selectedServices.isNotEmpty,
              isLoading: isLoadingServices,
              onTap: () => ModalHelper.serviceModal(
                context: context,
                services: _servicesOfSelectedSpecialty,
                selectedServices: selectedServices,
                isShowDropDown: false,
                onAdd: (value) => ref
                    .read(bookingProvider(dcomId).notifier)
                    .addServices(value),
                onRemove: (value) => ref
                    .read(bookingProvider(dcomId).notifier)
                    .removeServices(value),
              ),
            ),

          // ── Danh sách đã chọn ─────────────────
          if (selectedServices.isNotEmpty) ...[
            const SizedBox(height: 12),
            ..._grouped.entries.map(
              (entry) => ServiceGroupWidget(
                groupName: entry.key,
                services: entry.value,
              ),
            ),

            EstimatedFeeWidget(total: _total),
            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _canConfirm ? onConfirm : null,
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
