import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/constants/api_constants.dart';
import '/core/models/base_response.dart';
import '../models/dashboard_model.dart';
import '../../../../core/network/dio_provider.dart';

final dashboardRemoteDatasourceProvider = Provider<DashboardRemoteDatasource>(
  (ref) => DashboardRemoteDatasource(ref.read(dioProvider)),
);

class DashboardRemoteDatasource {
  const DashboardRemoteDatasource(this._dio);
  final Dio _dio;

  Future<BaseResponse<DashboardModel>> getDashBoardData() async {
    final responseAuth = await _dio.get(ApiConstants.dashboard);
    final res = BaseResponse<DashboardModel>.fromJson(
      responseAuth.data,
      (data) => DashboardModel.fromJson(data),
    );

    return res;
  }
}
