import 'package:ltc/features/health/domain/entities/blood_oxygen_entity.dart';
import 'package:ltc/features/health/domain/entities/blood_pressure_entity.dart';
import 'package:ltc/features/health/domain/entities/bmi_entity.dart';
import 'package:ltc/features/health/domain/entities/heart_beat_entity.dart';
import 'package:ltc/features/health/domain/entities/sleep_entity.dart';
import 'package:ltc/features/health/domain/entities/water_entity.dart';

class OverviewEntity {
  final BmiEntity? bmi;
  final HeartBeatEntity? heartBeat;
  final BloodOxygenEntity? bloodOxygen;
  final BloodPressureEntity? bloodPressure;
  final SleepEntity? sleep;
  final WaterEntity? water;

  OverviewEntity({
    this.bmi,
    this.heartBeat,
    this.bloodOxygen,
    this.bloodPressure,
    this.sleep,
    this.water,
    s,
  });
}
