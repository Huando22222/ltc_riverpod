import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';
import 'package:ltc/features/health/domain/entities/blood_oxygen_entity.dart';
import 'package:ltc/features/health/domain/entities/blood_pressure_entity.dart';
import 'package:ltc/features/health/domain/usecases/blood_oxygen_usecases.dart';
import 'package:ltc/features/health/domain/usecases/blood_pressure_usecases.dart';

class BloodPressureNotifier extends AsyncNotifier<List<BloodPressureEntity>> {
  late DateTime _from;
  late DateTime _to;
  String? _currentUserId;

  DateTime get from => _from;
  DateTime get to => _to;
  String? get currentUserId => _currentUserId;

  @override
  Future<List<BloodPressureEntity>> build() async {
    final user = ref.watch(currentUserProvider);
    if (user == null) return [];

    final now = DateTime.now();

    _currentUserId = user.userId;
    _from = DateTime(now.year, now.month, 1);
    _to = now;

    return fetch(userId: _currentUserId!, from: _from, to: _to);
  }

  Future<List<BloodPressureEntity>> fetch({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    final usecase = ref.read(getBloodPressureUsecaseProvider);

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
    required double systolic,
    required double diastolic,
    String? context,
    String? note,
  }) async {
    final selectedUserId =
        userId ?? _currentUserId ?? ref.read(currentUserProvider)?.userId;

    if (selectedUserId == null) return;

    final selectedFrom = from ?? _from;
    final selectedTo = to ?? _to;

    state = const AsyncLoading();

    final usecase = ref.read(insertBloodPressureUsecaseProvider);

    final result = await usecase(
      userId: selectedUserId,
      from: selectedFrom,
      to: selectedTo,
      diastolic: diastolic,
      systolic: systolic,
      recordDate: recordDate,
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
    double? systolic,
    double? diastolic,
    String? context,
    String? note,
    required String metricId,
    bool? isDeleted,
  }) async {
    state = const AsyncLoading();

    final usecase = ref.read(updateBloodPressureUsecaseProvider);

    final result = await usecase(
      userId: userId,
      from: from,
      to: to,
      recordDate: recordDate,
      diastolic: diastolic,
      systolic: systolic,
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

final bloodPressureProvider =
    AsyncNotifierProvider<BloodPressureNotifier, List<BloodPressureEntity>>(
      BloodPressureNotifier.new,
    );
