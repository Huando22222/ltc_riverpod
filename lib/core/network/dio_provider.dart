import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/constants/api_constants.dart';
import 'auth_interceptor.dart';
import 'api_exception.dart';

const _baseUrl = ApiConstants.baseUrl;

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    ref.read(authInterceptorProvider), // Tự gắn Bearer token
    LogInterceptor(
      // Log khi dev
      requestBody: true,
      responseBody: true,
    ),
  ]);

  return dio;
});
