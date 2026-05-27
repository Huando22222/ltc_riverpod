import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/data/repositories/water_repository_impl.dart';
import 'package:ltc/features/health/domain/entities/water_entity.dart';
import 'package:ltc/features/health/domain/repositories/water_repository.dart';

class GetWaterUsecase {
  GetWaterUsecase(this.repository);

  final WaterRepository repository;

  Future<Either<Failure, List<WaterEntity>>> call({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    return await repository.getWater(userId: userId, from: from, to: to);
  }
}

class InsertWaterUsecase {
  InsertWaterUsecase(this.repository);

  final WaterRepository repository;

  Future<Either<Failure, List<WaterEntity>>> call({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required int ml,
  }) async {
    return await repository.insertWater(
      userId: userId,
      from: from,
      to: to,
      ml: ml,
      recordDate: recordDate,
    );
  }
}

class UpdateWaterUsecase {
  UpdateWaterUsecase(this.repository);

  final WaterRepository repository;

  Future<Either<Failure, List<WaterEntity>>> call({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? recordDate,
    int? ml,
    required String metricId,
    bool? isDeleted,
  }) async {
    return await repository.updateWater(
      userId: userId,
      from: from,
      to: to,
      ml: ml,
      recordDate: recordDate,
      metricId: metricId,
      isDeleted: isDeleted,
    );
  }
}

final getWaterUsecaseProvider = Provider<GetWaterUsecase>(
  (ref) => GetWaterUsecase(ref.read(waterRepositoryProvider)),
);
final insertWaterUsecaseProvider = Provider<InsertWaterUsecase>(
  (ref) => InsertWaterUsecase(ref.read(waterRepositoryProvider)),
);
final updateWaterUsecaseProvider = Provider<UpdateWaterUsecase>(
  (ref) => UpdateWaterUsecase(ref.read(waterRepositoryProvider)),
);
