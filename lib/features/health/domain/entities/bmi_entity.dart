import 'package:ltc/features/health/domain/entities/base_metric_entity.dart';

class BmiEntity extends BaseMetricEntity {
  final double weight; //kg
  final double height; //cm
  final double? waistCircumference; //cm
  final double? hipCircumference; //cm
  final double? chestCircumference; //cm
  final double? bodyFatPercentage; //%

  BmiEntity({
    required super.metricId,
    required super.userId,
    required super.recordDate,
    required this.weight,
    required this.height,
    this.waistCircumference,
    this.hipCircumference,
    this.chestCircumference,
    this.bodyFatPercentage,
  });
}
