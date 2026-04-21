import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/config/app_constants.dart';
import 'package:ltc/core/constants/api_constants.dart';
import 'package:ltc/core/constants/app_constants.dart';
import 'package:ltc/core/models/base_response.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/user_model.dart';

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>(
  (ref) => AuthRemoteDatasource(ref.read(dioProvider)),
);

class AuthRemoteDatasource {
  const AuthRemoteDatasource(this._dio);
  final Dio _dio;

  Future<BaseResponse<UserModel>> login({
    required String username,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: {
        'username': username,
        'password': password,
        'serverId': AppConstants.serverId,
        'application_id': AppConstants.appId,
      },
    );
    return BaseResponse.fromJson(
      response.data,
      (data) => UserModel.fromJson(data as Map<String, dynamic>),
    ); // UserModel.fromJson(response.data['data']);
  }

  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }

  Future<UserModel> getMe() async {
    final response = await _dio.get(ApiConstants.profile);
    return UserModel.fromJson(response.data['data']);
  }
}
