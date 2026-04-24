import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/features/dashboard/data/models/dashboard_model.dart';
import 'package:ltc/features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../../../core/error/failure.dart';
import '../datasources/dashboard_remote_datasource.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => DashboardRepositoryImpl(ref.read(dashboardRemoteDatasourceProvider)),
);

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(this._datasource);
  final DashboardRemoteDatasource _datasource;

  @override
  Future<Either<Failure, DashboardModel>> getDashBoardData() async {
    try {
      final response = await _datasource.getDashBoardData();
      return Right(response.data!);
    } catch (e, stackTrace) {
      log('DashboardRepositoryImpl: $e = $stackTrace');
      return Left(
        Failure(
          'ERROR UNEXPECTED: getDashBoardData ${e.toString()} $stackTrace',
        ),
      );
    }
  }
}
