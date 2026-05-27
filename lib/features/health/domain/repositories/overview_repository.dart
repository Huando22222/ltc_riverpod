import 'package:dartz/dartz.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/domain/entities/overview_entity.dart';

abstract class OverviewRepository {
  Future<Either<Failure, OverviewEntity>> getOverview({
    required String userId,
    required DateTime from,
    required DateTime to,
  });
}
