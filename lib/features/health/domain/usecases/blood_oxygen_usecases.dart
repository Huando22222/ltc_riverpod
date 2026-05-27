import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/data/repositories/blood_oxygen_repository_impl.dart';
import 'package:ltc/features/health/domain/entities/blood_oxygen_entity.dart';
import 'package:ltc/features/health/domain/repositories/blood_oxygen_repository.dart';

class GetBloodOxygenUsecase {
  GetBloodOxygenUsecase(this.repository);

  final BloodOxygenRepository repository;

  Future<Either<Failure, List<BloodOxygenEntity>>> call({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    return await repository.getBloodOxygen(userId: userId, from: from, to: to);
  }
}

class InsertBloodOxygenUsecase {
  InsertBloodOxygenUsecase(this.repository);

  final BloodOxygenRepository repository;

  Future<Either<Failure, List<BloodOxygenEntity>>> call({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required double spo2,
    String? context,
    String? note,
  }) async {
    return await repository.insertBloodOxygen(
      userId: userId,
      from: from,
      to: to,
      recordDate: recordDate,
      spo2: spo2,
      context: context,
      note: note,
    );
  }
}

class UpdateBloodOxygenUsecase {
  UpdateBloodOxygenUsecase(this.repository);

  final BloodOxygenRepository repository;

  Future<Either<Failure, List<BloodOxygenEntity>>> call({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? recordDate,
    double? spo2,
    String? context,
    String? note,
    required String metricId,
    bool? isDeleted,
  }) async {
    return await repository.updateBloodOxygen(
      userId: userId,
      from: from,
      to: to,
      recordDate: recordDate,
      spo2: spo2,
      context: context,
      note: note,
      metricId: metricId,
      isDeleted: isDeleted,
    );
  }
}

final getBloodOxygenUsecaseProvider = Provider<GetBloodOxygenUsecase>(
  (ref) => GetBloodOxygenUsecase(ref.read(bloodOxygenRepositoryProvider)),
);
final insertBloodOxygenUsecaseProvider = Provider<InsertBloodOxygenUsecase>(
  (ref) => InsertBloodOxygenUsecase(ref.read(bloodOxygenRepositoryProvider)),
);
final updateBloodOxygenUsecaseProvider = Provider<UpdateBloodOxygenUsecase>(
  (ref) => UpdateBloodOxygenUsecase(ref.read(bloodOxygenRepositoryProvider)),
);
