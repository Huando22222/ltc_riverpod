import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/service/data/repositories/service_repository_impl.dart';
import 'package:ltc/features/service/domain/entities/service_entity.dart';
import 'package:ltc/features/service/domain/repositories/service_repository.dart';

class SearchServiceUsecase {
  final ServiceRepository _repository;

  SearchServiceUsecase(this._repository);

  Future<Either<Failure, List<ServiceEntity>>> call(String? search) {
    return _repository.searchService(search: search);
  }
}

final searchServiceUsecaseProvider = Provider<SearchServiceUsecase>(
  (ref) => SearchServiceUsecase(ref.read(serviceRepositoryProvider)),
);
