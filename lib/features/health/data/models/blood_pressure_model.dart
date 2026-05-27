import 'package:ltc/features/health/domain/entities/blood_pressure_entity.dart';

class BloodPressureModel extends BloodPressureEntity {
  BloodPressureModel({
    required super.metricId,
    required super.userId,
    required super.recordDate,
    required super.systolic,
    required super.diastolic,
    super.context,
    super.note,
  });

  factory BloodPressureModel.fromJson({required Map<String, dynamic> json}) {
    return BloodPressureModel(
      metricId: json['metric_id'],
      userId: json['user_id'],
      recordDate: json['record_date'],
      systolic: json['systolic'],
      diastolic: json['diastolic'],
      context: json['context'],
      note: json['note'],
    );
  }
}
