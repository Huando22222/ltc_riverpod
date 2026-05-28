import 'package:flutter/material.dart';
import 'package:ltc/core/theme/app_colors.dart';
import 'package:ltc/features/health/domain/entities/overview_entity.dart';
import 'package:ltc/features/health/domain/extensions/health_metric_ext.dart';
import 'package:ltc/features/health/presentation/utils/health_formatters.dart';
import 'package:ltc/features/health/presentation/utils/health_metric_standards.dart';
import 'package:ltc/features/health/presentation/utils/health_metric_type.dart';
import 'package:ltc/features/health/presentation/utils/health_overview_ui_models.dart';

class HealthOverviewMapper {
  HealthOverviewMapper._();

  static List<HealthMetricInfo> metrics(OverviewEntity? overview) {
    final bmi = overview?.bmi?.bmiValue;
    final sleepMinutes = overview?.sleep?.sleepDurationMinutes;
    final heartBeatNeedsAttention =
        overview?.heartBeat?.bpm.heartRateSignal == HealthSignalLevel.warning;
    final spo2NeedsAttention =
        overview?.bloodOxygen?.spo2.spo2Signal == HealthSignalLevel.warning;
    final bloodPressureNeedsAttention =
        overview?.bloodPressure?.bloodPressureSignal ==
        HealthSignalLevel.warning;
    final bmiNeedsAttention = bmi?.bmiSignal == HealthSignalLevel.warning;
    final sleepNeedsAttention =
        overview?.sleep?.sleepSignal == HealthSignalLevel.warning;

    return [
      HealthMetricInfo(
        type: HealthMetricType.heartBeat,
        title: 'Nhịp tim',
        value: overview?.heartBeat == null
            ? '--'
            : '${overview!.heartBeat!.bpm}',
        unit: HealthMetricUnits.heartRate,
        subtitle: heartBeatNeedsAttention
            ? 'Tham chiếu: ${HealthMetricRanges.normalHeartRate}'
            : overview?.heartBeat?.context ?? 'Lần đo gần nhất',
        icon: Icons.favorite_outline,
        color: AppColors.healthHeartRate,
        displayDate: overview?.heartBeat?.recordDate,
        isAttention: heartBeatNeedsAttention,
      ),
      HealthMetricInfo(
        type: HealthMetricType.bloodOxygen,
        title: 'SpO₂',
        value: overview?.bloodOxygen == null
            ? '--'
            : HealthFormatters.number(overview!.bloodOxygen!.spo2),
        unit: HealthMetricUnits.bloodOxygen,
        subtitle: spo2NeedsAttention
            ? 'Tham chiếu: ${HealthMetricRanges.normalBloodOxygen}'
            : overview?.bloodOxygen?.context ?? 'Độ bão hòa oxy',
        icon: Icons.air_outlined,
        color: AppColors.healthBloodOxygen,
        displayDate: overview?.bloodOxygen?.recordDate,
        isAttention: spo2NeedsAttention,
      ),
      HealthMetricInfo(
        type: HealthMetricType.bloodPressure,
        title: 'Huyết áp',
        value: overview?.bloodPressure == null
            ? '--'
            : '${overview!.bloodPressure!.systolic}/${overview.bloodPressure!.diastolic}',
        unit: HealthMetricUnits.bloodPressure,
        subtitle: bloodPressureNeedsAttention
            ? 'Tham chiếu: ${HealthMetricRanges.normalBloodPressure}'
            : overview?.bloodPressure?.context ?? 'Tâm thu/tâm trương',
        icon: Icons.monitor_heart_outlined,
        color: AppColors.healthBloodPressure,
        displayDate: overview?.bloodPressure?.recordDate,
        isAttention: bloodPressureNeedsAttention,
      ),
      HealthMetricInfo(
        type: HealthMetricType.bmi,
        title: 'BMI',
        value: bmi == null ? '--' : HealthFormatters.number(bmi),
        unit: '',
        subtitle: bmiNeedsAttention
            ? 'Tham chiếu: ${HealthMetricRanges.normalBmi}'
            : bmi == null
            ? 'Cân nặng/chiều cao'
            : _bmiLabel(bmi),
        icon: Icons.accessibility_new_outlined,
        color: AppColors.healthBmi,
        displayDate: overview?.bmi?.recordDate,
        isAttention: bmiNeedsAttention,
      ),
      HealthMetricInfo(
        type: HealthMetricType.sleep,
        title: 'Giấc ngủ',
        value: sleepMinutes == null
            ? '--'
            : HealthFormatters.sleepHours(sleepMinutes),
        unit: HealthMetricUnits.sleep,
        subtitle: overview?.sleep == null
            ? 'Thời lượng ngủ'
            : sleepNeedsAttention
            ? 'Tham chiếu: ${HealthMetricRanges.normalSleep}'
            : '${HealthFormatters.time(overview!.sleep!.startSleepDateTime)} - ${HealthFormatters.time(overview.sleep!.wakeUpDateTime)}',
        icon: Icons.bedtime_outlined,
        color: AppColors.healthSleep,
        displayDate: overview?.sleep?.wakeUpDateTime,
        isAttention: sleepNeedsAttention,
      ),
      HealthMetricInfo(
        type: HealthMetricType.water,
        title: 'Uống nước',
        value: overview?.water == null
            ? '--'
            : HealthFormatters.number(overview!.water!.ml),
        unit: HealthMetricUnits.water,
        subtitle: 'Tổng lượng đã ghi nhận',
        icon: Icons.water_drop_outlined,
        color: AppColors.healthWater,
        displayDate: overview?.water?.recordDate,
      ),
    ];
  }

