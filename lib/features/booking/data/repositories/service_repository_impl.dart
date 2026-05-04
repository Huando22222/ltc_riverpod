import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/booking/data/datasources/service_remote_datasource.dart';
import 'package:ltc/features/booking/domain/entities/service_entity.dart';
import 'package:ltc/features/booking/domain/repositories/service_repository.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>(
  (ref) => ServiceRepositoryImpl(ref.read(serviceRemoteDatasourceProvider)),
);

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDatasource _datasource;
  const ServiceRepositoryImpl(this._datasource);
  @override
  Future<Either<Failure, ServiceEntity>> search({String? search}) async {
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
}
