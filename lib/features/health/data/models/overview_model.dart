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
      bmi: BmiModel.fromJson(json: json['bmi']),
      heartBeat: HeartBeatModel.fromJson(json: json['heart_beat']),
      bloodOxygen: BloodOxygenModel.fromJson(json: json['blood_oxygen']),
      bloodPressure: BloodPressureModel.fromJson(json: json['blood_pressure']),
      sleep: SleepModel.fromJson(json: json['sleep']),
      water: WaterModel.fromJson(json: json['water']),
    );
  }
}
