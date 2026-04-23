import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/constants/pref_constants.dart';
import 'package:ltc/features/auth/domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_state.dart';

// ✅ Notifier<S> thay StateNotifier<S>
class AuthNotifier extends Notifier<AuthState> {
  // ✅ build() thay constructor + super(initialState)
  @override
  AuthState build() => const AuthInitial();

  // ✅ Usecase lấy qua ref — không cần truyền constructor
  LoginUsecase get _login => ref.read(loginUsecaseProvider);
  LogoutUsecase get _logout => ref.read(logoutUsecaseProvider);

  Future<void> _saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefConstants.profile, jsonEncode(user.toJson()));
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PrefConstants.profile);
  }

  Future<void> updateProfile(UserEntity updatedUser) async {
    if (state is! AuthAuthenticated) return;
    state = AuthAuthenticated(updatedUser);
    final model = updatedUser as UserModel;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefConstants.profile, jsonEncode(model.toJson()));
  }

  Future<void> checkAuth() async {
    state = const AuthLoading();
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(PrefConstants.profile);

      if (profileJson == null) {
        state = const AuthUnauthenticated();
        return;
      }

      final user = UserModel.fromJson(
        json: jsonDecode(profileJson) as Map<String, dynamic>,
      );
      state = AuthAuthenticated(user);
    } catch (_) {
      await _clearSession();
      state = const AuthUnauthenticated();
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = const AuthLoading();

    final result = await _login(
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
    await _logout();
    await _clearSession();
    state = const AuthUnauthenticated();
  }
}

// ✅ NotifierProvider thay StateNotifierProvider
final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new, // ← gọn hơn () => AuthNotifier()
);

final isAuthenticatedProvider = Provider<bool>(
  (ref) => ref.watch(authProvider) is AuthAuthenticated,
);

final currentUserProvider = Provider<UserEntity?>((ref) {
  final state = ref.watch(authProvider);
  if (state is AuthAuthenticated) return state.user;
  return null;
});
