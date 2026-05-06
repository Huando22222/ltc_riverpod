import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/constants/api_constants.dart';
import 'package:ltc/core/models/base_response.dart';
import 'package:ltc/core/network/dio_provider.dart';
import 'package:ltc/features/service/data/models/package_item_model.dart';
import 'package:ltc/features/service/data/models/package_model.dart';
import 'package:ltc/features/service/data/models/service_model.dart';

final serviceRemoteDatasourceProvider = Provider<ServiceRemoteDatasource>(
  (ref) => ServiceRemoteDatasource(ref.read(dioProvider)),
);

class ServiceRemoteDatasource {
  final Dio _dio;
  const ServiceRemoteDatasource(this._dio);

  Future<BaseResponse<List<ServiceModel>>> search({String? search}) async {
    final response = await _dio.get(
      ApiConstants.searchService,
      queryParameters: {'search': search},
    );

    final res = BaseResponse<List<ServiceModel>>.fromJson(
      response.data,
      (data) =>
          (data as List).map((e) => ServiceModel.fromJson(json: e)).toList(),
    );
    return res;
  }

  Future<BaseResponse<List<PackageModel>>> getPackages() async {
    final response = await _dio.get(
      ApiConstants.getPackage,
      queryParameters: {},
    );

    final res = BaseResponse<List<PackageModel>>.fromJson(
      response.data,
      (data) =>
          (data as List).map((e) => PackageModel.fromJson(json: e)).toList(),
    );
    return res;
  }

  Future<BaseResponse<List<PackageItemModel>>> getPackageDetail({
    String? packageId,
  }) async {
    final response = await _dio.get(
      ApiConstants.getPackageDetail,
      queryParameters: {'pkg_id': packageId},
    );

    final res = BaseResponse<List<PackageItemModel>>.fromJson(
      response.data,
      (data) => (data as List)
          .map((e) => PackageItemModel.fromJson(json: e))
          .toList(),
    );
    return res;
  }
}
