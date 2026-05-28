import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/common/widgets/states/error_data_widget.dart';
import 'package:ltc/common/widgets/states/loading_widget.dart';
import 'package:ltc/core/theme/app_colors.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/health/domain/entities/heart_beat_entity.dart';
import 'package:ltc/features/health/domain/extensions/health_metric_ext.dart';
import 'package:ltc/features/health/presentation/providers/health_provider.dart';
import 'package:ltc/features/health/presentation/providers/heart_beat_provider.dart';
import 'package:ltc/features/health/presentation/utils/health_metric_standards.dart';
import 'package:ltc/features/health/presentation/widgets/health_metric_detail_components.dart';

class HeartBeatMetricScreen extends ConsumerWidget {
  const HeartBeatMetricScreen({super.key});

  static const _accent = AppColors.healthHeartRate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(heartBeatProvider);

    return HealthMetricPageScaffold(
      title: 'Nhịp tim',
      icon: Icons.favorite_outline,
      accentColor: _accent,
      onAdd: () => _showAddSheet(context, ref),
      onRefresh: () => ref.read(heartBeatProvider.notifier).refreshData(),
      child: state.when(
        data: (items) => _HeartBeatContent(items: items),
        loading: () => const LoadingWidget(),
        error: (error, _) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            ErrorDataWidget(
              onRetry: () => ref.read(heartBeatProvider.notifier).refreshData(),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeartBeatContent extends ConsumerWidget {
  const _HeartBeatContent({required this.items});

  final List<HeartBeatEntity> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = items.isEmpty ? null : items.first;
    final status = latest == null
        ? 'Chưa có dữ liệu'
        : latest.bpm.heartRateSignal == HealthSignalLevel.good
        ? 'Nhịp tim ổn định'
        : 'Cần theo dõi nhịp tim';

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        100,
      ),
      children: [
        HealthMetricHeroCard(
          icon: Icons.favorite,
          title: status,
          value: latest == null
              ? '--'
              : '${latest.bpm} ${HealthMetricUnits.heartRate}',
          subtitle:
              latest?.context ?? 'Chuẩn: ${HealthMetricRanges.normalHeartRate}',
          accentColor: HeartBeatMetricScreen._accent,
        ),
        const SizedBox(height: AppSpacing.md),
        HealthInfoTile(
          icon: Icons.speed_outlined,
          label: 'Khoảng nghỉ ngơi tham chiếu',
          value: HealthMetricRanges.normalHeartRate,
          color: HeartBeatMetricScreen._accent,
        ),
        const SizedBox(height: AppSpacing.md),
        HealthHistoryCard(
          title: 'Lịch sử nhịp tim',
          icon: Icons.history_rounded,
          color: HeartBeatMetricScreen._accent,
          children: items
              .map(
                (item) => HealthHistoryItem(
                  icon: Icons.favorite_outline,
                  color: HeartBeatMetricScreen._accent,
                  title: '${item.bpm} ${HealthMetricUnits.heartRate}',
                  subtitle: item.context ?? 'Lần đo nhịp tim',
                  date: item.recordDate,
                  onDelete: () async {
                    final notifier = ref.read(heartBeatProvider.notifier);
                    await notifier.updateMetric(
                      userId: item.userId,
                      from: notifier.from,
                      to: notifier.to,
                      metricId: item.metricId,
                      isDeleted: true,
                    );
                    if (!context.mounted) return;
                    ref.invalidate(healthOverviewProvider);
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

Future<void> _showAddSheet(BuildContext context, WidgetRef ref) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _HeartBeatAddSheet(),
  );
}

class _HeartBeatAddSheet extends ConsumerStatefulWidget {
  const _HeartBeatAddSheet();

  @override
  ConsumerState<_HeartBeatAddSheet> createState() => _HeartBeatAddSheetState();
}

class _HeartBeatAddSheetState extends ConsumerState<_HeartBeatAddSheet> {
  final _formKey = GlobalKey<FormState>();
  final _bpm = TextEditingController();
  final _context = TextEditingController();
  final _note = TextEditingController();
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _bpm.dispose();
    _context.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: MetricSheetContainer(
        title: 'Thêm nhịp tim',
        saving: _saving,
        onSave: _save,
        children: [
          MetricDateTimeTile(
            label: 'Thời điểm đo',
            value: _date,
            onChanged: (value) => setState(() => _date = value),
          ),
          metricNumberField(_bpm, 'Nhịp tim', HealthMetricUnits.heartRate),
          metricTextField(_context, 'Bối cảnh'),
          metricTextField(_note, 'Ghi chú'),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await ref
        .read(heartBeatProvider.notifier)
        .insert(
          recordDate: _date,
          bpm: double.parse(_bpm.text).round(),
          context: nullableText(_context),
          note: nullableText(_note),
        );
    if (!mounted) return;
    ref.invalidate(healthOverviewProvider);
    Navigator.of(context).pop();
  }
}
