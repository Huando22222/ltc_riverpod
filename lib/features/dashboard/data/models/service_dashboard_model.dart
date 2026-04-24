import '../../domain/entities/service_dashboard_entity.dart';

class ServiceDashboardModel extends ServiceDashboardEntity {
  ServiceDashboardModel({
    required super.id,
    required super.title,
    required super.valueId,
    required super.clinicName,
    required super.dcomId,
    required super.image,
    required super.price,
  });

  factory ServiceDashboardModel.fromJson(Map<String, dynamic> json) {
    return ServiceDashboardModel(
      id: json['id'],
      title: json['title'],
      valueId: json['value_id'],
      clinicName: json['clinic_name'],
      dcomId: json['dcom_id'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
