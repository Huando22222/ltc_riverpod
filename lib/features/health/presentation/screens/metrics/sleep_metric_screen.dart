import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/common/widgets/states/error_data_widget.dart';
import 'package:ltc/common/widgets/states/loading_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_colors.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/health/domain/entities/sleep_entity.dart';
import 'package:ltc/features/health/domain/extensions/health_metric_ext.dart';
import 'package:ltc/features/health/presentation/providers/health_provider.dart';
import 'package:ltc/features/health/presentation/providers/sleep_provider.dart';
import 'package:ltc/features/health/presentation/utils/health_formatters.dart';
import 'package:ltc/features/health/presentation/utils/health_metric_standards.dart';
import 'package:ltc/features/health/presentation/widgets/health_metric_detail_components.dart';

class SleepMetricScreen extends ConsumerWidget {
  const SleepMetricScreen({super.key});

  static const _accent = AppColors.healthSleep;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sleepProvider);

    return HealthMetricPageScaffold(
      title: 'Giấc ngủ',
      icon: Icons.bedtime_outlined,
      accentColor: _accent,
      onAdd: () => _showAddSheet(context, ref),
      onRefresh: () => ref.read(sleepProvider.notifier).refreshData(),
      child: state.when(
        data: (items) => _SleepContent(items: items),
        loading: () => const LoadingWidget(),
        error: (error, _) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            ErrorDataWidget(
              onRetry: () => ref.read(sleepProvider.notifier).refreshData(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SleepContent extends ConsumerWidget {
  const _SleepContent({required this.items});

  final List<SleepEntity> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = items.isEmpty ? null : items.first;
    final minutes = latest?.sleepDurationMinutes;

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
          icon: Icons.nightlight_round,
          title: 'Thời lượng ngủ',
          value: minutes == null
              ? '--'
              : '${HealthFormatters.sleepHours(minutes)} ${HealthMetricUnits.sleep}',
          subtitle: latest == null
              ? 'Chưa có giấc ngủ nào'
              : '${HealthFormatters.time(latest.startSleepDateTime)} - ${HealthFormatters.time(latest.wakeUpDateTime)}',
          accentColor: SleepMetricScreen._accent,
        ),
        const SizedBox(height: AppSpacing.md),
        if (latest != null)
          Row(
            children: [
              Expanded(
                child: HealthInfoTile(
                  icon: Icons.hourglass_bottom_outlined,
                  label: 'Vào giấc',
                  value: '${latest.timeNeedToSleep} phút',
                  color: AppColors.healthSleep,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: HealthInfoTile(
                  icon: Icons.alarm_on_outlined,
                  label: 'Tỉnh dậy',
                  value: '${latest.timeNeedToWakeUp} phút',
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
        const SizedBox(height: AppSpacing.md),
        _SleepTimeline(item: latest),
        const SizedBox(height: AppSpacing.md),
        HealthHistoryCard(
          title: 'Lịch sử giấc ngủ',
          icon: Icons.history_rounded,
          color: SleepMetricScreen._accent,
          children: items
              .map(
                (item) => HealthHistoryItem(
                  icon: Icons.bedtime_outlined,
                  color: SleepMetricScreen._accent,
                  title:
                      '${HealthFormatters.sleepHours(item.sleepDurationMinutes)} giờ',
                  subtitle:
                      '${HealthFormatters.time(item.startSleepDateTime)} - ${HealthFormatters.time(item.wakeUpDateTime)}',
                  date: item.wakeUpDateTime,
                  onDelete: () async {
                    final notifier = ref.read(sleepProvider.notifier);
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

class _SleepTimeline extends StatelessWidget {
  const _SleepTimeline({required this.item});

  final SleepEntity? item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: context.softShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: _TimelinePoint(
              icon: Icons.bedtime,
              label: 'Bắt đầu',
              value: item == null
                  ? '--'
                  : HealthFormatters.time(item!.startSleepDateTime),
            ),
          ),
          Expanded(
            child: Container(height: 2, color: SleepMetricScreen._accent),
          ),
          Expanded(
            child: _TimelinePoint(
              icon: Icons.wb_sunny_outlined,
              label: 'Thức dậy',
              value: item == null
                  ? '--'
                  : HealthFormatters.time(item!.wakeUpDateTime),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelinePoint extends StatelessWidget {
  const _TimelinePoint({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: SleepMetricScreen._accent),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: context.textTheme.labelSmall),
        Text(value, style: context.textTheme.titleSmall),
      ],
    );
  }
}

Future<void> _showAddSheet(BuildContext context, WidgetRef ref) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _SleepAddSheet(),
  );
}

class _SleepAddSheet extends ConsumerStatefulWidget {
  const _SleepAddSheet();

  @override
  ConsumerState<_SleepAddSheet> createState() => _SleepAddSheetState();
}

class _SleepAddSheetState extends ConsumerState<_SleepAddSheet> {
  final _formKey = GlobalKey<FormState>();
  final _timeToSleep = TextEditingController();
  final _timeToWake = TextEditingController();
  final _rating = TextEditingController();
  final _note = TextEditingController();
  DateTime _start = DateTime.now().subtract(const Duration(hours: 8));
  DateTime _wake = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _timeToSleep.dispose();
    _timeToWake.dispose();
    _rating.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: MetricSheetContainer(
        title: 'Thêm giấc ngủ',
        saving: _saving,
        onSave: _save,
        children: [
          MetricDateTimeTile(
            label: 'Bắt đầu ngủ',
            value: _start,
            onChanged: (value) => setState(() => _start = value),
          ),
          MetricDateTimeTile(
            label: 'Thức dậy',
            value: _wake,
            onChanged: (value) => setState(() => _wake = value),
          ),
          metricNumberField(_timeToSleep, 'Thời gian vào giấc', 'phút'),
          metricNumberField(_timeToWake, 'Thời gian tỉnh dậy', 'phút'),
          metricNumberField(
            _rating,
            'Đánh giá giấc ngủ',
            '1-10',
            required: false,
          ),
          metricTextField(_note, 'Ghi chú'),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await ref
        .read(sleepProvider.notifier)
        .insert(
          startSleepDateTime: _start,
          wakeUpDateTime: _wake,
          timeNeedToSleep: double.parse(_timeToSleep.text).round(),
          timeNeedToWakeUp: double.parse(_timeToWake.text).round(),
          sleepRating: nullableDouble(_rating)?.round(),
          note: nullableText(_note),
        );
    if (!mounted) return;
    ref.invalidate(healthOverviewProvider);
    Navigator.of(context).pop();
  }
}
