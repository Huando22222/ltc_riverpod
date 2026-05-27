import 'package:ltc/features/health/domain/entities/blood_oxygen_entity.dart';

class BloodOxygenModel extends BloodOxygenEntity {
  BloodOxygenModel({
    required super.metricId,
    required super.userId,
    required super.recordDate,
    required super.spo2,
    super.context,
    super.note,
  });

  factory BloodOxygenModel.fromJson({required Map<String, dynamic> json}) {
    return BloodOxygenModel(
      metricId: json['metric_id'],
      userId: json['user_id'],
      recordDate: json['record_date'],
      spo2: json['spo2'],
      context: json['context'],
      note: json['note'],
    );
  }
}
