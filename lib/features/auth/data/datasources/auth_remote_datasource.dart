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
    final responseAuth = await _dio.post(
      ApiConstants.login,
      data: {
        'username': username,
        'password': password,
        'serverId': AppConstants.serverId,
        'application_id': AppConstants.appId,
      },
    );
    final res = BaseResponse<dynamic>.fromJson(
      responseAuth.data,
      (data) => data,
    );
    final token = res.data['jwt_token'];
    final refreshToken = res.data['user_session']['refreshToken'];
    final userSessionId = res.data['user_session']['id'];

    final responseInfo = await _dio.get(
      ApiConstants.profile,
      queryParameters: {
        'PhoneNumber': res.data['phone_number'],
        'application_id': AppConstants.appId,
      },
    );
    final list = responseInfo.data['data'] as List;

    final user = UserModel.fromJson(json: list.first as Map<String, dynamic>);

    user.token = token;
    user.refreshToken = refreshToken;
    user.userSessionId = userSessionId;

    return BaseResponse<UserModel>(success: true, message: null, data: user);
  }

  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }

  Future<UserModel> getMe() async {
    final response = await _dio.get(ApiConstants.profile);
    return UserModel.fromJson(json: response.data['data']);
  }
}
