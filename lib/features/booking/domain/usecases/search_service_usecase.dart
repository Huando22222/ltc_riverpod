import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/booking/data/repositories/service_repository_impl.dart';
import 'package:ltc/features/booking/domain/entities/service_entity.dart';
import 'package:ltc/features/booking/domain/repositories/service_repository.dart';

class SearchParams {
  final String search;

  SearchParams({required this.search});
}

class SearchServiceUsecase {
  final ServiceRepository _repository;

  SearchServiceUsecase(this._repository);

  Future<Either<Failure, ServiceEntity>> call(SearchParams params) {
    return _repository.search(search: params.search);
  }
}

final loginUsecaseProvider = Provider<SearchServiceUsecase>(
  (ref) => SearchServiceUsecase(ref.read(serviceRepositoryProvider)),
);
