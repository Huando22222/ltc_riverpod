import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/common/widgets/states/empty_data_widget.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/features/booking/presentation/providers/booking_provider.dart';
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

  String _formatPrice(double price) {
    if (price <= 0) return 'Miễn phí';
    return '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}đ';
  }

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
          // ── Nút chọn / thêm dịch vụ ──────────
          _SelectButton(
            hasSelected: selectedServices.isNotEmpty,
            isLoading: isLoading,
            onTap: onOpenModal,
          ),

          // ── Danh sách đã chọn ─────────────────
          if (selectedServices.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...grouped.entries.map(
              (entry) => _ServiceGroup(
                groupName: entry.key,
                services: entry.value,
                formatPrice: _formatPrice,
              ),
            ),

            // ── Tổng tiền ─────────────────────
            const SizedBox(height: 4),
            Divider(color: cs.outlineVariant, height: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr.estimatedFee,
                  style: tt.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                Text(
                  _formatPrice(_total),
                  style: tt.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                  ),
                ),
              ],
            ),
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

// ─────────────────────────────────────────────
// SELECT BUTTON
// ─────────────────────────────────────────────

class _SelectButton extends ConsumerWidget {
  final bool hasSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const _SelectButton({
    required this.hasSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final tr = ref.watch(stringsProvider);
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasSelected
                ? cs.primary.withOpacity(0.4)
                : cs.outlineVariant,
            width: hasSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              hasSelected
                  ? FontAwesomeIcons.penToSquare
                  : FontAwesomeIcons.plus,
              size: 14,
              color: hasSelected ? cs.primary : cs.onSurfaceVariant,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hasSelected ? tr.editService : tr.pickService,
                style: tt.bodySmall?.copyWith(
                  color: hasSelected ? cs.primary : cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isLoading)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: cs.primary,
                ),
              )
            else
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: hasSelected ? cs.primary : cs.outlineVariant,
              ),
          ],
        ),
      ),
    );
  }
}

class _ServiceGroup extends StatelessWidget {
  final String groupName;
  final List<ServiceEntity> services;
  final String Function(double) formatPrice;

  const _ServiceGroup({
    required this.groupName,
    required this.services,
    required this.formatPrice,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group label
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 13,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 7),
              Text(
                groupName,
                style: tt.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurfaceVariant,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${services.length}',
                  style: tt.labelSmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Service rows
        ...services.map(
          (s) => Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Icon(
                  Icons.check_circle_rounded,
                  size: 14,
                  color: cs.primary.withOpacity(0.7),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    s.serName,
                    style: tt.bodySmall?.copyWith(color: cs.onSurface),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  formatPrice(s.serTotal),
                  style: tt.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
