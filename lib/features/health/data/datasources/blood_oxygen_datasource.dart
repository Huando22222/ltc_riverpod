import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/constants/api_constants.dart';
import 'package:ltc/core/models/base_response.dart';
import 'package:ltc/core/network/dio_provider.dart';
import 'package:ltc/features/health/data/models/blood_oxygen_model.dart';

class BloodOxygenDatasource {
  final Dio _dio;
  BloodOxygenDatasource(this._dio);

  Future<BaseResponse<List<BloodOxygenModel>>> getBloodOxygen({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.bloodOxygen,
        queryParameters: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
        },
      );
      return BaseResponse<List<BloodOxygenModel>>.fromJson(
        response.data,
        (data) => (data as List)
            .map((e) => BloodOxygenModel.fromJson(json: e))
            .toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<BloodOxygenModel>>(success: false, data: []);
    }
  }

  Future<BaseResponse<List<BloodOxygenModel>>> insertBloodOxygen({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required double spo2,
    String? context,
    String? note,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.bloodOxygen,
        data: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
          'record_date': recordDate.toIso8601String(),
          'spo2': spo2,
          'context': context, //"Thở đều",
          'note': note,
        },
      );
      return BaseResponse<List<BloodOxygenModel>>.fromJson(
        response.data,
        (data) => (data as List)
            .map((e) => BloodOxygenModel.fromJson(json: e))
            .toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<BloodOxygenModel>>(success: false, data: []);
    }
  }

  Future<BaseResponse<List<BloodOxygenModel>>> updateBloodOxygen({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? recordDate,
    double? spo2,
    String? context,
    String? note,
    required String metricId,
    bool? isDeleted,
  }) async {
    try {
      final response = await _dio.put(
        ApiConstants.bloodOxygen,
        data: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
          'record_date': recordDate?.toIso8601String(),
          'spo2': spo2,
          'context': context, //"Thở đều",
          'note': note,
          'metric_id': metricId,
          'Is_deleted': isDeleted,
        },
      );
      return BaseResponse<List<BloodOxygenModel>>.fromJson(
        response.data,
        (data) => (data as List)
            .map((e) => BloodOxygenModel.fromJson(json: e))
            .toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<BloodOxygenModel>>(success: false, data: []);
    }
  }
}

final bloodOxygenDatasourceProvider = Provider<BloodOxygenDatasource>(
  (ref) => BloodOxygenDatasource(ref.read(dioProvider)),
);
