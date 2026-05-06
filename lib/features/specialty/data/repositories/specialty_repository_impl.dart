import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/specialty/data/datasources/service_remote_datasource.dart';
import 'package:ltc/features/specialty/domain/entities/specialty_entity.dart';
import 'package:ltc/features/specialty/domain/repositories/specialty_repository.dart';

final specialtyRepositoryProvider = Provider<SpecialtyRepository>(
  (ref) => SpecialtyRepositoryImpl(ref.read(specialtyRemoteDatasourceProvider)),
);

class SpecialtyRepositoryImpl implements SpecialtyRepository {
  final SpecialtyRemoteDatasource _datasource;
  const SpecialtyRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<SpecialtyEntity>>> getClinicSpecialty({
    String? dcomId,
  }) async {
    try {
      final response = await _datasource.getClinicSpecialty();
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
