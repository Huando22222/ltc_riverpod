import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/common/widgets/states/error_data_widget.dart';
import 'package:ltc/common/widgets/states/loading_widget.dart';
import 'package:ltc/core/theme/app_colors.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/health/domain/entities/blood_pressure_entity.dart';
import 'package:ltc/features/health/domain/extensions/health_metric_ext.dart';
import 'package:ltc/features/health/presentation/providers/blood_pressure_provider.dart';
import 'package:ltc/features/health/presentation/providers/health_provider.dart';
import 'package:ltc/features/health/presentation/utils/health_metric_standards.dart';
import 'package:ltc/features/health/presentation/widgets/health_metric_detail_components.dart';

class BloodPressureMetricScreen extends ConsumerWidget {
  const BloodPressureMetricScreen({super.key});

  static const _accent = AppColors.healthBloodPressure;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bloodPressureProvider);

    return HealthMetricPageScaffold(
      title: 'Huyết áp',
      icon: Icons.monitor_heart_outlined,
      accentColor: _accent,
      onAdd: () => _showAddSheet(context, ref),
      onRefresh: () => ref.read(bloodPressureProvider.notifier).refreshData(),
      child: state.when(
        data: (items) => _BloodPressureContent(items: items),
        loading: () => const LoadingWidget(),
        error: (error, _) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            ErrorDataWidget(
              onRetry: () =>
                  ref.read(bloodPressureProvider.notifier).refreshData(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BloodPressureContent extends ConsumerWidget {
  const _BloodPressureContent({required this.items});

  final List<BloodPressureEntity> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = items.isEmpty ? null : items.first;
    final status = latest == null
        ? 'Chưa có dữ liệu'
        : latest.bloodPressureSignal == HealthSignalLevel.good
        ? 'Huyết áp trong ngưỡng'
        : 'Cần theo dõi huyết áp';

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
          icon: Icons.monitor_heart_outlined,
          title: status,
          value: latest == null
              ? '--'
              : '${latest.systolic}/${latest.diastolic} ${HealthMetricUnits.bloodPressure}',
          subtitle:
              latest?.context ??
              'Chuẩn: ${HealthMetricRanges.normalBloodPressure}',
          accentColor: BloodPressureMetricScreen._accent,
        ),
        const SizedBox(height: AppSpacing.md),
        HealthHistoryCard(
          title: 'Lịch sử huyết áp',
          icon: Icons.history_rounded,
          color: BloodPressureMetricScreen._accent,
          children: items
              .map(
                (item) => HealthHistoryItem(
                  icon: Icons.monitor_heart_outlined,
                  color: BloodPressureMetricScreen._accent,
                  title:
                      '${item.systolic}/${item.diastolic} ${HealthMetricUnits.bloodPressure}',
                  subtitle: item.context ?? 'Tâm thu/tâm trương',
                  date: item.recordDate,
                  onDelete: () async {
                    await ref
                        .read(bloodPressureProvider.notifier)
                        .updateMetric(
                          userId: item.userId,
                          from: ref.read(bloodPressureProvider.notifier).from,
                          to: ref.read(bloodPressureProvider.notifier).to,
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
    builder: (_) => const _BloodPressureAddSheet(),
  );
}

class _BloodPressureAddSheet extends ConsumerStatefulWidget {
  const _BloodPressureAddSheet();

  @override
  ConsumerState<_BloodPressureAddSheet> createState() =>
      _BloodPressureAddSheetState();
}

class _BloodPressureAddSheetState
    extends ConsumerState<_BloodPressureAddSheet> {
  final _formKey = GlobalKey<FormState>();
  final _systolic = TextEditingController();
  final _diastolic = TextEditingController();
  final _context = TextEditingController();
  final _note = TextEditingController();
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _systolic.dispose();
    _diastolic.dispose();
    _context.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: MetricSheetContainer(
        title: 'Thêm huyết áp',
        saving: _saving,
        onSave: _save,
        children: [
          MetricDateTimeTile(
            label: 'Thời điểm đo',
            value: _date,
            onChanged: (value) => setState(() => _date = value),
          ),
          metricNumberField(
            _systolic,
            'Tâm thu',
            HealthMetricUnits.bloodPressure,
          ),
          metricNumberField(
            _diastolic,
            'Tâm trương',
            HealthMetricUnits.bloodPressure,
          ),
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
        .read(bloodPressureProvider.notifier)
        .insert(
          recordDate: _date,
          systolic: int.parse(_systolic.text),
          diastolic: int.parse(_diastolic.text),
          context: nullableText(_context),
          note: nullableText(_note),
        );
    if (!mounted) return;
    ref.invalidate(healthOverviewProvider);
    Navigator.of(context).pop();
  }
}
