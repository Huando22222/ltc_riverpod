import 'package:ltc/features/dashboard/domain/entities/content_dashboard_entity.dart';
import 'package:ltc/features/dashboard/domain/entities/service_dashboard_entity.dart';

class DashboardEntity {
  final List<ContentDashboardEntity> slider;
  final List<ServiceDashboardEntity> package;
  final List<ServiceDashboardEntity> test;
  final List<ContentDashboardEntity> medicalTopic;

  DashboardEntity({
    required this.slider,
    required this.package,
    required this.test,
    required this.medicalTopic,
  });
  factory DashboardEntity.empty() {
    return DashboardEntity(slider: [], package: [], test: [], medicalTopic: []);
  }
}
