// auth_interceptor.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/constants/api_constants.dart';
import 'package:ltc/core/constants/pref_constants.dart';
import 'package:ltc/features/auth/data/models/user_model.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';
import 'package:ltc/features/auth/presentation/states/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authInterceptorProvider = Provider<AuthInterceptor>(
  (ref) => AuthInterceptor(ref),
);

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._ref);
  final Ref _ref;

  bool _isRefreshing = false;
  final List<_PendingRequest> _queue = [];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isPublic(options.path)) {
      final state = _ref.read(authProvider);
      if (state is AuthAuthenticated) {
        final token = state.user.token;
        final userSessionId = state.user.userSessionId;

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          options.headers['X-Session-Id'] = userSessionId;
        }
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }
    if (_isRefreshing) {
      _queue.add(_PendingRequest(err.requestOptions, handler));
      return;
    }

    _isRefreshing = true;

    try {
      final isExpired = await _checkToken();
      if (!isExpired) {
        // 401 nhưng token vẫn còn hạn → lỗi khác (unauthorized)
        // Không refresh, trả lỗi về cho app xử lý
        return handler.next(err);
      }
      // Bước 2: Token thực sự hết hạn → gọi refresh
      final newToken = await _doRefresh();

      if (newToken == null) {
        await _doLogout();
        return handler.next(err);
      }

      final retried = await _retry(err.requestOptions, newToken);
      handler.resolve(retried);

      for (final pending in _queue) {
        try {
          final res = await _retry(pending.options, newToken);
          pending.handler.resolve(res);
        } catch (_) {
          pending.handler.next(err);
        }
      }
    } catch (_) {
      await _doLogout();
      handler.next(err);
    } finally {
      _isRefreshing = false;
      _queue.clear();
    }
  }

  // Gọi check-token → trả true nếu token hết hạn (status code 401)
  Future<bool> _checkToken() async {
    try {
      final state = _ref.read(authProvider);
      if (state is AuthAuthenticated) {
        final token = state.user.token;

        if (token != null) {
          final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
          await dio.get(
            ApiConstants.checkToken,
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );

          // Status 200 → token còn hạn
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }
    } on DioException catch (e) {
      // Status code 401 → token hết hạn
      if (e.response?.statusCode == 401) return true;
      // Lỗi khác → không phải do token
      return false;
    }
  }

  // Gọi refresh token
  Future<String?> _doRefresh() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(PrefConstants.profile);
    if (userStr == null) return null;
    UserModel user = UserModel.fromRawJson(userStr);

    try {
      final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

      final res = await dio.post(
        ApiConstants.refreshToken,
        options: Options(extra: {'X-Session-Id': user.userSessionId}),
      );

      if (res.data == null || res.statusCode != 200) return null;
      final newAccess = res.data['jwToken'] as String?;
      final newRefresh = res.data['refreshToken'] as String?;
      final newUserSessionId = res.data['userSession'] as String?;

      user.token = newAccess;
      user.refreshToken = newRefresh;
      user.userSessionId = newUserSessionId;
      prefs.setString(PrefConstants.profile, (jsonEncode(user.toJson())));
      return newAccess;
    } on DioException catch (e) {
      // Refresh cũng trả 401 → hết hạn hoàn toàn
      if (e.response?.statusCode == 401) return null;
      return null;
    }
  }

  // Retry request với token mới
  Future<Response> _retry(RequestOptions options, String token) {
    final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
    return dio.request(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: Options(
        method: options.method,
        headers: {
          ...options.headers,
          'Authorization': 'Bearer $token',
          'X-Session-Id': options.headers['X-Session-Id'],
        },
      ),
    );
  }

  // Logout khi refresh thất bại
  Future<void> _doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([prefs.remove(PrefConstants.profile)]);
    Future.microtask(() => _ref.read(authProvider.notifier).logout());
  }

  bool _isPublic(String path) => [
    ApiConstants.login,
    // ApiConstants.refreshToken,
    // ApiConstants.checkToken,
  ].any(path.contains);
}

class _PendingRequest {
  const _PendingRequest(this.options, this.handler);
  final RequestOptions options;
  final ErrorInterceptorHandler handler;
}