  static List<HealthDetailInfo> details(OverviewEntity? overview) {
    final bmi = overview?.bmi;
    final sleep = overview?.sleep;

    return [
      HealthDetailInfo(
        label: 'Cân nặng',
        value: bmi == null
            ? 'Chưa có dữ liệu'
            : '${HealthFormatters.number(bmi.weight)} ${HealthMetricUnits.weight}',
        icon: Icons.scale_outlined,
      ),
      HealthDetailInfo(
        label: 'Chiều cao',
        value: bmi == null
            ? 'Chưa có dữ liệu'
            : '${HealthFormatters.number(bmi.height)} ${HealthMetricUnits.height}',
        icon: Icons.height_outlined,
      ),
      HealthDetailInfo(
        label: 'Mỡ cơ thể',
        value: bmi?.bodyFatPercentage == null
            ? 'Chưa có dữ liệu'
            : '${HealthFormatters.number(bmi!.bodyFatPercentage!)}${HealthMetricUnits.bodyFat}',
        icon: Icons.pie_chart_outline,
      ),
      HealthDetailInfo(
        label: 'Bắt đầu ngủ',
        value: sleep == null
            ? 'Chưa có dữ liệu'
            : '${HealthFormatters.time(sleep.startSleepDateTime)} · ${HealthFormatters.date(sleep.startSleepDateTime)}',
        icon: Icons.nightlight_outlined,
      ),
      HealthDetailInfo(
        label: 'Thức dậy',
        value: sleep == null
            ? 'Chưa có dữ liệu'
            : '${HealthFormatters.time(sleep.wakeUpDateTime)} · ${HealthFormatters.date(sleep.wakeUpDateTime)}',
        icon: Icons.wb_sunny_outlined,
      ),
      HealthDetailInfo(
        label: 'Thời lượng ngủ',
        value: sleep == null
            ? 'Chưa có dữ liệu'
            : '${HealthFormatters.sleepHours(sleep.sleepDurationMinutes)} ${HealthMetricUnits.sleep}',
        icon: Icons.schedule_outlined,
      ),
      HealthDetailInfo(
        label: 'Thời gian vào giấc',
        value: sleep == null
            ? 'Chưa có dữ liệu'
            : '${sleep.timeNeedToSleep} ${HealthMetricUnits.minutes}',
        icon: Icons.hourglass_bottom_outlined,
      ),
      HealthDetailInfo(
        label: 'Thời gian tỉnh dậy',
        value: sleep == null
            ? 'Chưa có dữ liệu'
            : '${sleep.timeNeedToWakeUp} ${HealthMetricUnits.minutes}',
        icon: Icons.alarm_on_outlined,
      ),
      HealthDetailInfo(
        label: 'Ghi chú gần nhất',
        value:
            overview?.heartBeat?.note ??
            overview?.bloodOxygen?.note ??
            overview?.bloodPressure?.note ??
            overview?.sleep?.note ??
            'Chưa có ghi chú',
        icon: Icons.notes_outlined,
      ),
    ];
  }

  static List<HealthSignalStatus> signals(OverviewEntity? overview) {
    final bmi = overview?.bmi?.bmiValue;

    return [
      if (bmi != null)
        HealthSignalStatus(
          label: 'BMI',
          isGood: bmi.bmiSignal == HealthSignalLevel.good,
        ),
      if (overview?.heartBeat != null)
        HealthSignalStatus(
          label: 'Nhịp tim',
          isGood:
              overview!.heartBeat!.bpm.heartRateSignal ==
              HealthSignalLevel.good,
        ),
      if (overview?.bloodOxygen != null)
        HealthSignalStatus(
          label: 'SpO₂',
          isGood:
              overview!.bloodOxygen!.spo2.spo2Signal == HealthSignalLevel.good,
        ),
      if (overview?.bloodPressure != null)
        HealthSignalStatus(
          label: 'Huyết áp',
          isGood:
              overview!.bloodPressure!.bloodPressureSignal ==
              HealthSignalLevel.good,
        ),
      if (overview?.sleep != null)
        HealthSignalStatus(
          label: 'Giấc ngủ',
          isGood: overview!.sleep!.sleepSignal == HealthSignalLevel.good,
        ),
    ];
  }

  static List<String> attentionItems(OverviewEntity? overview) {
    return signals(
      overview,
    ).where((signal) => !signal.isGood).map((signal) => signal.label).toList();
  }

  static String? bloodPressureText(OverviewEntity? overview) {
    final bloodPressure = overview?.bloodPressure;
    if (bloodPressure == null) return null;
    return '${bloodPressure.systolic}/${bloodPressure.diastolic}';
  }

  static String _bmiLabel(double value) {
    if (value < 18.5) return 'Thiếu cân';
    if (value < 23) return 'Bình thường';
    if (value < 25) return 'Thừa cân';
    return 'Cần kiểm soát';
  }
}
