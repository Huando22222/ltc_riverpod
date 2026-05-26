import 'package:ltc/features/health/domain/entities/base_metric_entity.dart';

class SleepEntity extends BaseMetricEntity {
  final DateTime startSleepDateTime;
  final DateTime wakeUpDateTime;
  final int timeNeedToSleep;
  final int timeNeedToWakeUp;
  final int? sleepRating;
  final String? note;

  SleepEntity({
    required super.metricId,
    required super.userId,
    required super.recordDate,
    required this.startSleepDateTime,
    required this.wakeUpDateTime,
    required this.timeNeedToSleep,
    required this.timeNeedToWakeUp,
    this.sleepRating,
    required this.note,
  });
}
