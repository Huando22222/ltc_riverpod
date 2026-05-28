import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';
import 'package:ltc/features/health/domain/entities/overview_entity.dart';
import 'package:ltc/features/health/domain/usecases/overview_usecases.dart';

class HealthOverviewNotifier extends AsyncNotifier<OverviewEntity?> {
  late DateTime _from;
  late DateTime _to;

  DateTime get from => _from;
  DateTime get to => _to;

  @override
  Future<OverviewEntity?> build() async {
    final user = ref.watch(currentUserProvider);

    if (user == null) return null;

    final now = DateTime.now();

    _from = DateTime(now.year, now.month, 1);
    _to = now;

    return fetchOverview(userId: user.userId, from: _from, to: _to);
  }

  Future<OverviewEntity?> fetchOverview({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    final usecase = ref.read(getOverviewUsecaseProvider);

    final result = await usecase(userId: userId, from: from, to: to);

    return result.fold((failure) => throw failure.message, (data) => data);
  }

  Future<void> changeRange({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    _from = from;
    _to = to;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return fetchOverview(userId: userId, from: from, to: to);
    });
  }

  Future<void> refreshData({required String userId}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return fetchOverview(userId: userId, from: _from, to: _to);
    });
  }
}

final healthOverviewProvider =
    AsyncNotifierProvider<HealthOverviewNotifier, OverviewEntity?>(
      HealthOverviewNotifier.new,
    );
