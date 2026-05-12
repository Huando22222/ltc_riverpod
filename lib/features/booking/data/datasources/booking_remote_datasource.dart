import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/constants/api_constants.dart';
import 'package:ltc/core/models/base_response.dart';
import 'package:ltc/core/network/dio_provider.dart';
import 'package:ltc/features/booking/domain/usecases/booking_service_usecase.dart';

final bookingRemoteDatasourceProvider = Provider<BookingRemoteDatasource>(
  (ref) => BookingRemoteDatasource(ref.read(dioProvider)),
);

class BookingRemoteDatasource {
  final Dio _dio;
  const BookingRemoteDatasource(this._dio);

  Future<BaseResponse<String>> booking({required BookingParams params}) async {
    final response = await _dio.post(
      ApiConstants.createSche,
      queryParameters: {},
    );

    final res = BaseResponse<String>.fromJson(response.data);
    return res;
  }
}
