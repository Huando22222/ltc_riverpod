import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/features/health/domain/entities/blood_oxygen_entity.dart';
import 'package:ltc/features/health/domain/entities/heart_beat_entity.dart';
import 'package:ltc/features/health/domain/entities/overview_entity.dart';
import 'package:ltc/features/health/presentation/states/heath_state.dart';

class HealthNotifier extends Notifier<HeathState> {
  @override
  HeathState build() {
    return HeathState(overview: OverviewEntity());
  }

  void setOverview(OverviewEntity overview) {
    state = HeathState(
      overview: overview,
      bloodOxygen: state.bloodOxygen,
      bloodPressure: state.bloodPressure,
      bmi: state.bmi,
      heartBeat: state.heartBeat,
      sleep: state.sleep,
      water: state.water,
    );
  }

  void setHeartBeat(List<HeartBeatEntity> data) {
    state = HeathState(
      overview: state.overview,
      bloodOxygen: state.bloodOxygen,
      bloodPressure: state.bloodPressure,
      bmi: state.bmi,
      heartBeat: data,
      sleep: state.sleep,
      water: state.water,
    );
  }

  void setBloodOxygen(List<BloodOxygenEntity> data) {
    state = HeathState(
      overview: state.overview,
      bloodOxygen: data,
      bloodPressure: state.bloodPressure,
      bmi: state.bmi,
      heartBeat: state.heartBeat,
      sleep: state.sleep,
      water: state.water,
    );
  }
}
