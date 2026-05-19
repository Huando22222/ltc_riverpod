// package_step_body_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/common/helper/modal_helper.dart';
import 'package:ltc/common/util/booking_util.dart';
import 'package:ltc/common/util/currency_util.dart';
import 'package:ltc/common/widgets/states/empty_data_widget.dart';
import 'package:ltc/common/widgets/states/loading_widget.dart';
import 'package:ltc/common/widgets/stepper/vertical_stepper_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/features/booking/presentation/widgets/estimated_fee_widget.dart';
import 'package:ltc/features/service/domain/entities/package_entity.dart';

class PackageStepBodyWidget extends ConsumerWidget {
  final List<PackageEntity> packages;
  final List<PackageEntity> selectedPackages;
  final bool isLoading;
  final ValueChanged<PackageEntity> onToggle;
  final VoidCallback onConfirm;

  const PackageStepBodyWidget({
    super.key,
    required this.packages,
    required this.selectedPackages,
    required this.isLoading,
    required this.onToggle,
    required this.onConfirm,
  });

  bool _isSelected(PackageEntity pkg) =>
      selectedPackages.any((p) => p.packageId == pkg.packageId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(stringsProvider);
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return StepBodyContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Loading ───────────────────────────
          if (isLoading)
            const LoadingWidget()
          // ── Empty ─────────────────────────────
          else if (packages.isEmpty)
            const EmptyDataWidget()
          // ── List ──────────────────────────────
          else
            ...packages.map(
              (pkg) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _PackageCard(
                  package: pkg,
                  isSelected: _isSelected(pkg),
                  onToggle: () => onToggle(pkg),
                  onDetail: () => ModalHelper.showDetailPackageModal(
                    context: context,
                    package: pkg,
                  ),
                ),
              ),
            ),

          // ── Summary + Confirm ─────────────────
          if (selectedPackages.isNotEmpty)
            EstimatedFeeWidget(
              total: BookingUtil.calculatePackagePrice(selectedPackages),
            ),

          const SizedBox(height: 12),
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
              child: Text(tr.next),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PACKAGE CARD — gọn, chỉ hiện tên + giá + nút xem chi tiết
// ─────────────────────────────────────────────

class _PackageCard extends StatelessWidget {
  final PackageEntity package;
  final bool isSelected;
  final VoidCallback onToggle;
  final VoidCallback onDetail;

  const _PackageCard({
    required this.package,
    required this.isSelected,
    required this.onToggle,
    required this.onDetail,
  });

  bool get _hasDiscount =>
      (package.discountAmount != null && package.discountAmount! > 0) ||
      (package.discountPercent != null && package.discountPercent! > 0);

  String get _discountLabel {
    if (package.discountPercent != null && package.discountPercent! > 0) {
      return '-${package.discountPercent!.toStringAsFixed(0)}%';
    }
    if (package.discountAmount != null && package.discountAmount! > 0) {
      return '-${CurrencyUtil.formatPrice(package.discountAmount!)}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: cs.outlineVariant,
            width: isSelected ? 1 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Checkbox ──────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                color: isSelected ? cs.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? cs.primary : cs.outlineVariant,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded, color: cs.onPrimary, size: 14)
                  : null,
            ),

            const SizedBox(width: 12),

            // ── Info ──────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    package.packageName,
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),

                  if (package.description != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      package.description!,
                      style: tt.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 8),

                  // Price row
                  Row(
                    children: [
                      // Discount badge
                      if (_hasDiscount) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: cs.errorContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _discountLabel,
                            style: tt.labelSmall?.copyWith(
                              color: cs.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          CurrencyUtil.formatPrice(
                            BookingUtil.calculatePackagePrice([package]),
                          ),
                          style: tt.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        CurrencyUtil.formatPrice(
                          BookingUtil.calculatePackagePrice([package]),
                        ),
                        style: tt.labelMedium?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),

                      // Xem chi tiết
                      GestureDetector(
                        onTap: onDetail,
                        child: Row(
                          children: [
                            Text(
                              '${package.services.length} dịch vụ',
                              style: tt.labelSmall?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 14,
                              color: cs.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
