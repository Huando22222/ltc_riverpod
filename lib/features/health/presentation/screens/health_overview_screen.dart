import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ltc/common/widgets/header/header_widget.dart';
import 'package:ltc/common/widgets/states/refresh_widget.dart';
import 'package:ltc/core/config/routes.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/localization/locale_provider.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';
import 'package:ltc/features/health/domain/entities/overview_entity.dart';
import 'package:ltc/features/health/presentation/providers/health_provider.dart';
import 'package:ltc/features/health/presentation/utils/health_formatters.dart';
import 'package:ltc/features/health/presentation/utils/health_overview_mapper.dart';
import 'package:ltc/features/health/presentation/utils/health_overview_ui_models.dart';
import 'package:ltc/features/health/presentation/widgets/health_details_panel.dart';
import 'package:ltc/features/health/presentation/widgets/health_metric_card.dart';
import 'package:ltc/features/health/presentation/widgets/health_score_card.dart';
import 'package:ltc/features/health/presentation/widgets/health_section_header.dart';
import 'package:ltc/features/health/presentation/widgets/health_state_content.dart';
import 'package:ltc/features/health/presentation/widgets/health_summary_card.dart';

class HealthScreen extends ConsumerStatefulWidget {
  const HealthScreen({super.key});

  @override
  ConsumerState<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends ConsumerState<HealthScreen> {
  late DateTime _from;
  late DateTime _to;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _from = DateTime(now.year, now.month);
    _to = now;
  }

  Future<void> _refresh() async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      ref.invalidate(healthOverviewProvider);
      return;
    }

    await ref
        .read(healthOverviewProvider.notifier)
        .refreshData(userId: user.userId);
  }

  Future<void> _pickDateRange() async {
    final user = ref.read(currentUserProvider);
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: _from, end: _to),
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      helpText: 'Chọn khoảng theo dõi',
      cancelText: 'Hủy',
      confirmText: 'Áp dụng',
      saveText: 'Áp dụng',
    );

    if (picked == null || user == null) return;

    setState(() {
      _from = picked.start;
      _to = picked.end;
    });

    await ref
        .read(healthOverviewProvider.notifier)
        .changeRange(userId: user.userId, from: picked.start, to: picked.end);
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(stringsProvider);
    final overview = ref.watch(healthOverviewProvider);
    final md = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerLow,
      body: Column(
        children: [
          SizedBox(height: md.padding.top),
          HeaderWidget(title: tr.health),
          Expanded(
            child: RefreshWidget(
              onRefresh: _refresh,
              childIsScrollable: true,
              child: overview.when(
                data: (data) => _HealthOverviewContent(
                  overview: data,
                  from: _from,
                  to: _to,
                  onPickRange: _pickDateRange,
                ),
                loading: () => const HealthLoadingContent(),
                error: (error, _) => HealthStateContent(
                  icon: Icons.warning_amber_rounded,
                  title: 'Không tải được dữ liệu',
                  message: error.toString(),
                  actionLabel: 'Thử lại',
                  onAction: _refresh,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthOverviewContent extends StatelessWidget {
  const _HealthOverviewContent({
    required this.overview,
    required this.from,
    required this.to,
    required this.onPickRange,
  });

  final OverviewEntity? overview;
  final DateTime from;
  final DateTime to;
  final VoidCallback onPickRange;

  @override
  Widget build(BuildContext context) {
    final metrics = HealthOverviewMapper.metrics(overview);
    final details = HealthOverviewMapper.details(overview);
    final signals = HealthOverviewMapper.signals(overview);
    final attentionItems = HealthOverviewMapper.attentionItems(overview);
    final availableCount = metrics.where((e) => e.hasValue).length;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        110,
      ),
      children: [
        HealthSummaryCard(
          rangeText: HealthFormatters.range(from, to),
          availableCount: availableCount,
          totalCount: metrics.length,
          attentionItems: attentionItems,
          onPickRange: onPickRange,
        ),
        const SizedBox(height: AppSpacing.md),
        HealthScoreCard(
          signals: signals,
          bloodPressure: HealthOverviewMapper.bloodPressureText(overview),
        ),
        const SizedBox(height: AppSpacing.lg),
        const HealthSectionHeader(title: 'Chỉ số gần nhất'),
        const SizedBox(height: AppSpacing.sm),
        _HealthMetricsLayout(metrics: metrics),
        const SizedBox(height: AppSpacing.lg),
        const HealthSectionHeader(title: 'Thông tin chi tiết'),
        const SizedBox(height: AppSpacing.sm),
        HealthDetailsPanel(items: details),
      ],
    );
  }
}

class _HealthMetricsLayout extends StatelessWidget {
  const _HealthMetricsLayout({required this.metrics});

  final List<HealthMetricInfo> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount = constraints.maxWidth >= 520 ? 3 : 2;
        final rowCount = (metrics.length / columnCount).ceil();

        return Column(
          children: List.generate(rowCount, (rowIndex) {
            final startIndex = rowIndex * columnCount;

            return Padding(
              padding: EdgeInsets.only(
                bottom: rowIndex == rowCount - 1 ? 0 : AppSpacing.sm,
              ),
              child: Row(
                spacing: AppSpacing.sm,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(columnCount, (columnIndex) {
                  final metricIndex = startIndex + columnIndex;

                  return Expanded(
                    child: metricIndex >= metrics.length
                        ? const SizedBox.shrink()
                        : AspectRatio(
                            aspectRatio: 1.28,
                            child: HealthMetricCard(
                              metric: metrics[metricIndex],
                              onTap: () => context.pushNamed(
                                RouteName.healthMetricDetail,
                                pathParameters: {
                                  'metricType':
                                      metrics[metricIndex].type.routeValue,
                                },
                              ),
                            ),
                          ),
                  );
                }),
              ),
            );
          }),
        );
      },
    );
  }
}
