import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/data/datasources/blood_oxygen_datasource.dart';
import 'package:ltc/features/health/domain/entities/blood_oxygen_entity.dart';
import 'package:ltc/features/health/domain/repositories/blood_oxygen_repository.dart';

class BloodOxygenRepositoryImpl implements BloodOxygenRepository {
  final BloodOxygenDatasource _datasource;

  BloodOxygenRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<BloodOxygenEntity>>> getBloodOxygen({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await _datasource.getBloodOxygen(
        userId: userId,
        from: from,
        to: to,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi lấy data spo2'));
    } on DioException catch (e, stackTrace) {
      log('BloodOxygenRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log(
        'BloodOxygenRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace',
      );
      return Left(
        Failure('ERROR UNEXPECTED: spo2 ${e.toString()} $stackTrace'),
      );
    }
  }

  @override
  Future<Either<Failure, List<BloodOxygenEntity>>> insertBloodOxygen({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required double spo2,
    String? context,
    String? note,
  }) async {
    try {
      final response = await _datasource.insertBloodOxygen(
        userId: userId,
        from: from,
        to: to,
        recordDate: recordDate,
        spo2: spo2,
        context: context,
        note: note,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi insert data spo2'));
    } on DioException catch (e, stackTrace) {
      log('BloodOxygenRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log(
        'BloodOxygenRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace',
      );
      return Left(
        Failure('ERROR UNEXPECTED: spo2 ${e.toString()} $stackTrace'),
      );
    }
  }

  @override
  Future<Either<Failure, List<BloodOxygenEntity>>> updateBloodOxygen({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? recordDate,
    double? spo2,
    String? context,
    String? note,
    required String metricId,
    bool? isDeleted,
  }) async {
    try {
      final response = await _datasource.updateBloodOxygen(
        userId: userId,
        from: from,
        to: to,
        recordDate: recordDate,
        spo2: spo2,
        context: context,
        note: note,
        metricId: metricId,
        isDeleted: isDeleted,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi update data spo2'));
    } on DioException catch (e, stackTrace) {
      log('BloodOxygenRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log(
        'BloodOxygenRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace',
      );
      return Left(
        Failure('ERROR UNEXPECTED: spo2 ${e.toString()} $stackTrace'),
      );
    }
  }
}

final bloodOxygenRepositoryProvider = Provider<BloodOxygenRepository>(
  (ref) => BloodOxygenRepositoryImpl(ref.read(bloodOxygenDatasourceProvider)),
);
