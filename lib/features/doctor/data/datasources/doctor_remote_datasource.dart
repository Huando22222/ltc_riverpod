import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/constants/api_constants.dart';
import 'package:ltc/core/models/base_response.dart';
import 'package:ltc/core/network/dio_provider.dart';
import 'package:ltc/features/doctor/data/models/doctor_model.dart';

final doctorRemoteDatasourceProvider = Provider<DoctorRemoteDatasource>(
  (ref) => DoctorRemoteDatasource(ref.read(dioProvider)),
);

class DoctorRemoteDatasource {
  final Dio _dio;
  const DoctorRemoteDatasource(this._dio);

  Future<BaseResponse<DoctorModel>> search({String? search}) async {
    final response = await _dio.get(
      ApiConstants.getListDoctor,
      queryParameters: {'search': search},
    );

    final res = BaseResponse<DoctorModel>.fromJson(
      response.data,
      (json) => json,
    );
    return res;
  }
}
