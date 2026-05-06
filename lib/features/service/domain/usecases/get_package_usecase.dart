import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/service/data/repositories/service_repository_impl.dart';
import 'package:ltc/features/service/domain/entities/package_entity.dart';
import 'package:ltc/features/service/domain/repositories/service_repository.dart';

class GetPackagesUsecase {
  final ServiceRepository _repository;

  GetPackagesUsecase(this._repository);

  Future<Either<Failure, List<PackageEntity>>> call() {
    return _repository.getPackages();
  }
}

final getPackagesUsecaseProvider = Provider<GetPackagesUsecase>(
  (ref) => GetPackagesUsecase(ref.read(serviceRepositoryProvider)),
);
