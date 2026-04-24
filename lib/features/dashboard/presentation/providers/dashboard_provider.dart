import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/features/dashboard/domain/entities/dashboard_entity.dart';
import '../../domain/usecases/get_dashboard_data_usecase.dart';

class DashboardNotifier extends Notifier<DashboardEntity> {
  @override
  DashboardEntity build() => DashboardEntity.empty();

  GetDashboardDataUsecase get _getDashboardData =>
      ref.read(getDashboardDataUsecaseProvider);

  Future<void> getDashboardData() async {
    final result = await _getDashboardData();

    result.fold((failure) {}, (dashboard) async {
      state = dashboard;
    });
  }
}

final dashboardProvider = NotifierProvider<DashboardNotifier, DashboardEntity>(
  DashboardNotifier.new,
);
