import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:ltc/core/constants/pref_constants.dart';
import 'package:ltc/features/auth/domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._loginUsecase, this._logoutUsecase)
    : super(const AuthInitial());

  final LoginUsecase _loginUsecase;
  final LogoutUsecase _logoutUsecase;

  Future<void> _saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      if (user.token != null) prefs.setString(PrefConstants.token, user.token!),
      if (user.refreshToken != null)
        prefs.setString(PrefConstants.refreshToken, user.refreshToken!),
      // Lưu profile dưới dạng JSON string
      prefs.setString(PrefConstants.profile, jsonEncode(user.toJson())),
    ]);
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(PrefConstants.token),
      prefs.remove(PrefConstants.refreshToken),
      prefs.remove(PrefConstants.profile),
    ]);
  }

  Future<void> updateProfile(UserEntity updatedUser) async {
    if (state is! AuthAuthenticated) return;

    state = AuthAuthenticated(updatedUser);

    final model = updatedUser as UserModel;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefConstants.profile, jsonEncode(model.toJson()));
  }

  // ─── Gọi ở SplashScreen ──────────────────────────
  Future<void> checkAuth() async {
    state = const AuthLoading();

    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(PrefConstants.profile);
      final token = prefs.getString(PrefConstants.token);

      if (token == null || profileJson == null) {
        state = const AuthUnauthenticated();
        return;
      }

      final user = UserModel.fromJson(
        jsonDecode(profileJson) as Map<String, dynamic>,
      );

      // TODO: Gọi API /me để verify token (optional)
      // final result = await _getMeUsecase();
      // result.fold(...)

      state = AuthAuthenticated(user);
    } catch (_) {
      // Pref bị corrupt → clear và về login
      await _clearSession();
      state = const AuthUnauthenticated();
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = const AuthLoading();

    final result = await _loginUsecase(
      LoginParams(username: username, password: password),
    );

    result.fold((failure) => state = AuthError(failure.message), (user) async {
      final model = user as UserModel;
      await _saveSession(model);
      state = AuthAuthenticated(model);
    });
  }

  Future<void> logout() async {
    state = const AuthLoading();
    await _logoutUsecase();
    await _clearSession();
    state = const AuthUnauthenticated();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(loginUsecaseProvider),
    ref.read(logoutUsecaseProvider),
  );
});

final isAuthenticatedProvider = Provider<bool>(
  (ref) => ref.watch(authProvider) is AuthAuthenticated,
);

final currentUserProvider = Provider<UserEntity?>((ref) {
  final state = ref.watch(authProvider);
  if (state is AuthAuthenticated) return state.user;
  return null;
});
