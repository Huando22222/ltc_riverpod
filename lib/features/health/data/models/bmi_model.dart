import 'package:ltc/features/health/domain/entities/bmi_entity.dart';

class BmiModel extends BmiEntity {
  BmiModel({
    required super.metricId,
    required super.userId,
    required super.recordDate,
    required super.weight,
    required super.height,
    super.waistCircumference,
    super.hipCircumference,
    super.chestCircumference,
    super.bodyFatPercentage,
  });

  factory BmiModel.fromJson({required Map<String, dynamic> json}) {
    return BmiModel(
      metricId: json['metric_id'],
      userId: json['user_id'],
      recordDate: DateTime.parse(json['record_date']),
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      waistCircumference: json['waist_circumference'] != null
          ? (json['waist_circumference'] as num).toDouble()
          : null,
      hipCircumference: json['hip_circumference'] != null
          ? (json['hip_circumference'] as num).toDouble()
          : null,
      bodyFatPercentage: json['body_fat_percentage'] != null
          ? (json['body_fat_percentage'] as num).toDouble()
          : null,
      chestCircumference: json['chest_circumference'] != null
          ? (json['chest_circumference'] as num).toDouble()
          : null,
    );
  }
}
