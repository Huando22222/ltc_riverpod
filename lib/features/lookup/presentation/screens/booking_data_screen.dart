import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ltc/common/helper/modal_helper.dart';
import 'package:ltc/common/util/currency_util.dart';
import 'package:ltc/common/util/date_time_util.dart';
import 'package:ltc/common/util/filter_util.dart';
import 'package:ltc/common/util/look_up_util.dart';
import 'package:ltc/common/widgets/header/header_widget.dart';
import 'package:ltc/common/widgets/search_bar/search_bar_widget.dart';
import 'package:ltc/common/widgets/states/empty_data_widget.dart';
import 'package:ltc/common/widgets/states/error_data_widget.dart';
import 'package:ltc/common/widgets/states/loading_widget.dart';
import 'package:ltc/common/widgets/states/refresh_widget.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/lookup/data/models/booking_data_model.dart';
import 'package:ltc/features/lookup/domain/entities/booking_data_detail_entity.dart';
import 'package:ltc/features/lookup/domain/entities/booking_data_entity.dart';
import 'package:ltc/features/lookup/presentation/providers/booking_data_provider.dart';
import 'package:ltc/features/lookup/presentation/widgets/status_badge_widget.dart';

class BookingDataScreen extends ConsumerStatefulWidget {
  const BookingDataScreen({super.key});

  @override
  ConsumerState<BookingDataScreen> createState() => _BookingDataScreenState();
}

class _BookingDataScreenState extends ConsumerState<BookingDataScreen> {
  final _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BookingDataEntity> filterData(List<BookingDataEntity> data) {
    return FilterUtil.filterData(
      data,
      _searchController.text,
      searchFields: (item) => [
        item.ptnName,
        item.ptnName,
        item.id,
        // item.regId,
        // item.ptnPhone,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(bookingDataProvider);
    final tr = ref.read(stringsProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(title: tr.lookup),

            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.horizontalPaddingScreen,
                right: AppSpacing.horizontalPaddingScreen,
                top: AppSpacing.sm,
                bottom: AppSpacing.sm,
              ),
              child: SearchBarWidget(
                hint: 'tr.search',
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: asyncData.when(
                loading: () => const LoadingWidget(),
                error: (_, _) => ErrorDataWidget(
                  onRetry: () => ref.invalidate(bookingDataProvider),
                ),
                data: (items) {
                  final filtered = filterData(items);

                  if (filtered.isEmpty &&
                      _searchController.text.trim().isNotEmpty) {
                    return EmptyDataWidget();
                  }
                  return RefreshWidget(
                    onRefresh: () async {
                      ref.refresh(bookingDataProvider.future);
                    },
                    childIsScrollable: true,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.horizontalPaddingScreen,
                        0,
                        AppSpacing.horizontalPaddingScreen,
                        110,
                      ),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        return _BookingCard(booking: filtered[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking});

  final BookingDataEntity booking;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final total = booking.services.fold<double>(0, (s, e) => s + e.serTotal);
    final serviceLines = LookUpUtil.formatServicesBullets(booking.services);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        ModalHelper.showDetailBookingDataModal(context: context, data: booking);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header bệnh nhân
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 20,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.ptnName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tt.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        booking.ptnPhone?.isNotEmpty == true
                            ? booking.ptnPhone!
                            : 'Chưa có số điện thoại',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),
                StatusBadge(status: booking.status),
              ],
            ),

            const SizedBox(height: 12),

            // Ngày + mã + tiền
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Ngày tạo',
                    value: DateTimeUtil.formatDateFull(booking.createdAt),
                  ),
                  if (booking.regId != null && booking.regId!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _InfoRow(
                      icon: Icons.receipt_long_outlined,
                      label: 'Mã đăng ký',
                      value: booking.regId!,
                      valueColor: cs.primary,
                    ),
                  ],
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.payments_outlined,
                    label: 'Tổng tiền',
                    value: CurrencyUtil.formatPrice(total),
                    valueColor: cs.primary,
                    boldValue: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Dịch vụ dạng đầu dòng
            Text(
              'Dịch vụ đăng ký',
              style: tt.labelLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),

            if (serviceLines.isEmpty)
              Text(
                'Chưa có dịch vụ',
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              )
            else
              ...serviceLines
                  .take(4)
                  .map(
                    (line) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        line,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ),

            if (serviceLines.length > 4)
              Text(
                '+${serviceLines.length - 4} nhóm dịch vụ khác',
                style: tt.bodySmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.boldValue = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool boldValue;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: 15, color: cs.onSurfaceVariant),
        const SizedBox(width: 7),
        Text(
          '$label:',
          style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tt.bodySmall?.copyWith(
              color: valueColor ?? cs.onSurface,
              fontWeight: boldValue ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
