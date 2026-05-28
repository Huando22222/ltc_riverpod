import 'package:ltc/features/health/domain/entities/sleep_entity.dart';

class SleepModel extends SleepEntity {
  SleepModel({
    required super.metricId,
    required super.userId,
    required super.recordDate,
    required super.startSleepDateTime,
    required super.wakeUpDateTime,
    required super.timeNeedToSleep,
    required super.timeNeedToWakeUp,
    required super.note,
    super.sleepRating,
  });

  factory SleepModel.fromJson({required Map<String, dynamic> json}) {
    return SleepModel(
      metricId: json['metric_id'],
      userId: json['user_id'],
      recordDate: DateTime.parse(json['record_date']),
      startSleepDateTime: DateTime.parse(json['start_sleep_date_time']),
      wakeUpDateTime: DateTime.parse(json['wake_up_date_time']),
      timeNeedToSleep: json['time_need_to_sleep'],
      timeNeedToWakeUp: json['time_need_to_wake_up'],
      note: json['note'],
      sleepRating: json['sleep_rating'],
    );
  }
}
