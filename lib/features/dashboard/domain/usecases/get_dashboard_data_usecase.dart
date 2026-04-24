import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:ltc/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:ltc/features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../../../core/error/failure.dart';

class GetDashboardDataUsecase {
  const GetDashboardDataUsecase(this._repository);
  final DashboardRepository _repository;

  Future<Either<Failure, DashboardEntity>> call() {
    return _repository.getDashBoardData();
  }
}

final getDashboardDataUsecaseProvider = Provider<GetDashboardDataUsecase>(
  (ref) => GetDashboardDataUsecase(ref.read(dashboardRepositoryProvider)),
);
