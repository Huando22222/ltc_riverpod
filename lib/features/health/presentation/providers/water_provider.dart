import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';
import 'package:ltc/features/health/domain/entities/heart_beat_entity.dart';
import 'package:ltc/features/health/domain/entities/water_entity.dart';
import 'package:ltc/features/health/domain/usecases/heart_beat_usecases.dart';
import 'package:ltc/features/health/domain/usecases/water_usecases.dart';

class WaterNotifier extends AsyncNotifier<List<WaterEntity>> {
  late DateTime _from;
  late DateTime _to;
  String? _currentUserId;

  DateTime get from => _from;
  DateTime get to => _to;
  String? get currentUserId => _currentUserId;

  @override
  Future<List<WaterEntity>> build() async {
    final user = ref.watch(currentUserProvider);
    if (user == null) return [];

    final now = DateTime.now();

    _currentUserId = user.userId;
    _from = DateTime(now.year, now.month, 1);
    _to = now;

    return fetch(userId: _currentUserId!, from: _from, to: _to);
  }

  Future<List<WaterEntity>> fetch({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    final usecase = ref.read(getWaterUsecaseProvider);

    final result = await usecase(userId: userId, from: from, to: to);

    return result.fold((failure) => throw failure.message, (data) => data);
  }

  Future<void> fetchAndSet({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    _currentUserId = userId;
    _from = from;
    _to = to;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return fetch(userId: userId, from: from, to: to);
    });
  }

  Future<void> changeRange({
    required DateTime from,
    required DateTime to,
    String? userId,
  }) async {
    final selectedUserId =
        userId ?? _currentUserId ?? ref.read(currentUserProvider)?.userId;

    if (selectedUserId == null) return;

    await fetchAndSet(userId: selectedUserId, from: from, to: to);
  }

  Future<void> refreshData() async {
    final selectedUserId =
        _currentUserId ?? ref.read(currentUserProvider)?.userId;

    if (selectedUserId == null) return;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return fetch(userId: selectedUserId, from: _from, to: _to);
    });
  }

  Future<void> insert({
    String? userId,
    DateTime? from,
    DateTime? to,
    required DateTime recordDate,
    required int ml,
  }) async {
    final selectedUserId =
        userId ?? _currentUserId ?? ref.read(currentUserProvider)?.userId;

    if (selectedUserId == null) return;

    final selectedFrom = from ?? _from;
    final selectedTo = to ?? _to;

    state = const AsyncLoading();

    final usecase = ref.read(insertWaterUsecaseProvider);

    final result = await usecase(
      userId: selectedUserId,
      from: selectedFrom,
      to: selectedTo,
      recordDate: recordDate,
      ml: ml,
    );

    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (data) {
        _currentUserId = selectedUserId;
        _from = selectedFrom;
        _to = selectedTo;
        return AsyncData(data);
      },
    );
  }

  Future<void> updateMetric({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? recordDate,
    int? ml,
    required String metricId,
    bool? isDeleted,
  }) async {
    state = const AsyncLoading();

    final usecase = ref.read(updateWaterUsecaseProvider);

    final result = await usecase(
      userId: userId,
      from: from,
      to: to,
      recordDate: recordDate,
      ml: ml,
      metricId: metricId,
      isDeleted: isDeleted,
    );

    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (data) {
        _currentUserId = userId;
        _from = from;
        _to = to;
        return AsyncData(data);
      },
    );
  }
}

final waterProvider = AsyncNotifierProvider<WaterNotifier, List<WaterEntity>>(
  WaterNotifier.new,
);
