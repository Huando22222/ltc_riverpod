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
    required double systolic,
    required double diastolic,
    String? context,
    String? note,
  });
  Future<Either<Failure, List<BloodPressureEntity>>> updateBloodPressure({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? recordDate,
    double? systolic,
    double? diastolic,
    String? context,
    String? note,
    required String metricId,
    bool? isDeleted,
  });
}
