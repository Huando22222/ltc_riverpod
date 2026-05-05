import 'package:ltc/features/service/domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  ServiceModel({
    required super.dcomId,
    required super.serId,
    required super.serName,
    required super.serGroupId,
    required super.serGroupName,
    required super.serPrice,
    required super.serTotal,
    required super.serType,
    required super.isActive,
    required super.isLogicDel,
  });

  factory ServiceModel.fromJson({required Map<String, dynamic> json}) {
    return ServiceModel(
      dcomId: json['dcom_id'],
      serId: json['ser_id'],
      serName: json['ser_name'],
      serGroupId: json['ser_grp_id'],
      serGroupName: json['ser_grp_name'],
      serPrice: json['ser_price'],
      serTotal: json['ser_total'],
      serType: json['grp_type'],
      isActive: json['is_active'],
      isLogicDel: json['is_logic_del'],
    );
  }
}
