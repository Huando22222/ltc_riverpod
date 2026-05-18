import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/service/data/repositories/service_repository_impl.dart';
import 'package:ltc/features/service/domain/entities/package_item_entity.dart';
import 'package:ltc/features/service/domain/repositories/service_repository.dart';

class GetPackageDetailUsecase {
  final ServiceRepository _repository;

  GetPackageDetailUsecase(this._repository);

  Future<Either<Failure, List<PackageItemEntity>>> call({
    required String packageId,
  }) {
    return _repository.getPackageDetail(packageId: packageId);
  }
}

final getPackageDetailUsecaseProvider = Provider<GetPackageDetailUsecase>(
  (ref) => GetPackageDetailUsecase(ref.read(serviceRepositoryProvider)),
);
