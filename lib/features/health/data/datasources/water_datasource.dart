import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/constants/api_constants.dart';
import 'package:ltc/core/models/base_response.dart';
import 'package:ltc/core/network/dio_provider.dart';
import 'package:ltc/features/health/data/models/water_model.dart';

class WaterDatasource {
  final Dio _dio;
  WaterDatasource(this._dio);

  Future<BaseResponse<List<WaterModel>>> getWater({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.water,
        queryParameters: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
        },
      );
      return BaseResponse<List<WaterModel>>.fromJson(
        response.data,
        (data) =>
            (data as List).map((e) => WaterModel.fromJson(json: e)).toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<WaterModel>>(success: false, data: []);
    }
  }

  Future<BaseResponse<List<WaterModel>>> insertWater({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required int ml,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.water,
        data: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
          'record_date': recordDate.toIso8601String(),
          'ml': ml,
        },
      );
      return BaseResponse<List<WaterModel>>.fromJson(
        response.data,
        (data) =>
            (data as List).map((e) => WaterModel.fromJson(json: e)).toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<WaterModel>>(success: false, data: []);
    }
  }

  Future<BaseResponse<List<WaterModel>>> updateWater({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? recordDate,
    int? ml,
    required String metricId,
    bool? isDeleted,
  }) async {
    try {
      final response = await _dio.put(
        ApiConstants.water,
        data: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
          'record_date': recordDate?.toIso8601String(),
          'ml': ml,
          'metric_id': metricId,
          'Is_deleted': isDeleted,
        },
      );
      return BaseResponse<List<WaterModel>>.fromJson(
        response.data,
        (data) =>
            (data as List).map((e) => WaterModel.fromJson(json: e)).toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<WaterModel>>(success: false, data: []);
    }
  }
}

final waterDatasourceProvider = Provider<WaterDatasource>(
  (ref) => WaterDatasource(ref.read(dioProvider)),
);
