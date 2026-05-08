import 'package:ltc/features/service/data/models/package_item_model.dart';
import 'package:ltc/features/service/domain/entities/package_entity.dart';

class PackageModel extends PackageEntity {
  PackageModel({
    // required this.dcomId,
    // this.description,
    // this.discountAmount,
    // this.discountPercent,
    // this.image,
    // required this.packageId,
    // required this.packageName,
    // this.services = const [],
    required super.dcomId,
    required super.packageId,
    required super.packageName,
    super.description,
    super.discountAmount,
    super.discountPercent,
    super.image,
    super.services,
  });

  factory PackageModel.fromJson({
    required Map<String, dynamic> json,
    List<dynamic>? servicesJson,
  }) {
    return PackageModel(
      dcomId: json['dcom_id'],
      packageId: json['pkg_id'],
      packageName: json['pkg_name'],
      description: json['description'],
      image: json['image'],
      discountAmount: (json['discount_amount'] as num).toDouble(),
      discountPercent: (json['discount_percent'] as num).toDouble(),
      services: servicesJson != null
          ? servicesJson.map((e) => PackageItemModel.fromJson(json: e)).toList()
          : [],
    );
  }
}
