import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/data/datasources/blood_pressure_datasource.dart';
import 'package:ltc/features/health/domain/entities/blood_pressure_entity.dart';
import 'package:ltc/features/health/domain/repositories/blood_pressure_repository.dart';

class BloodPressureRepositoryImpl implements BloodPressureRepository {
  final BloodPressureDatasource _datasource;

  BloodPressureRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<BloodPressureEntity>>> getBloodPressure({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await _datasource.getBloodPressure(
        userId: userId,
        from: from,
        to: to,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi lấy data blood pressure'));
    } on DioException catch (e, stackTrace) {
      log('BloodPressureRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log(
        'BloodPressureRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace',
      );
      return Left(
        Failure('ERROR UNEXPECTED: blood pressure ${e.toString()} $stackTrace'),
      );
    }
  }

  @override
  Future<Either<Failure, List<BloodPressureEntity>>> insertBloodPressure({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required double systolic,
    required double diastolic,
    String? context,
    String? note,
  }) async {
    try {
      final response = await _datasource.insertBloodPressure(
        userId: userId,
        from: from,
        to: to,
        recordDate: recordDate,
        systolic: systolic,
        diastolic: diastolic,
        context: context,
        note: note,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(
        Failure(response.message ?? 'Lỗi insert data blood pressure'),
      );
    } on DioException catch (e, stackTrace) {
      log('BloodPressureRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log(
        'BloodPressureRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace',
      );
      return Left(
        Failure('ERROR UNEXPECTED: blood pressure ${e.toString()} $stackTrace'),
      );
    }
  }

  @override
  Future<Either<Failure, List<BloodPressureEntity>>> updateBloodPressure({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? recordDate,
    double? systolic,
    double? diastolic,
    String? context,
    String? note,
    required String metricId,
    bool? isDeleted,
  }) async {
    try {
      final response = await _datasource.updateBloodPressure(
        userId: userId,
        from: from,
        to: to,
        recordDate: recordDate,
        systolic: systolic,
        diastolic: diastolic,
        note: note,
        context: context,
        metricId: metricId,
        isDeleted: isDeleted,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(
        Failure(response.message ?? 'Lỗi update data blood pressure'),
      );
    } on DioException catch (e, stackTrace) {
      log('BloodPressureRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log(
        'BloodPressureRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace',
      );
      return Left(
        Failure('ERROR UNEXPECTED: blood pressure ${e.toString()} $stackTrace'),
      );
    }
  }
}

final bloodPressureRepositoryProvider = Provider<BloodPressureRepository>(
  (ref) =>
      BloodPressureRepositoryImpl(ref.read(bloodPressureDatasourceProvider)),
);
