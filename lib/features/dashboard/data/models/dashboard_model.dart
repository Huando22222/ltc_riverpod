import '../models/content_dashboard_model.dart';
import '../models/service_dashboard_model.dart';
import '../../domain/entities/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  DashboardModel({
    required super.slider,
    required super.package,
    required super.test,
    required super.medicalTopic,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      slider: (json['slider'] as List)
          .map((item) => ContentDashboardModel.fromJson(item))
          .toList(),
      package: (json['package'] as List)
          .map((item) => ServiceDashboardModel.fromJson(item))
          .toList(),
      test: (json['test'] as List)
          .map((item) => ServiceDashboardModel.fromJson(item))
          .toList(),
      medicalTopic: (json['medicalTopic'] as List)
          .map((item) => ContentDashboardModel.fromJson(item))
          .toList(),
    );
  }
}
