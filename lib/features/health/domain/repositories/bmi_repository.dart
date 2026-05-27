import 'package:dartz/dartz.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/domain/entities/bmi_entity.dart';

abstract class BmiRepository {
  Future<Either<Failure, List<BmiEntity>>> getBmi({
    required String userId,
    required DateTime from,
    required DateTime to,
  });

  Future<Either<Failure, List<BmiEntity>>> insertBmi({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required double weight,
    required double height,
    double? waistCircumference,
    double? hipCircumference,
    double? chestCircumference,
    double? bodyFatPercentage,
    String? note,
  });
  Future<Either<Failure, List<BmiEntity>>> updateBmi({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? recordDate,
    double? weight,
    double? height,
    double? waistCircumference,
    double? hipCircumference,
    double? chestCircumference,
    double? bodyFatPercentage,
    String? note,
    required String metricId,
    bool? isDeleted,
  });
}
