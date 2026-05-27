import 'package:dartz/dartz.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/domain/entities/water_entity.dart';

abstract class WaterRepository {
  Future<Either<Failure, List<WaterEntity>>> getWater({
    required String userId,
    required DateTime from,
    required DateTime to,
  });

  Future<Either<Failure, List<WaterEntity>>> insertWater({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required int ml,
  });

  Future<Either<Failure, List<WaterEntity>>> updateWater({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? recordDate,
    int? ml,
    required String metricId,
    bool? isDeleted,
  });
}
