import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/data/repositories/sleep_repository_impl.dart';
import 'package:ltc/features/health/domain/entities/sleep_entity.dart';
import 'package:ltc/features/health/domain/repositories/sleep_repository.dart';

class GetSleepUsecase {
  GetSleepUsecase(this.repository);

  final SleepRepository repository;

  Future<Either<Failure, List<SleepEntity>>> call({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    return await repository.getSleep(userId: userId, from: from, to: to);
  }
}

class InsertSleepUsecase {
  InsertSleepUsecase(this.repository);

  final SleepRepository repository;

  Future<Either<Failure, List<SleepEntity>>> call({
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
    return await repository.insertSleep(
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
  }
}

class UpdateSleepUsecase {
  UpdateSleepUsecase(this.repository);

  final SleepRepository repository;

  Future<Either<Failure, List<SleepEntity>>> call({
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
    return await repository.updateSleep(
      userId: userId,
      from: from,
      startSleepDateTime: startSleepDateTime,
      wakeUpDateTime: wakeUpDateTime,
      timeNeedToWakeUp: timeNeedToWakeUp,
      timeNeedToSleep: timeNeedToSleep,
      to: to,
      sleepRating: sleepRating,
      metricId: metricId,
      isDeleted: isDeleted,
    );
  }
}

final getSleepUsecaseProvider = Provider<GetSleepUsecase>(
  (ref) => GetSleepUsecase(ref.read(sleepRepositoryProvider)),
);
final insertSleepUsecaseProvider = Provider<InsertSleepUsecase>(
  (ref) => InsertSleepUsecase(ref.read(sleepRepositoryProvider)),
);
final updateSleepUsecaseProvider = Provider<UpdateSleepUsecase>(
  (ref) => UpdateSleepUsecase(ref.read(sleepRepositoryProvider)),
);
