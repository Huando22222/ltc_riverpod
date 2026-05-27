import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/data/repositories/blood_pressure_repository_impl.dart';
import 'package:ltc/features/health/domain/entities/blood_pressure_entity.dart';
import 'package:ltc/features/health/domain/repositories/blood_pressure_repository.dart';

class GetBloodPressureUsecase {
  GetBloodPressureUsecase(this.repository);

  final BloodPressureRepository repository;

  Future<Either<Failure, List<BloodPressureEntity>>> call({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    return await repository.getBloodPressure(
      userId: userId,
      from: from,
      to: to,
    );
  }
}

class InsertBloodPressureUsecase {
  InsertBloodPressureUsecase(this.repository);

  final BloodPressureRepository repository;

  Future<Either<Failure, List<BloodPressureEntity>>> call({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required double systolic,
    required double diastolic,
    String? context,
    String? note,
  }) async {
    return await repository.insertBloodPressure(
      userId: userId,
      from: from,
      to: to,
      recordDate: recordDate,
      diastolic: diastolic,
      systolic: systolic,
      context: context,
      note: note,
    );
  }
}

class UpdateBloodPressureUsecase {
  UpdateBloodPressureUsecase(this.repository);

  final BloodPressureRepository repository;

  Future<Either<Failure, List<BloodPressureEntity>>> call({
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
  }) async {
    return await repository.updateBloodPressure(
      userId: userId,
      from: from,
      to: to,
      recordDate: recordDate,
      diastolic: diastolic,
      systolic: systolic,
      context: context,
      note: note,
      metricId: metricId,
      isDeleted: isDeleted,
    );
  }
}

final getBloodPressureUsecaseProvider = Provider<GetBloodPressureUsecase>(
  (ref) => GetBloodPressureUsecase(ref.read(bloodPressureRepositoryProvider)),
);
final insertBloodPressureUsecaseProvider = Provider<InsertBloodPressureUsecase>(
  (ref) =>
      InsertBloodPressureUsecase(ref.read(bloodPressureRepositoryProvider)),
);
final updateBloodPressureUsecaseProvider = Provider<UpdateBloodPressureUsecase>(
  (ref) =>
      UpdateBloodPressureUsecase(ref.read(bloodPressureRepositoryProvider)),
);
