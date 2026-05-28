import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/common/widgets/states/error_data_widget.dart';
import 'package:ltc/common/widgets/states/loading_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/extensions/date_time_ext.dart';
import 'package:ltc/core/theme/app_colors.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/health/domain/entities/water_entity.dart';
import 'package:ltc/features/health/presentation/providers/health_provider.dart';
import 'package:ltc/features/health/presentation/providers/water_provider.dart';
import 'package:ltc/features/health/presentation/utils/health_formatters.dart';
import 'package:ltc/features/health/presentation/utils/health_metric_standards.dart';
import 'package:ltc/features/health/presentation/widgets/health_metric_detail_components.dart';

class WaterMetricScreen extends ConsumerWidget {
  const WaterMetricScreen({super.key});

  static const _accent = AppColors.healthWater;
  static const _goal = 2000;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(waterProvider);

    return HealthMetricPageScaffold(
      title: 'Uống nước',
      icon: Icons.water_drop_outlined,
      accentColor: _accent,
      onAdd: () => _showCustomWaterSheet(context, ref),
      onRefresh: () => ref.read(waterProvider.notifier).refreshData(),
      child: state.when(
        data: (items) => _WaterContent(items: items),
        loading: () => const LoadingWidget(),
        error: (error, _) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            ErrorDataWidget(
              onRetry: () => ref.read(waterProvider.notifier).refreshData(),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaterContent extends ConsumerWidget {
  const _WaterContent({required this.items});

  final List<WaterEntity> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final total = items
        .where((e) => e.recordDate.isSameDate(now))
        .toList()
        .fold<int>(0, (sum, item) => sum + item.ml);
    final progress = (total / WaterMetricScreen._goal).clamp(0.0, 1.0);
    final cs = context.colorScheme;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        100,
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryGradientEnd, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            boxShadow: context.softShadow,
          ),
          child: Column(
            children: [
              Icon(Icons.water_drop, size: 54, color: cs.onPrimary),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${HealthFormatters.number(total)} ${HealthMetricUnits.water}',
                style: context.textTheme.headlineMedium?.copyWith(
                  color: cs.onPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Mục tiêu ${WaterMetricScreen._goal} ml mỗi ngày',
                style: context.textTheme.bodySmall?.copyWith(
                  color: cs.onPrimary.withOpacity(.84),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: progress,
                  backgroundColor: cs.onPrimary.withOpacity(.2),
                  valueColor: AlwaysStoppedAnimation<Color>(cs.onPrimary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _QuickWaterSection(onAdd: (ml) => _insertWater(context, ref, ml)),
        const SizedBox(height: AppSpacing.md),
        HealthHistoryCard(
          title: 'Lịch sử uống nước',
          icon: Icons.history_rounded,
          color: WaterMetricScreen._accent,
          children: items
              .map(
                (item) => HealthHistoryItem(
                  icon: Icons.water_drop_outlined,
                  leading: FaIcon(
                    _waterIconForAmount(item.ml),
                    color: WaterMetricScreen._accent,
                    size: 20,
                  ),
                  color: WaterMetricScreen._accent,
                  title:
                      '${HealthFormatters.number(item.ml)} ${HealthMetricUnits.water}',
                  subtitle: HealthFormatters.time(item.recordDate),
                  date: item.recordDate,
                  onDelete: () async {
                    final notifier = ref.read(waterProvider.notifier);
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

class _QuickWaterSection extends StatelessWidget {
  const _QuickWaterSection({required this.onAdd});

  final ValueChanged<int> onAdd;

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
        spacing: 4,
        children: [150, 300, 500].map((ml) {
          return Expanded(
            child: OutlinedButton(
              onPressed: () => onAdd(ml),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      _waterIconForAmount(ml),
                      size: 16,
                      color: WaterMetricScreen._accent,
                    ),
                    const SizedBox(width: 6),
                    Text('+$ml ml', maxLines: 1, softWrap: false),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

IconData _waterIconForAmount(num ml) {
  if (ml <= 150) return FontAwesomeIcons.droplet;
  if (ml <= 300) return FontAwesomeIcons.glassWater;
  return FontAwesomeIcons.bottleWater;
}

Future<void> _insertWater(BuildContext context, WidgetRef ref, int ml) async {
  await ref
      .read(waterProvider.notifier)
      .insert(recordDate: DateTime.now(), ml: ml);
  if (!context.mounted) return;
  ref.invalidate(healthOverviewProvider);
}

Future<void> _showCustomWaterSheet(BuildContext context, WidgetRef ref) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _WaterAddSheet(),
  );
}

class _WaterAddSheet extends ConsumerStatefulWidget {
  const _WaterAddSheet();

  @override
  ConsumerState<_WaterAddSheet> createState() => _WaterAddSheetState();
}

class _WaterAddSheetState extends ConsumerState<_WaterAddSheet> {
  final _formKey = GlobalKey<FormState>();
  final _ml = TextEditingController();
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _ml.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: MetricSheetContainer(
        title: 'Thêm nước uống',
        saving: _saving,
        onSave: _save,
        children: [
          MetricDateTimeTile(
            label: 'Thời điểm uống',
            value: _date,
            onChanged: (value) => setState(() => _date = value),
          ),
          metricNumberField(_ml, 'Lượng nước', HealthMetricUnits.water),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await ref
        .read(waterProvider.notifier)
        .insert(recordDate: _date, ml: double.parse(_ml.text).round());
    if (!mounted) return;
    ref.invalidate(healthOverviewProvider);
    Navigator.of(context).pop();
  }
}
