import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/constants/api_constants.dart';
import 'package:ltc/core/models/base_response.dart';
import 'package:ltc/core/network/dio_provider.dart';
import 'package:ltc/features/health/data/models/overview_model.dart';

class OverviewDatasource {
  final Dio _dio;
  OverviewDatasource(this._dio);

  Future<BaseResponse<OverviewModel>> getOverview({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.overview,
        queryParameters: {
          'user_id': userId,
          'from_datetime': from.toIso8601String(),
          'to_datetime': to.toIso8601String(),
        },
      );
      return BaseResponse<OverviewModel>.fromJson(
        response.data,
        (data) => OverviewModel.fromJson(json: data),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<OverviewModel>(success: false, data: null);
    }
  }
}

final overviewDatasourceProvider = Provider<OverviewDatasource>(
  (ref) => OverviewDatasource(ref.read(dioProvider)),
);
