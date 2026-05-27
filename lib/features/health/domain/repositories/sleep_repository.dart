import 'package:dartz/dartz.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/domain/entities/sleep_entity.dart';

abstract class SleepRepository {
  Future<Either<Failure, List<SleepEntity>>> getSleep({
    required String userId,
    required DateTime from,
    required DateTime to,
  });

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
  });

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
  });
}
