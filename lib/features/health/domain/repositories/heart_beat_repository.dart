import 'package:dartz/dartz.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/domain/entities/heart_beat_entity.dart';

abstract class HeartBeatRepository {
  Future<Either<Failure, List<HeartBeatEntity>>> getHeartBeat({
    required String userId,
    required DateTime from,
    required DateTime to,
  });

  Future<Either<Failure, List<HeartBeatEntity>>> insertHeartBeat({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required int bpm,
    String? context,
    String? note,
  });

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
  });
}
