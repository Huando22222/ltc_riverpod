import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/constants/api_constants.dart';
import 'package:ltc/core/models/base_response.dart';
import 'package:ltc/core/network/dio_provider.dart';
import 'package:ltc/features/booking/data/models/service_model.dart';

final serviceRemoteDatasourceProvider = Provider<ServiceRemoteDatasource>(
  (ref) => ServiceRemoteDatasource(ref.read(dioProvider)),
);

class ServiceRemoteDatasource {
  final Dio _dio;
  const ServiceRemoteDatasource(this._dio);

  Future<BaseResponse<ServiceModel>> search({String? search}) async {
    final response = await _dio.get(
      ApiConstants.searchService,
      queryParameters: {'search': search},
    );

    final res = BaseResponse<ServiceModel>.fromJson(
      response.data,
      (json) => json,
    );
    return res;
  }
}
