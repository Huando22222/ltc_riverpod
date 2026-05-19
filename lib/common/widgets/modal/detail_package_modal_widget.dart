// detail_package_modal_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/common/util/currency_util.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/features/service/domain/entities/package_entity.dart';
import 'package:ltc/features/service/domain/entities/package_item_entity.dart';

class DetailPackageModalWidget extends ConsumerWidget {
  final PackageEntity package;

  const DetailPackageModalWidget({super.key, required this.package});

  // Group services by serGroupId
  Map<String, List<PackageItemEntity>> get _grouped {
    final map = <String, List<PackageItemEntity>>{};
    for (final s in package.services) {
      map.putIfAbsent(s.serGroupName, () => []).add(s);
    }
    return map;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final grouped = _grouped;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  FontAwesomeIcons.boxOpen,
                  size: 18,
                  color: cs.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.packageName,
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    ),
                    if (package.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        package.description!,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        // // ── Price card ────────────────────────
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        //     decoration: BoxDecoration(
        //       color: cs.primaryContainer.withOpacity(0.35),
        //       borderRadius: BorderRadius.circular(14),
        //       border: Border.all(color: cs.primary.withOpacity(0.15)),
        //     ),
        //     child: Row(
        //       children: [
        //         Expanded(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(
        //                 'Tổng chi phí',
        //                 style: tt.labelSmall?.copyWith(
        //                   color: cs.onSurfaceVariant,
        //                 ),
        //               ),
        //               const SizedBox(height: 4),
        //               Row(
        //                 crossAxisAlignment: CrossAxisAlignment.end,
        //                 children: [
        //                   Text(
        //                     CurrencyUtil.formatPrice(
        //                       BookingUtil.calculatePackagePrice([package]),
        //                     ),
        //                     style: tt.titleMedium?.copyWith(
        //                       color: cs.primary,
        //                       fontWeight: FontWeight.w800,
        //                     ),
        //                   ),
        //                   // if (_hasDiscount) ...[
        //                   //   const SizedBox(width: 8),
        //                   //   Text(
        //                   //     CurrencyUtil.formatPrice(_total),
        //                   //     style: tt.bodySmall?.copyWith(
        //                   //       color: cs.onSurfaceVariant,
        //                   //       decoration: TextDecoration.lineThrough,
        //                   //     ),
        //                   //   ),
        //                   // ],
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //         // if (_hasDiscount)
        //         //   Container(
        //         //     padding: const EdgeInsets.symmetric(
        //         //       horizontal: 10,
        //         //       vertical: 5,
        //         //     ),
        //         //     decoration: BoxDecoration(
        //         //       color: cs.errorContainer,
        //         //       borderRadius: BorderRadius.circular(8),
        //         //     ),
        //         //     child: Text(
        //         //       package.discountPercent != null &&
        //         //               package.discountPercent! > 0
        //         //           ? 'Giảm ${package.discountPercent!.toStringAsFixed(0)}%'
        //         //           : 'Giảm ${_formatPrice(package.discountAmount!)}',
        //         //       style: tt.labelMedium?.copyWith(
        //         //         color: cs.error,
        //         //         fontWeight: FontWeight.w700,
        //         //       ),
        //         //     ),
        //         //   ),
        //       ],
        //     ),
        //   ),
        // ),
        Divider(color: cs.outlineVariant.withOpacity(0.5), height: 1),

        // ── Services list ─────────────────────
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              // Count header
              Row(
                children: [
                  Icon(FontAwesomeIcons.listCheck, size: 13, color: cs.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Danh sách dịch vụ (${package.services.length})',
                    style: tt.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Grouped services
              ...grouped.entries.map((entry) {
                final groupId = entry.key;
                final items = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group header
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
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
                            groupId,
                            style: tt.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${items.length}',
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

                    // Items
                    Container(
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Column(
                        children: List.generate(items.length, (i) {
                          final item = items[i];
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      size: 14,
                                      color: cs.primary.withOpacity(0.7),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item.serName,
                                        style: tt.bodySmall?.copyWith(
                                          color: cs.onSurface,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      CurrencyUtil.formatPrice(item.serTotal),
                                      style: tt.labelSmall?.copyWith(
                                        color: cs.onSurfaceVariant,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (i < items.length - 1)
                                Divider(
                                  color: cs.outlineVariant.withOpacity(0.4),
                                  height: 1,
                                  indent: 14,
                                  endIndent: 14,
                                ),
                            ],
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
