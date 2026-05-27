import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/data/repositories/blood_pressure_repository_impl.dart';
import 'package:ltc/features/health/data/repositories/bmi_repository_impl.dart';
import 'package:ltc/features/health/domain/entities/blood_pressure_entity.dart';
import 'package:ltc/features/health/domain/entities/bmi_entity.dart';
import 'package:ltc/features/health/domain/repositories/blood_pressure_repository.dart';
import 'package:ltc/features/health/domain/repositories/bmi_repository.dart';

class GetBmiUsecase {
  GetBmiUsecase(this.repository);

  final BmiRepository repository;

  Future<Either<Failure, List<BmiEntity>>> call({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    return await repository.getBmi(userId: userId, from: from, to: to);
  }
}

class InsertBmiUsecase {
  InsertBmiUsecase(this.repository);

  final BmiRepository repository;

  Future<Either<Failure, List<BmiEntity>>> call({
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
  }) async {
    return await repository.insertBmi(
      userId: userId,
      from: from,
      to: to,
      recordDate: recordDate,
      height: height,
      weight: weight,
      waistCircumference: waistCircumference,
      hipCircumference: hipCircumference,
      chestCircumference: chestCircumference,
      bodyFatPercentage: bodyFatPercentage,
      note: note,
    );
  }
}

class UpdateBmiUsecase {
  UpdateBmiUsecase(this.repository);

  final BmiRepository repository;

  Future<Either<Failure, List<BmiEntity>>> call({
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
  }) async {
    return await repository.updateBmi(
      userId: userId,
      from: from,
      to: to,
      recordDate: recordDate,
      height: height,
      weight: weight,
      waistCircumference: waistCircumference,
      hipCircumference: hipCircumference,
      chestCircumference: chestCircumference,
      bodyFatPercentage: bodyFatPercentage,
      note: note,
      metricId: metricId,
      isDeleted: isDeleted,
    );
  }
}

final getBmiUsecaseProvider = Provider<GetBmiUsecase>(
  (ref) => GetBmiUsecase(ref.read(bmiRepositoryProvider)),
);
final insertBmiUsecaseProvider = Provider<InsertBmiUsecase>(
  (ref) => InsertBmiUsecase(ref.read(bmiRepositoryProvider)),
);
final updateBmiUsecaseProvider = Provider<UpdateBmiUsecase>(
  (ref) => UpdateBmiUsecase(ref.read(bmiRepositoryProvider)),
);
