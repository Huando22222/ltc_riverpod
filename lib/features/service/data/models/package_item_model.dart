import 'package:ltc/features/service/domain/entities/package_item_entity.dart';

class PackageItemModel extends PackageItemEntity {
  PackageItemModel({
    required super.dcomId,
    required super.packageId,
    required super.serGroupId,
    required super.serId,
    required super.serName,
    required super.serPrice,
    required super.serTotal,
  });

  factory PackageItemModel.fromJson({required Map<String, dynamic> json}) {
    return PackageItemModel(
      dcomId: json['dcom_id'],
      packageId: json['pkg_id'],
      serGroupId: json['ser_grp_id'],
      serId: json['ser_id'],
      serName: json['ser_name'],
      serPrice: json['ser_price'],
      serTotal: json['ser_total'],
    );
  }
}
