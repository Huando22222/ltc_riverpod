import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/constants/api_constants.dart';
import 'package:ltc/core/models/base_response.dart';
import 'package:ltc/core/network/dio_provider.dart';
import 'package:ltc/features/health/data/models/heart_beat_model.dart';

class HeartBeatDatasource {
  final Dio _dio;
  HeartBeatDatasource(this._dio);

  Future<BaseResponse<List<HeartBeatModel>>> getHeartBeat({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.heartBeat,
        queryParameters: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
        },
      );
      return BaseResponse<List<HeartBeatModel>>.fromJson(
        response.data,
        (data) => (data as List)
            .map((e) => HeartBeatModel.fromJson(json: e))
            .toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<HeartBeatModel>>(success: false, data: []);
    }
  }

  Future<BaseResponse<List<HeartBeatModel>>> insertHeartBeat({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required int bpm,
    String? context,
    String? note,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.heartBeat,
        data: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
          'record_date': recordDate.toIso8601String(),
          'heart_beat': bpm,
          'context': context, //"Thở đều",
          'note': note,
        },
      );
      return BaseResponse<List<HeartBeatModel>>.fromJson(
        response.data,
        (data) => (data as List)
            .map((e) => HeartBeatModel.fromJson(json: e))
            .toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<HeartBeatModel>>(success: false, data: []);
    }
  }

  Future<BaseResponse<List<HeartBeatModel>>> updateHeartBeat({
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
    try {
      final response = await _dio.put(
        ApiConstants.heartBeat,
        data: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
          'record_date': recordDate?.toIso8601String(),
          'heart_beat': bpm,
          'context': context,
          'note': note,
          'metric_id': metricId,
          'Is_deleted': isDeleted,
        },
      );
      return BaseResponse<List<HeartBeatModel>>.fromJson(
        response.data,
        (data) => (data as List)
            .map((e) => HeartBeatModel.fromJson(json: e))
            .toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<HeartBeatModel>>(success: false, data: []);
    }
  }
}

final heartBeatDatasourceProvider = Provider<HeartBeatDatasource>(
  (ref) => HeartBeatDatasource(ref.read(dioProvider)),
);
