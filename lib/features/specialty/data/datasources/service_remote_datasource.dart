import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/constants/api_constants.dart';
import 'package:ltc/core/models/base_response.dart';
import 'package:ltc/core/network/dio_provider.dart';
import 'package:ltc/features/specialty/data/models/specialty_model.dart';

final specialtyRemoteDatasourceProvider = Provider<SpecialtyRemoteDatasource>(
  (ref) => SpecialtyRemoteDatasource(ref.read(dioProvider)),
);

class SpecialtyRemoteDatasource {
  final Dio _dio;
  const SpecialtyRemoteDatasource(this._dio);

  Future<BaseResponse<List<SpecialtyModel>>> getClinicSpecialty({
    required String dcomId,
  }) async {
    final response = await _dio.get(
      ApiConstants.getClinicSpecialty,
      queryParameters: {'dcomId': dcomId},
    );

    final res = BaseResponse<List<SpecialtyModel>>.fromJson(
      response.data,
      (data) =>
          (data as List).map((e) => SpecialtyModel.fromJson(json: e)).toList(),
    );
    return res;
  }
}
