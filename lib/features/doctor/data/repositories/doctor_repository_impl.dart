import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/doctor/data/datasources/doctor_remote_datasource.dart';
import 'package:ltc/features/doctor/domain/entities/doctor_entity.dart';
import 'package:ltc/features/doctor/domain/repositories/doctor_repository.dart';

final doctorRepositoryProvider = Provider<DoctorRepository>(
  (ref) => DoctorRepositoryImpl(ref.read(doctorRemoteDatasourceProvider)),
);

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDatasource _datasource;
  const DoctorRepositoryImpl(this._datasource);
  @override
  Future<Either<Failure, DoctorEntity>> search({String? search}) async {
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
