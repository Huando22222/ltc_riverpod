import 'package:ltc/features/health/domain/entities/water_entity.dart';

class WaterModel extends WaterEntity {
  WaterModel({
    required super.metricId,
    required super.userId,
    required super.recordDate,
    required super.ml,
  });
  factory WaterModel.fromJson({required Map<String, dynamic> json}) {
    return WaterModel(
      metricId: json['metric_id'],
      userId: json['user_id'],
      recordDate: DateTime.parse(json['record_date']),
      ml: (json['ml'] as num).toInt(),
    );
  }
}
