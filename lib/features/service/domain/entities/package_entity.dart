import 'package:ltc/features/service/domain/entities/package_item_entity.dart';

class PackageEntity {
  final String dcomId;
  final String? description;
  final double? discountAmount;
  final double? discountPercent;
  final String? image;
  final String packageId;
  final String packageName;
  List<PackageItemEntity> services;
  PackageEntity({
    required this.dcomId,
    this.description,
    this.discountAmount,
    this.discountPercent,
    this.image,
    required this.packageId,
    required this.packageName,
    this.services = const [],
  });
}
