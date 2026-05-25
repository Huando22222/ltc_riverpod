import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/constants/api_constants.dart';
import 'package:ltc/core/models/base_response.dart';
import 'package:ltc/core/network/dio_provider.dart';
import 'package:ltc/features/lookup/data/models/booking_data_model.dart';

class BookingDataDatasource {
  const BookingDataDatasource(this._dio);
  final Dio _dio;
  Future<BaseResponse<List<BookingDataModel>>> getBookingDataHistory({
    required String userRefId,
    required DateTime from,
    required DateTime to,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.getBookingDataHistory,
        data: {
          'user_ref_id': userRefId,
          'from_date': from.toIso8601String(),
          'to_date': to.toIso8601String(),
          'page': page,
          'page_size': pageSize,
        },
      );
      return BaseResponse<List<BookingDataModel>>.fromJson(
        response.data,
        (data) =>
            (data as List).map((e) => BookingDataModel.fromJson(e)).toList(),
      );
    } catch (e, stacktrace) {
      log('$e = $stacktrace');
      return BaseResponse<List<BookingDataModel>>(success: false, data: []);
    }
  }
}

final bookingDataDatasourceProvider = Provider<BookingDataDatasource>(
  (ref) => BookingDataDatasource(ref.read(dioProvider)),
);
