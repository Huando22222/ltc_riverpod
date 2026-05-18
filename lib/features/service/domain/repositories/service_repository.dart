import 'package:dartz/dartz.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/service/domain/entities/package_entity.dart';
import 'package:ltc/features/service/domain/entities/package_item_entity.dart';
import 'package:ltc/features/service/domain/entities/service_entity.dart';

abstract class ServiceRepository {
  Future<Either<Failure, List<ServiceEntity>>> searchService({String? search});
  Future<Either<Failure, List<PackageEntity>>> getPackages();
  Future<Either<Failure, List<PackageItemEntity>>> getPackageDetail({
    required String packageId,
  });
}
