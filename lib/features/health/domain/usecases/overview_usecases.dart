import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/data/repositories/overview_repository_impl.dart';
import 'package:ltc/features/health/domain/entities/overview_entity.dart';
import 'package:ltc/features/health/domain/repositories/overview_repository.dart';

class OverviewUsecases {
  final OverviewRepository _repository;
  OverviewUsecases(this._repository);

  Future<Either<Failure, OverviewEntity>> call({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    return _repository.getOverview(userId: userId, from: from, to: to);
  }
}

final getOverviewUsecaseProvider = Provider<OverviewUsecases>(
  (ref) => OverviewUsecases(ref.read(overviewRepositoryProvider)),
);
