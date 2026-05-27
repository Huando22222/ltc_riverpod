import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/data/repositories/blood_pressure_repository_impl.dart';
import 'package:ltc/features/health/data/repositories/heart_beat_repository_impl.dart';
import 'package:ltc/features/health/domain/entities/blood_pressure_entity.dart';
import 'package:ltc/features/health/domain/entities/heart_beat_entity.dart';
import 'package:ltc/features/health/domain/repositories/blood_pressure_repository.dart';
import 'package:ltc/features/health/domain/repositories/heart_beat_repository.dart';

class GetHeartBeatUsecase {
  GetHeartBeatUsecase(this.repository);

  final HeartBeatRepository repository;

  Future<Either<Failure, List<HeartBeatEntity>>> call({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    return await repository.getHeartBeat(userId: userId, from: from, to: to);
  }
}

class InsertHeartBeatUsecase {
  InsertHeartBeatUsecase(this.repository);

  final HeartBeatRepository repository;

  Future<Either<Failure, List<HeartBeatEntity>>> call({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required int bpm,
    String? context,
    String? note,
  }) async {
    return await repository.insertHeartBeat(
      userId: userId,
      from: from,
      to: to,
      recordDate: recordDate,
      bpm: bpm,
      context: context,
      note: note,
    );
  }
}

class UpdateHeartBeatUsecase {
  UpdateHeartBeatUsecase(this.repository);

  final HeartBeatRepository repository;

  Future<Either<Failure, List<HeartBeatEntity>>> call({
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
    return await repository.updateHeartBeat(
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
  }
}

final getHeartBeatUsecaseProvider = Provider<GetHeartBeatUsecase>(
  (ref) => GetHeartBeatUsecase(ref.read(heartBeatRepositoryProvider)),
);
final insertHeartBeatUsecaseProvider = Provider<InsertHeartBeatUsecase>(
  (ref) => InsertHeartBeatUsecase(ref.read(heartBeatRepositoryProvider)),
);
final updateHeartBeatUsecaseProvider = Provider<UpdateHeartBeatUsecase>(
  (ref) => UpdateHeartBeatUsecase(ref.read(heartBeatRepositoryProvider)),
);
