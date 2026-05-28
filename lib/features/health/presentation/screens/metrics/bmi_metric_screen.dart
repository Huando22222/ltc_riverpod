import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/common/widgets/states/error_data_widget.dart';
import 'package:ltc/common/widgets/states/loading_widget.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_colors.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:ltc/features/health/domain/entities/bmi_entity.dart';
import 'package:ltc/features/health/domain/extensions/health_metric_ext.dart';
import 'package:ltc/features/health/presentation/providers/bmi_provider.dart';
import 'package:ltc/features/health/presentation/providers/health_provider.dart';
import 'package:ltc/features/health/presentation/utils/health_formatters.dart';
import 'package:ltc/features/health/presentation/utils/health_metric_standards.dart';
import 'package:ltc/features/health/presentation/widgets/health_metric_detail_components.dart';

class BmiMetricScreen extends ConsumerWidget {
  const BmiMetricScreen({super.key});

  static const _accent = AppColors.healthBmi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bmiProvider);

    return HealthMetricPageScaffold(
      title: 'BMI',
      icon: Icons.accessibility_new_outlined,
      accentColor: _accent,
      onAdd: () => _showAddSheet(context, ref),
      onRefresh: () => ref.read(bmiProvider.notifier).refreshData(),
      child: state.when(
        data: (items) => _BmiContent(items: items),
        loading: () => const LoadingWidget(),
        error: (error, _) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            ErrorDataWidget(
              onRetry: () => ref.read(bmiProvider.notifier).refreshData(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BmiContent extends ConsumerWidget {
  const _BmiContent({required this.items});

  final List<BmiEntity> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = items.isEmpty ? null : items.first;
    final bmi = latest?.bmiValue;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        100,
      ),
      children: [
        _BmiGauge(value: bmi),
        const SizedBox(height: AppSpacing.md),
        if (latest != null)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: HealthInfoTile(
                      icon: Icons.monitor_weight_outlined,
                      label: 'Cân nặng',
                      value:
                          '${HealthFormatters.number(latest.weight)} ${HealthMetricUnits.weight}',
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: HealthInfoTile(
                      icon: Icons.height_outlined,
                      label: 'Chiều cao',
                      value:
                          '${HealthFormatters.number(latest.height)} ${HealthMetricUnits.height}',
                      color: AppColors.healthBloodOxygen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              HealthInfoTile(
                icon: Icons.pie_chart_outline,
                label: 'Mỡ cơ thể',
                value: _optionalPercent(latest.bodyFatPercentage),
                color: AppColors.healthBodyFat,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: HealthInfoTile(
                      icon: Icons.straighten_outlined,
                      label: 'Vòng eo',
                      value: _optionalCm(latest.waistCircumference),
                      color: AppColors.healthBloodPressure,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: HealthInfoTile(
                      icon: Icons.accessibility_new_outlined,
                      label: 'Vòng hông',
                      value: _optionalCm(latest.hipCircumference),
                      color: AppColors.healthSleep,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: HealthInfoTile(
                      icon: Icons.favorite_border_rounded,
                      label: 'Vòng ngực',
                      value: _optionalCm(latest.chestCircumference),
                      color: AppColors.healthHeartRate,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: HealthInfoTile(
                      icon: Icons.analytics_outlined,
                      label: 'Eo/hông',
                      value: latest.waistHipRatio == null
                          ? '--'
                          : HealthFormatters.number(latest.waistHipRatio!),
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
            ],
          ),
        const SizedBox(height: AppSpacing.md),
        HealthHistoryCard(
          title: 'Lịch sử BMI',
          icon: Icons.history_rounded,
          color: BmiMetricScreen._accent,
          children: items
              .map(
                (item) => HealthHistoryItem(
                  icon: Icons.accessibility_new_outlined,
                  color: BmiMetricScreen._accent,
                  title: item.bmiValue == null
                      ? '--'
                      : HealthFormatters.number(item.bmiValue!),
                  subtitle:
                      '${HealthFormatters.number(item.weight)} kg · ${HealthFormatters.number(item.height)} cm',
                  date: item.recordDate,
                  onDelete: () async {
                    final notifier = ref.read(bmiProvider.notifier);
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

String _optionalCm(double? value) {
  if (value == null) return '--';
  return '${HealthFormatters.number(value)} ${HealthMetricUnits.height}';
}

String _optionalPercent(double? value) {
  if (value == null) return '--';
  return '${HealthFormatters.number(value)}${HealthMetricUnits.bodyFat}';
}

class _BmiGauge extends StatelessWidget {
  const _BmiGauge({required this.value});

  final double? value;

  @override
  Widget build(BuildContext context) {
    final normalized = value == null
        ? 0.0
        : ((value! - 10) / 25).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: context.softShadow,
      ),
      child: Column(
        children: [
          SizedBox(
            width: 178,
            height: 178,
            child: CustomPaint(
              painter: _BmiGaugePainter(progress: normalized),
              child: Center(
                child: Text(
                  value == null ? '--' : HealthFormatters.number(value!),
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Tham chiếu: ${HealthMetricRanges.normalBmi}',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _BmiGaugePainter extends CustomPainter {
  const _BmiGaugePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    stroke.color = AppColors.border;
    canvas.drawArc(
      rect.deflate(10),
      math.pi * .75,
      math.pi * 1.5,
      false,
      stroke,
    );

    stroke.shader = const LinearGradient(
      colors: [
        AppColors.primaryGradientEnd,
        AppColors.healthBmi,
        AppColors.warning,
      ],
    ).createShader(rect);
    canvas.drawArc(
      rect.deflate(10),
      math.pi * .75,
      math.pi * 1.5 * progress,
      false,
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _BmiGaugePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

Future<void> _showAddSheet(BuildContext context, WidgetRef ref) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _BmiAddSheet(),
  );
}

class _BmiAddSheet extends ConsumerStatefulWidget {
  const _BmiAddSheet();

  @override
  ConsumerState<_BmiAddSheet> createState() => _BmiAddSheetState();
}

class _BmiAddSheetState extends ConsumerState<_BmiAddSheet> {
  final _formKey = GlobalKey<FormState>();
  final _weight = TextEditingController();
  final _height = TextEditingController();
  final _waist = TextEditingController();
  final _hip = TextEditingController();
  final _chest = TextEditingController();
  final _bodyFat = TextEditingController();
  final _note = TextEditingController();
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _weight.dispose();
    _height.dispose();
    _waist.dispose();
    _hip.dispose();
    _chest.dispose();
    _bodyFat.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: MetricSheetContainer(
        title: 'Thêm BMI',
        saving: _saving,
        onSave: _save,
        children: [
          MetricDateTimeTile(
            label: 'Thời điểm ghi nhận',
            value: _date,
            onChanged: (value) => setState(() => _date = value),
          ),
          metricNumberField(
            _waist,
            'Vòng eo',
            HealthMetricUnits.height,
            required: false,
          ),
          metricNumberField(
            _hip,
            'Vòng hông',
            HealthMetricUnits.height,
            required: false,
          ),
          metricNumberField(
            _chest,
            'Vòng ngực',
            HealthMetricUnits.height,
            required: false,
          ),
          metricNumberField(_weight, 'Cân nặng', HealthMetricUnits.weight),
          metricNumberField(_height, 'Chiều cao', HealthMetricUnits.height),
          metricNumberField(_bodyFat, 'Mỡ cơ thể', '%', required: false),
          metricTextField(_note, 'Ghi chú'),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await ref
        .read(bmiProvider.notifier)
        .insert(
          recordDate: _date,
          weight: metricKgInput(_weight),
          height: metricCmInput(_height),
          waistCircumference: _waist.text.trim().isEmpty
              ? null
              : metricCmInput(_waist),
          hipCircumference: _hip.text.trim().isEmpty
              ? null
              : metricCmInput(_hip),
          chestCircumference: _chest.text.trim().isEmpty
              ? null
              : metricCmInput(_chest),
          bodyFatPercentage: _bodyFat.text.trim().isEmpty
              ? null
              : metricPercentInput(_bodyFat),
          note: nullableText(_note),
        );
    if (!mounted) return;
    ref.invalidate(healthOverviewProvider);
    Navigator.of(context).pop();
  }
}
