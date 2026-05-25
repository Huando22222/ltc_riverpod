import 'package:flutter/material.dart';
import 'package:ltc/common/util/currency_util.dart';
import 'package:ltc/common/util/date_time_util.dart';
import 'package:ltc/common/util/look_up_util.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/lookup/domain/entities/booking_data_detail_entity.dart';
import 'package:ltc/features/lookup/domain/entities/booking_data_entity.dart';
import 'package:ltc/features/lookup/domain/entities/package_group_entity.dart';
import 'package:ltc/features/lookup/presentation/widgets/status_badge_widget.dart';

class BookingDataModalSheetWidget extends StatelessWidget {
  const BookingDataModalSheetWidget({super.key, required this.data});

  final BookingDataEntity data;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final total = data.services.fold<double>(0, (s, e) => s + e.serTotal);
    final completed = data.services.where((e) => e.isCompleted).length;

    final packages = _packageGroups(data.services);
    final standaloneGroups = _standaloneGroups(data.services);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.horizontalPaddingScreen,
            0,
            AppSpacing.horizontalPaddingScreen,
            0,
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.assignment_ind_outlined, color: cs.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.ptnName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.ptnPhone ?? 'Chưa có số điện thoại',
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: data.status),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.horizontalPaddingScreen,
              0,
              AppSpacing.horizontalPaddingScreen,
              AppSpacing.md,
            ),
            children: [
              const SizedBox(height: 20),
              const _Title('Thông tin đăng ký'),
              const SizedBox(height: 10),
              _InfoSession(
                rows: [
                  _InfoRowData('Mã đặt lịch', data.id.substring(4)),
                  if (data.ptnId != null && data.ptnId!.isNotEmpty)
                    _InfoRowData('Mã bệnh nhân', data.ptnId!.substring(4)),
                  if (data.regId != null && data.regId!.isNotEmpty)
                    _InfoRowData('Mã đăng ký', data.regId!.substring(4)),
                  _InfoRowData(
                    'Ngày tạo',
                    DateTimeUtil.formatDateFull(data.createdAt),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (packages.isNotEmpty) ...[
                const _Title('Gói dịch vụ'),
                const SizedBox(height: 10),
                ...packages.map((group) => _PackageFlatCard(group: group)),
                const SizedBox(height: 10),
              ],
              if (standaloneGroups.isNotEmpty) ...[
                const _Title('Dịch vụ lẻ'),
                const SizedBox(height: 10),
                ...standaloneGroups.map(
                  (group) => _StandaloneGroupCard(group: group),
                ),
              ],
              if (packages.isEmpty && standaloneGroups.isEmpty)
                const _NoServiceBox(),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          decoration: BoxDecoration(
            color: cs.surface,
            border: Border(top: BorderSide(color: cs.outlineVariant)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$completed / ${data.services.length}'),
                    Text('Dịch vụ đã hoàn thành'),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    'Tạm tính',
                    style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  Text(
                    CurrencyUtil.formatPrice(total),
                    style: tt.bodyMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
    );
  }
}

class _InfoRowData {
  final String label;
  final String value;

  const _InfoRowData(this.label, this.value);
}

class _InfoSession extends StatelessWidget {
  const _InfoSession({required this.rows});

  final List<_InfoRowData> rows;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(color: cs.surface),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final row = entry.value;

          return Container(
            padding: EdgeInsets.only(left: 14, top: AppSpacing.sm),
            decoration: BoxDecoration(),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    row.label,
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
                Flexible(
                  child: Text(
                    row.value,
                    textAlign: TextAlign.right,
                    style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PackageFlatCard extends StatelessWidget {
  const _PackageFlatCard({required this.group});

  final GroupItemEntity group;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final total = group.services.fold<double>(0, (s, e) => s + e.serTotal);
    final completed = group.services.where((e) => e.isCompleted).length;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.inventory_2_outlined, size: 18, color: cs.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    group.name ?? 'Gói dịch vụ',
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      CurrencyUtil.formatPrice(total),
                      style: tt.bodySmall?.copyWith(
                        color: cs.onPrimaryContainer,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '$completed/${group.services.length} xong',
                      style: tt.labelSmall?.copyWith(
                        color: cs.onPrimaryContainer.withOpacity(.75),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ...group.services.asMap().entries.map(
            (entry) => _ServiceFlatLine(service: entry.value),
          ),
        ],
      ), //0785588272
    );
  }
}

class _StandaloneGroupCard extends StatelessWidget {
  const _StandaloneGroupCard({required this.group});

  final GroupItemEntity group;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // final total = group.services.fold<double>(0, (s, e) => s + e.serTotal);
    // final completed = group.services.where((e) => e.isCompleted).length;

    return Container(
      // margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cs.surface,
        // borderRadius: BorderRadius.circular(14),
        // border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, 0, 0),
            child: Row(
              spacing: 8,
              children: [
                Icon(Icons.folder_open_outlined, size: 18, color: cs.primary),
                Expanded(
                  child: Text(
                    group.name,
                    style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: [
                //     Text(
                //       CurrencyUtil.formatPrice(total),
                //       style: tt.bodySmall?.copyWith(
                //         color: cs.primary,
                //         fontWeight: FontWeight.w800,
                //       ),
                //     ),
                //     Text(
                //       '$completed/${group.services.length} xong',
                //       style: tt.labelSmall?.copyWith(
                //         color: cs.onSurfaceVariant,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md * 2,
              top: AppSpacing.xs,
              bottom: AppSpacing.md,
            ),
            child: Column(
              spacing: AppSpacing.xs,
              children: [
                ...group.services.asMap().entries.map(
                  (entry) => _ServiceFlatLine(service: entry.value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceFlatLine extends StatelessWidget {
  const _ServiceFlatLine({required this.service});

  final BookingDataDetailEntity service;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
      decoration: BoxDecoration(),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: service.isCompleted ? cs.tertiary : cs.outline,
            ),
          ),
          Expanded(
            child: Text(
              service.serName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            CurrencyUtil.formatPrice(service.serTotal),
            style: tt.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoServiceBox extends StatelessWidget {
  const _NoServiceBox();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(
        'Không có dịch vụ',
        style: TextStyle(color: cs.onSurfaceVariant),
      ),
    );
  }
}

List<GroupItemEntity> _packageGroups(List<BookingDataDetailEntity> services) {
  return LookUpUtil.groupServices(services).where((e) => e.isPackage).toList();
}

List<GroupItemEntity> _standaloneGroups(
  List<BookingDataDetailEntity> services,
) {
  return LookUpUtil.groupServices(services).where((e) => !e.isPackage).toList();
}
