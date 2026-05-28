import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/constants/api_constants.dart';
import 'package:ltc/core/models/base_response.dart';
import 'package:ltc/core/network/dio_provider.dart';
import 'package:ltc/features/health/data/models/bmi_model.dart';

class BmiDatasource {
  final Dio _dio;
  BmiDatasource(this._dio);

  Future<BaseResponse<List<BmiModel>>> getBmi({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.bmi,
        queryParameters: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
        },
      );
      return BaseResponse<List<BmiModel>>.fromJson(
        response.data,
        (data) =>
            (data as List).map((e) => BmiModel.fromJson(json: e)).toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<BmiModel>>(success: false, data: []);
    }
  }

  Future<BaseResponse<List<BmiModel>>> insertBmi({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required double weight,
    required double height,
    double? waistCircumference,
    double? hipCircumference,
    double? chestCircumference,
    double? bodyFatPercentage,
    String? note,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.bmi,
        data: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
          'record_date': recordDate.toIso8601String(),
          'height': height,
          'weight': weight,
          'waist_circumference': waistCircumference,
          'hip_circumference': hipCircumference,
          'chest_circumference': chestCircumference,
          'body_fat_percentage': bodyFatPercentage,
          'note': note,
        },
      );
      return BaseResponse<List<BmiModel>>.fromJson(
        response.data,
        (data) =>
            (data as List).map((e) => BmiModel.fromJson(json: e)).toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<BmiModel>>(success: false, data: []);
    }
  }

  Future<BaseResponse<List<BmiModel>>> updateBmi({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? recordDate,
    double? weight,
    double? height,
    double? waistCircumference,
    double? hipCircumference,
    double? chestCircumference,
    double? bodyFatPercentage,
    String? note,
    required String metricId,
    bool? isDeleted,
  }) async {
    try {
      final response = await _dio.put(
        ApiConstants.bmi,
        data: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
          'record_date': recordDate?.toIso8601String(),
          'weight': weight,
          'height': height,
          'waist_circumference': waistCircumference,
          'hip_circumference': hipCircumference,
          'chest_circumference': chestCircumference,
          'body_fat_percentage': bodyFatPercentage,
          'note': note,
          'metric_id': metricId,
          'Is_deleted': isDeleted,
        },
      );
      return BaseResponse<List<BmiModel>>.fromJson(
        response.data,
        (data) =>
            (data as List).map((e) => BmiModel.fromJson(json: e)).toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<BmiModel>>(success: false, data: []);
    }
  }
}

final bmiDatasourceProvider = Provider<BmiDatasource>(
  (ref) => BmiDatasource(ref.read(dioProvider)),
);
