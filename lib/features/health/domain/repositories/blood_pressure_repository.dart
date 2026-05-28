import 'package:dartz/dartz.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/domain/entities/blood_pressure_entity.dart';

abstract class BloodPressureRepository {
  Future<Either<Failure, List<BloodPressureEntity>>> getBloodPressure({
    required String userId,
    required DateTime from,
    required DateTime to,
  });

  Future<Either<Failure, List<BloodPressureEntity>>> insertBloodPressure({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required int systolic,
    required int diastolic,
    String? context,
    String? note,
  });
  Future<Either<Failure, List<BloodPressureEntity>>> updateBloodPressure({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? recordDate,
    int? systolic,
    int? diastolic,
    String? context,
    String? note,
    required String metricId,
    bool? isDeleted,
  });
}
