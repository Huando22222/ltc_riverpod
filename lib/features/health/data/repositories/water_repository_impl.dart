import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/data/datasources/water_datasource.dart';
import 'package:ltc/features/health/domain/entities/water_entity.dart';
import 'package:ltc/features/health/domain/repositories/water_repository.dart';

class WaterRepositoryImpl implements WaterRepository {
  final WaterDatasource _datasource;

  WaterRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<WaterEntity>>> getWater({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await _datasource.getWater(
        userId: userId,
        from: from,
        to: to,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi lấy data water'));
    } on DioException catch (e, stackTrace) {
      log('WaterRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log('WaterRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace');
      return Left(
        Failure('ERROR UNEXPECTED: water ${e.toString()} $stackTrace'),
      );
    }
  }

  @override
  Future<Either<Failure, List<WaterEntity>>> insertWater({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required int ml,
  }) async {
    try {
      final response = await _datasource.insertWater(
        userId: userId,
        from: from,
        to: to,
        ml: ml,
        recordDate: recordDate,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi insert data water'));
    } on DioException catch (e, stackTrace) {
      log('WaterRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log('WaterRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace');
      return Left(
        Failure('ERROR UNEXPECTED: water ${e.toString()} $stackTrace'),
      );
    }
  }

  @override
  Future<Either<Failure, List<WaterEntity>>> updateWater({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? recordDate,
    int? ml,
    required String metricId,
    bool? isDeleted,
  }) async {
    try {
      final response = await _datasource.updateWater(
        userId: userId,
        from: from,
        to: to,
        ml: ml,
        recordDate: recordDate,
        metricId: metricId,
        isDeleted: isDeleted,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi update data water'));
    } on DioException catch (e, stackTrace) {
      log('WaterRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log('WaterRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace');
      return Left(
        Failure('ERROR UNEXPECTED: water ${e.toString()} $stackTrace'),
      );
    }
  }
}

final waterRepositoryProvider = Provider<WaterRepository>(
  (ref) => WaterRepositoryImpl(ref.read(waterDatasourceProvider)),
);
