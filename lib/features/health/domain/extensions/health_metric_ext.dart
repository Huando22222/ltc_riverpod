import 'dart:math' as math;

import 'package:ltc/features/health/domain/entities/blood_pressure_entity.dart';
import 'package:ltc/features/health/domain/entities/bmi_entity.dart';
import 'package:ltc/features/health/domain/entities/sleep_entity.dart';

enum HealthSignalLevel { good, warning }

extension BmiEntityExt on BmiEntity {
  double? get bmiValue {
    if (height <= 0) return null;
    final heightInMeters = height / 100;
    return weight / math.pow(heightInMeters, 2);
  }

  double? get waistHipRatio {
    final waist = waistCircumference;
    final hip = hipCircumference;
    if (waist == null || hip == null || hip <= 0) return null;
    return waist / hip;
  }
}

extension BmiValueExt on double {
  HealthSignalLevel get bmiSignal {
    return this >= 18.5 && this < 23
        ? HealthSignalLevel.good
        : HealthSignalLevel.warning;
  }
}

extension HeartRateValueExt on int {
  HealthSignalLevel get heartRateSignal {
    return this >= 60 && this <= 100
        ? HealthSignalLevel.good
        : HealthSignalLevel.warning;
  }
}

extension Spo2ValueExt on double {
  HealthSignalLevel get spo2Signal {
    return this >= 95 ? HealthSignalLevel.good : HealthSignalLevel.warning;
  }
}

extension BloodPressureEntityExt on BloodPressureEntity {
  HealthSignalLevel get bloodPressureSignal {
    final systolicIsNormal = systolic >= 90 && systolic <= 120;
    final diastolicIsNormal = diastolic >= 60 && diastolic <= 80;
    return systolicIsNormal && diastolicIsNormal
        ? HealthSignalLevel.good
        : HealthSignalLevel.warning;
  }
}

extension SleepEntityExt on SleepEntity {
  int get sleepDurationMinutes {
    return wakeUpDateTime.difference(startSleepDateTime).inMinutes;
  }

  HealthSignalLevel get sleepSignal {
    final duration = sleepDurationMinutes;
    return duration >= 420 && duration <= 540
        ? HealthSignalLevel.good
        : HealthSignalLevel.warning;
  }
}
