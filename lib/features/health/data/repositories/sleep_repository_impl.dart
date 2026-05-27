import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/data/datasources/sleep_datasource.dart';
import 'package:ltc/features/health/domain/entities/sleep_entity.dart';
import 'package:ltc/features/health/domain/repositories/sleep_repository.dart';

class SleepRepositoryImpl implements SleepRepository {
  final SleepDatasource _datasource;

  SleepRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<SleepEntity>>> getSleep({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await _datasource.getSleep(
        userId: userId,
        from: from,
        to: to,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi lấy data sleep'));
    } on DioException catch (e, stackTrace) {
      log('SleepRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log('SleepRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace');
      return Left(
        Failure('ERROR UNEXPECTED: sleep ${e.toString()} $stackTrace'),
      );
    }
  }

  @override
  Future<Either<Failure, List<SleepEntity>>> insertSleep({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime startSleepDateTime,
    required DateTime wakeUpDateTime,
    required int timeNeedToSleep,
    required int timeNeedToWakeUp,
    int? sleepRating,
    String? note,
  }) async {
    try {
      final response = await _datasource.insertSleep(
        userId: userId,
        from: from,
        to: to,
        startSleepDateTime: startSleepDateTime,
        wakeUpDateTime: wakeUpDateTime,
        timeNeedToSleep: timeNeedToSleep,
        timeNeedToWakeUp: timeNeedToWakeUp,
        sleepRating: sleepRating,
        note: note,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi insert data sleep'));
    } on DioException catch (e, stackTrace) {
      log('SleepRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log('SleepRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace');
      return Left(
        Failure('ERROR UNEXPECTED: sleep ${e.toString()} $stackTrace'),
      );
    }
  }

  @override
  Future<Either<Failure, List<SleepEntity>>> updateSleep({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? startSleepDateTime,
    DateTime? wakeUpDateTime,
    int? timeNeedToSleep,
    int? timeNeedToWakeUp,
    int? sleepRating,
    required String metricId,
    bool? isDeleted,
  }) async {
    try {
      final response = await _datasource.updateSleep(
        userId: userId,
        from: from,
        to: to,
        startSleepDateTime: startSleepDateTime,
        wakeUpDateTime: wakeUpDateTime,
        timeNeedToSleep: timeNeedToSleep,
        timeNeedToWakeUp: timeNeedToWakeUp,
        sleepRating: sleepRating,
        metricId: metricId,
        isDeleted: isDeleted,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi update data sleep'));
    } on DioException catch (e, stackTrace) {
      log('SleepRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log('SleepRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace');
      return Left(
        Failure('ERROR UNEXPECTED: sleep ${e.toString()} $stackTrace'),
      );
    }
  }
}

final sleepRepositoryProvider = Provider<SleepRepository>(
  (ref) => SleepRepositoryImpl(ref.read(sleepDatasourceProvider)),
);
