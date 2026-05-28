import 'package:ltc/features/health/domain/entities/base_metric_entity.dart';

class WaterEntity extends BaseMetricEntity {
  final int ml; //ml

  WaterEntity({
    required super.metricId,
    required super.userId,
    required super.recordDate,
    required this.ml,
  });
}
