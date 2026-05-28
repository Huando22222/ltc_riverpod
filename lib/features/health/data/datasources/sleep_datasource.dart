import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/constants/api_constants.dart';
import 'package:ltc/core/models/base_response.dart';
import 'package:ltc/core/network/dio_provider.dart';
import 'package:ltc/features/health/data/models/sleep_model.dart';

class SleepDatasource {
  final Dio _dio;
  SleepDatasource(this._dio);

  Future<BaseResponse<List<SleepModel>>> getSleep({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.sleep,
        queryParameters: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
        },
      );
      return BaseResponse<List<SleepModel>>.fromJson(
        response.data,
        (data) =>
            (data as List).map((e) => SleepModel.fromJson(json: e)).toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<SleepModel>>(success: false, data: []);
    }
  }

  Future<BaseResponse<List<SleepModel>>> insertSleep({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime startSleepDateTime,
    required DateTime wakeUpDateTime,
    required int timeNeedToSleep,
    required int timeNeedToWakeUp,
    int? sleepRating,
    String? note,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.sleep,
        data: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
          'start_sleep_date_time': startSleepDateTime.toIso8601String(),
          'wake_up_date_time': wakeUpDateTime.toIso8601String(),
          'time_need_to_sleep': timeNeedToSleep,
          'time_need_to_wake_up': timeNeedToWakeUp,
          'sleep_rating': sleepRating,
          'note': note,
        },
      );
      return BaseResponse<List<SleepModel>>.fromJson(
        response.data,
        (data) =>
            (data as List).map((e) => SleepModel.fromJson(json: e)).toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<SleepModel>>(success: false, data: []);
    }
  }

  Future<BaseResponse<List<SleepModel>>> updateSleep({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? startSleepDateTime,
    DateTime? wakeUpDateTime,
    int? timeNeedToSleep,
    int? timeNeedToWakeUp,
    int? sleepRating,
    required String metricId,
    bool? isDeleted,
  }) async {
    try {
      final response = await _dio.put(
        ApiConstants.sleep,
        data: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
          'start_sleep_date_time': startSleepDateTime?.toIso8601String(),
          'wake_up_date_time': wakeUpDateTime?.toIso8601String(),
          'time_need_to_sleep': timeNeedToSleep,
          'time_need_to_wake_up': timeNeedToWakeUp,
          'sleep_rating': sleepRating,
          'metric_id': metricId,
          'Is_deleted': isDeleted,
        },
      );
      return BaseResponse<List<SleepModel>>.fromJson(
        response.data,
        (data) =>
            (data as List).map((e) => SleepModel.fromJson(json: e)).toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<SleepModel>>(success: false, data: []);
    }
  }
}

final sleepDatasourceProvider = Provider<SleepDatasource>(
  (ref) => SleepDatasource(ref.read(dioProvider)),
);
