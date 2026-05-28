import 'package:ltc/features/health/data/models/blood_oxygen_model.dart';
import 'package:ltc/features/health/data/models/blood_pressure_model.dart';
import 'package:ltc/features/health/data/models/bmi_model.dart';
import 'package:ltc/features/health/data/models/heart_beat_model.dart';
import 'package:ltc/features/health/data/models/sleep_model.dart';
import 'package:ltc/features/health/data/models/water_model.dart';
import 'package:ltc/features/health/domain/entities/overview_entity.dart';

class OverviewModel extends OverviewEntity {
  OverviewModel({
    super.bmi,
    super.heartBeat,
    super.bloodOxygen,
    super.bloodPressure,
    super.sleep,
    super.water,
  });

  factory OverviewModel.fromJson({required Map<String, dynamic> json}) {
    return OverviewModel(
      bmi: json['bmi'] != null ? BmiModel.fromJson(json: json['bmi']) : null,
      heartBeat: json['heart_beat'] != null
          ? HeartBeatModel.fromJson(json: json['heart_beat'])
          : null,
      bloodOxygen: json['blood_oxygen'] != null
          ? BloodOxygenModel.fromJson(json: json['blood_oxygen'])
          : null,
      bloodPressure: json['blood_pressure'] != null
          ? BloodPressureModel.fromJson(json: json['blood_pressure'])
          : null,
      sleep: json['sleep'] != null
          ? SleepModel.fromJson(json: json['sleep'])
          : null,
      water: json['water'] != null
          ? WaterModel.fromJson(json: json['water'])
          : null,
    );
  }
}
