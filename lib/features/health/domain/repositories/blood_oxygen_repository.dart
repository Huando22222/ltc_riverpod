import 'package:dartz/dartz.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/domain/entities/blood_oxygen_entity.dart';

abstract class BloodOxygenRepository {
  Future<Either<Failure, List<BloodOxygenEntity>>> getBloodOxygen({
    required String userId,
    required DateTime from,
    required DateTime to,
  });

  Future<Either<Failure, List<BloodOxygenEntity>>> insertBloodOxygen({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required double spo2,
    String? context,
    String? note,
  });
  Future<Either<Failure, List<BloodOxygenEntity>>> updateBloodOxygen({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? recordDate,
    double? spo2,
    String? context,
    String? note,
    required String metricId,
    bool? isDeleted,
  });
}
