import 'package:ltc/features/health/domain/entities/base_metric_entity.dart';

class BloodPressureEntity extends BaseMetricEntity {
  final int systolic;
  final int diastolic;
  final String? context;
  final String? note;

  BloodPressureEntity({
    required super.metricId,
    required super.userId,
    required super.recordDate,
    required this.systolic,
    required this.diastolic,
    required this.context,
    required this.note,
  });
}
