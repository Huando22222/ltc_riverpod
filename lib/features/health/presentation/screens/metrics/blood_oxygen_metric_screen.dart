import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/common/widgets/states/error_data_widget.dart';
import 'package:ltc/common/widgets/states/loading_widget.dart';
import 'package:ltc/core/theme/app_colors.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/health/domain/entities/blood_oxygen_entity.dart';
import 'package:ltc/features/health/presentation/providers/blood_oxygen_provider.dart';
import 'package:ltc/features/health/presentation/providers/health_provider.dart';
import 'package:ltc/features/health/presentation/utils/health_formatters.dart';
import 'package:ltc/features/health/presentation/utils/health_metric_standards.dart';
import 'package:ltc/features/health/presentation/widgets/health_metric_detail_components.dart';

class BloodOxygenMetricScreen extends ConsumerWidget {
  const BloodOxygenMetricScreen({super.key});

  static const _accent = AppColors.healthBloodOxygen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bloodOxygenProvider);

    return HealthMetricPageScaffold(
      title: 'SpO₂',
      icon: Icons.air_outlined,
      accentColor: _accent,
      onAdd: () => _showAddSheet(context, ref),
      onRefresh: () => ref.read(bloodOxygenProvider.notifier).refreshData(),
      child: state.when(
        data: (items) => _BloodOxygenContent(items: items),
        loading: () => const LoadingWidget(),
        error: (error, _) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            ErrorDataWidget(
              onRetry: () =>
                  ref.read(bloodOxygenProvider.notifier).refreshData(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BloodOxygenContent extends ConsumerWidget {
  const _BloodOxygenContent({required this.items});

  final List<BloodOxygenEntity> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = items.isEmpty ? null : items.first;
    final value = latest?.spo2;
    final status = value == null
        ? 'Chưa có dữ liệu'
        : value >= 95
        ? 'Oxy máu ổn định'
        : 'Cần theo dõi thêm';

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
          icon: Icons.air_outlined,
          title: status,
          value: value == null
              ? '--'
              : '${HealthFormatters.number(value)}${HealthMetricUnits.bloodOxygen}',
          subtitle:
              latest?.context ??
              'Tham chiếu: ${HealthMetricRanges.normalBloodOxygen}',
          accentColor: BloodOxygenMetricScreen._accent,
        ),
        const SizedBox(height: AppSpacing.md),
        HealthInfoTile(
          icon: Icons.health_and_safety_outlined,
          label: 'Khoảng tham chiếu',
          value: HealthMetricRanges.normalBloodOxygen,
          color: BloodOxygenMetricScreen._accent,
        ),
        const SizedBox(height: AppSpacing.md),
        HealthHistoryCard(
          title: 'Lịch sử SpO₂',
          icon: Icons.history_rounded,
          color: BloodOxygenMetricScreen._accent,
          children: items
              .map(
                (item) => HealthHistoryItem(
                  icon: Icons.air_outlined,
                  color: BloodOxygenMetricScreen._accent,
                  title:
                      '${HealthFormatters.number(item.spo2)}${HealthMetricUnits.bloodOxygen}',
                  subtitle: item.context ?? 'Độ bão hòa oxy',
                  date: item.recordDate,
                  onDelete: () async {
                    final notifier = ref.read(bloodOxygenProvider.notifier);
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
    builder: (_) => const _BloodOxygenAddSheet(),
  );
}

class _BloodOxygenAddSheet extends ConsumerStatefulWidget {
  const _BloodOxygenAddSheet();

  @override
  ConsumerState<_BloodOxygenAddSheet> createState() =>
      _BloodOxygenAddSheetState();
}

class _BloodOxygenAddSheetState extends ConsumerState<_BloodOxygenAddSheet> {
  final _formKey = GlobalKey<FormState>();
  final _spo2 = TextEditingController();
  final _context = TextEditingController();
  final _note = TextEditingController();
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _spo2.dispose();
    _context.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: MetricSheetContainer(
        title: 'Thêm SpO₂',
        saving: _saving,
        onSave: _save,
        children: [
          MetricDateTimeTile(
            label: 'Thời điểm đo',
            value: _date,
            onChanged: (value) => setState(() => _date = value),
          ),
          metricNumberField(_spo2, 'SpO₂', HealthMetricUnits.bloodOxygen),
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
        .read(bloodOxygenProvider.notifier)
        .insert(
          recordDate: _date,
          spo2: metricPercentInput(_spo2),
          context: nullableText(_context),
          note: nullableText(_note),
        );
    if (!mounted) return;
    ref.invalidate(healthOverviewProvider);
    Navigator.of(context).pop();
  }
}
