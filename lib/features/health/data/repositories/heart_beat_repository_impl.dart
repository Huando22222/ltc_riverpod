import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/data/datasources/heart_beat_datasource.dart';
import 'package:ltc/features/health/domain/entities/heart_beat_entity.dart';
import 'package:ltc/features/health/domain/repositories/heart_beat_repository.dart';

class HeartBeatRepositoryImpl implements HeartBeatRepository {
  final HeartBeatDatasource _datasource;

  HeartBeatRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<HeartBeatEntity>>> getHeartBeat({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await _datasource.getHeartBeat(
        userId: userId,
        from: from,
        to: to,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi lấy data heart beat'));
    } on DioException catch (e, stackTrace) {
      log('HeartBeatRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log(
        'HeartBeatRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace',
      );
      return Left(
        Failure('ERROR UNEXPECTED: heart beat ${e.toString()} $stackTrace'),
      );
    }
  }

  @override
  Future<Either<Failure, List<HeartBeatEntity>>> insertHeartBeat({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required int bpm,
    String? context,
    String? note,
  }) async {
    try {
      final response = await _datasource.insertHeartBeat(
        userId: userId,
        from: from,
        to: to,
        recordDate: recordDate,
        bpm: bpm,
        context: context,
        note: note,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi insert data heart beat'));
    } on DioException catch (e, stackTrace) {
      log('HeartBeatRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log(
        'HeartBeatRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace',
      );
      return Left(
        Failure('ERROR UNEXPECTED: heart beat ${e.toString()} $stackTrace'),
      );
    }
  }

  @override
  Future<Either<Failure, List<HeartBeatEntity>>> updateHeartBeat({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? recordDate,
    double? bpm,
    String? context,
    String? note,
    required String metricId,
    bool? isDeleted,
  }) async {
    try {
      final response = await _datasource.updateHeartBeat(
        userId: userId,
        from: from,
        to: to,
        recordDate: recordDate,
        bpm: bpm,
        context: context,
        note: note,
        metricId: metricId,
        isDeleted: isDeleted,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi update data heart beat'));
    } on DioException catch (e, stackTrace) {
      log('HeartBeatRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log(
        'HeartBeatRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace',
      );
      return Left(
        Failure('ERROR UNEXPECTED: heart beat ${e.toString()} $stackTrace'),
      );
    }
  }
}

final heartBeatRepositoryProvider = Provider<HeartBeatRepository>(
  (ref) => HeartBeatRepositoryImpl(ref.read(heartBeatDatasourceProvider)),
);
