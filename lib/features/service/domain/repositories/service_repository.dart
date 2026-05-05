import 'package:dartz/dartz.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/service/domain/entities/package_entity.dart';
import 'package:ltc/features/service/domain/entities/package_item_entity.dart';
import 'package:ltc/features/service/domain/entities/service_entity.dart';
import 'package:ltc/features/service/domain/entities/specialty_entity.dart';

abstract class ServiceRepository {
  Future<Either<Failure, ServiceEntity>> searchService({String? search});
  Future<Either<Failure, PackageEntity>> getPackages();
  Future<Either<Failure, PackageItemEntity>> getPackageDetail({
    String packageId,
  });
  Future<Either<Failure, SpecialtyEntity>> getSpecialty({String? dcomId});
}
