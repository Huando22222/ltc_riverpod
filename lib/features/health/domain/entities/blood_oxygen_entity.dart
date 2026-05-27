import 'package:ltc/features/health/domain/entities/base_metric_entity.dart';

class BloodOxygenEntity extends BaseMetricEntity {
  final double spo2;
  final String? context;
  final String? note;

  BloodOxygenEntity({
    required super.metricId,
    required super.userId,
    required super.recordDate,
    required this.spo2,
    this.context,
    this.note,
  });
}
