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
      recordDate: json['record_date'],
      weight: json['weight'],
      height: json['height'],
      waistCircumference: json['waist_circumference'],
      hipCircumference: json['hip_circumference'],
      bodyFatPercentage: json['body_fat_percentage'],
      chestCircumference: json['chest_circumference'],
    );
  }
}
