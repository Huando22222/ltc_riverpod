import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/doctor/data/repositories/doctor_repository_impl.dart';
import 'package:ltc/features/doctor/domain/entities/doctor_entity.dart';
import 'package:ltc/features/doctor/domain/repositories/doctor_repository.dart';

class SearchDoctorUsecase {
  final DoctorRepository _repository;

  SearchDoctorUsecase(this._repository);

  Future<Either<Failure, List<DoctorEntity>>> call({
    String? dcomId,
    String? specId,
  }) {
    return _repository.search(dcomId: dcomId, specId: specId);
  }
}

final searchDoctorUsecaseProvider = Provider<SearchDoctorUsecase>(
  (ref) => SearchDoctorUsecase(ref.read(doctorRepositoryProvider)),
);
