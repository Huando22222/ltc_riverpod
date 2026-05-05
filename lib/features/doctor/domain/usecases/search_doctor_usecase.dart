import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/doctor/data/repositories/doctor_repository_impl.dart';
import 'package:ltc/features/doctor/domain/entities/doctor_entity.dart';
import 'package:ltc/features/doctor/domain/repositories/doctor_repository.dart';

class SearchParams {
  final String search;

  SearchParams({required this.search});
}

class SearchDoctorUsecase {
  final DoctorRepository _repository;

  SearchDoctorUsecase(this._repository);

  Future<Either<Failure, DoctorEntity>> call(SearchParams params) {
    return _repository.search(search: params.search);
  }
}

final searchDoctorUsecaseProvider = Provider<SearchDoctorUsecase>(
  (ref) => SearchDoctorUsecase(ref.read(doctorRepositoryProvider)),
);
