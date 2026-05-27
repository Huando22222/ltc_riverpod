import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/data/datasources/overview_datasource.dart';
import 'package:ltc/features/health/domain/entities/overview_entity.dart';
import 'package:ltc/features/health/domain/repositories/overview_repository.dart';

class OverviewRepositoryImpl implements OverviewRepository {
  final OverviewDatasource _datasource;
  OverviewRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, OverviewEntity>> getOverview({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await _datasource.getOverview(
        userId: userId,
        from: from,
        to: to,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi overview'));
    } on DioException catch (e, stackTrace) {
      log('SleepRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log(
        'OverviewRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace',
      );
      return Left(
        Failure('ERROR UNEXPECTED: overview ${e.toString()} $stackTrace'),
      );
    }
  }
}

final overviewRepositoryProvider = Provider<OverviewRepository>(
  (ref) => OverviewRepositoryImpl(ref.read(overviewDatasourceProvider)),
);
