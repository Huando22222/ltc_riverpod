import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/service/data/datasources/service_remote_datasource.dart';
import 'package:ltc/features/service/domain/entities/package_entity.dart';
import 'package:ltc/features/service/domain/entities/package_item_entity.dart';
import 'package:ltc/features/service/domain/entities/service_entity.dart';
import 'package:ltc/features/service/domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDatasource _datasource;
  const ServiceRepositoryImpl(this._datasource);
  @override
  Future<Either<Failure, List<ServiceEntity>>> searchService({
    String? search,
  }) async {
    try {
      final response = await _datasource.search(search: search);
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi get service'));
    } catch (e, stackTrace) {
      log("ServiceRepositoryImpl ERROR: $e = $stackTrace");
      return Left(Failure('ERROR UNEXPECTED: ${e.toString()} $stackTrace'));
    }
  }

  @override
  Future<Either<Failure, List<PackageEntity>>> getPackages() async {
    try {
      final response = await _datasource.getPackages();
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi get service'));
    } catch (e, stackTrace) {
      log("ServiceRepositoryImpl ERROR: $e = $stackTrace");
      return Left(Failure('ERROR UNEXPECTED: ${e.toString()} $stackTrace'));
    }
  }

  @override
  Future<Either<Failure, List<PackageItemEntity>>> getPackageDetail({
    required String packageId,
  }) async {
    try {
      final response = await _datasource.getPackageDetail(packageId: packageId);
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi get service'));
    } catch (e, stackTrace) {
      log("ServiceRepositoryImpl ERROR: $e = $stackTrace");
      return Left(Failure('ERROR UNEXPECTED: ${e.toString()} $stackTrace'));
    }
  }
}

final serviceRepositoryProvider = Provider<ServiceRepository>(
  (ref) => ServiceRepositoryImpl(ref.read(serviceRemoteDatasourceProvider)),
);
