import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/specialty/data/repositories/specialty_repository_impl.dart';
import 'package:ltc/features/specialty/domain/entities/specialty_entity.dart';
import 'package:ltc/features/specialty/domain/repositories/specialty_repository.dart';

class GetClinicSpecialtyUsecase {
  final SpecialtyRepository _repository;

  GetClinicSpecialtyUsecase(this._repository);

  Future<Either<Failure, List<SpecialtyEntity>>> call(String? dcomId) {
    return _repository.getClinicSpecialty(dcomId: dcomId);
  }
}

final getClinicSpecialtyUsecaseProvider = Provider<GetClinicSpecialtyUsecase>(
  (ref) => GetClinicSpecialtyUsecase(ref.read(specialtyRepositoryProvider)),
);
