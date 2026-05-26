import 'package:ltc/features/health/domain/entities/base_metric_entity.dart';

class HeartBeatEntity extends BaseMetricEntity {
  final int bpm;
  final String? context;
  final String? note;

  HeartBeatEntity({
    required super.metricId,
    required super.userId,
    required super.recordDate,
    required this.bpm,
    this.context,
    this.note,
  });
}
