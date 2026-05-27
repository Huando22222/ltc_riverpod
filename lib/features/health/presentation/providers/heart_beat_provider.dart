import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';
import 'package:ltc/features/health/domain/entities/heart_beat_entity.dart';
import 'package:ltc/features/health/domain/usecases/heart_beat_usecases.dart';

class HeartBeatNotifier extends AsyncNotifier<List<HeartBeatEntity>> {
  late DateTime _from;
  late DateTime _to;
  String? _currentUserId;

  DateTime get from => _from;
  DateTime get to => _to;
  String? get currentUserId => _currentUserId;

  @override
  Future<List<HeartBeatEntity>> build() async {
    final user = ref.watch(currentUserProvider);
    if (user == null) return [];

    final now = DateTime.now();

    _currentUserId = user.userId;
    _from = DateTime(now.year, now.month, 1);
    _to = now;

    return fetch(userId: _currentUserId!, from: _from, to: _to);
  }

  Future<List<HeartBeatEntity>> fetch({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    final usecase = ref.read(getHeartBeatUsecaseProvider);

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
    required DateTime recordDate,
    required int bpm,
    String? context,
    String? note,
    String? userId,
    DateTime? from,
    DateTime? to,
  }) async {
    final selectedUserId =
        userId ?? _currentUserId ?? ref.read(currentUserProvider)?.userId;

    if (selectedUserId == null) return;

    final selectedFrom = from ?? _from;
    final selectedTo = to ?? _to;

    state = const AsyncLoading();

    final usecase = ref.read(insertHeartBeatUsecaseProvider);

    final result = await usecase(
      userId: selectedUserId,
      from: selectedFrom,
      to: selectedTo,
      recordDate: recordDate,
      bpm: bpm,
      context: context,
      note: note,
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
    double? bpm,
    String? context,
    String? note,
    required String metricId,
    bool? isDeleted,
  }) async {
    state = const AsyncLoading();

    final usecase = ref.read(updateHeartBeatUsecaseProvider);

    final result = await usecase(
      userId: userId,
      from: from,
      to: to,
      recordDate: recordDate,
      bpm: bpm,
      context: context,
      note: note,
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

final heartBeatProvider =
    AsyncNotifierProvider<HeartBeatNotifier, List<HeartBeatEntity>>(
      HeartBeatNotifier.new,
    );
