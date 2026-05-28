import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/constants/api_constants.dart';
import 'package:ltc/core/models/base_response.dart';
import 'package:ltc/core/network/dio_provider.dart';
import 'package:ltc/features/health/data/models/blood_pressure_model.dart';

class BloodPressureDatasource {
  final Dio _dio;
  BloodPressureDatasource(this._dio);

  Future<BaseResponse<List<BloodPressureModel>>> getBloodPressure({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.bloodPressure,
        queryParameters: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
        },
      );
      return BaseResponse<List<BloodPressureModel>>.fromJson(
        response.data,
        (data) => (data as List)
            .map((e) => BloodPressureModel.fromJson(json: e))
            .toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<BloodPressureModel>>(success: false, data: []);
    }
  }

  Future<BaseResponse<List<BloodPressureModel>>> insertBloodPressure({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required int systolic,
    required int diastolic,
    String? context,
    String? note,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.bloodPressure,
        data: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
          'record_date': recordDate.toIso8601String(),
          'systolic': systolic,
          'diastolic': diastolic,
          'context': context, //"Thở đều",
          'note': note,
        },
      );
      return BaseResponse<List<BloodPressureModel>>.fromJson(
        response.data,
        (data) => (data as List)
            .map((e) => BloodPressureModel.fromJson(json: e))
            .toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<BloodPressureModel>>(success: false, data: []);
    }
  }

  Future<BaseResponse<List<BloodPressureModel>>> updateBloodPressure({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? recordDate,
    int? systolic,
    int? diastolic,
    String? context,
    String? note,
    required String metricId,
    bool? isDeleted,
  }) async {
    try {
      final response = await _dio.put(
        ApiConstants.bloodPressure,
        data: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
          'record_date': recordDate?.toIso8601String(),
          'systolic': systolic,
          'diastolic': diastolic,
          'context': context, //"Thở đều",
          'note': note,
          'metric_id': metricId,
          'Is_deleted': isDeleted,
        },
      );
      return BaseResponse<List<BloodPressureModel>>.fromJson(
        response.data,
        (data) => (data as List)
            .map((e) => BloodPressureModel.fromJson(json: e))
            .toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<BloodPressureModel>>(success: false, data: []);
    }
  }
}

final bloodPressureDatasourceProvider = Provider<BloodPressureDatasource>(
  (ref) => BloodPressureDatasource(ref.read(dioProvider)),
);
