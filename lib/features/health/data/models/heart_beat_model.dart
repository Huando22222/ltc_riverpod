import 'package:ltc/features/health/domain/entities/heart_beat_entity.dart';

class HeartBeatModel extends HeartBeatEntity {
  HeartBeatModel({
    required super.metricId,
    required super.userId,
    required super.recordDate,
    required super.bpm,
    super.context,
    super.note,
  });

  factory HeartBeatModel.fromJson({required Map<String, dynamic> json}) {
    return HeartBeatModel(
      metricId: json['metric_id'],
      userId: json['user_id'],
      recordDate: json['record_date'],
      bpm: json['heart_beat'],
      context: json['context'],
      note: json['note'],
    );
  }
}
