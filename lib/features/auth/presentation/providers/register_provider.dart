import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/validators/validators.dart';
import 'package:ltc/features/auth/domain/usecases/register_usecase.dart';
import 'package:ltc/features/auth/presentation/states/register_state.dart';

class RegisterNotifier extends Notifier<RegisterFormState> {
  @override
  RegisterFormState build() => const RegisterFormState();

  RegisterUsecase get _register => ref.read(registerUsecaseProvider);

  // ── Helpers ──────────────────────────────────────────────────────────────────

  /// Chỉ validate nếu đang ở chế độ validateOnChange
  String? _maybeValidate(String? Function() validator) {
    if (!state.validateOnChange) return null; // không validate → không set lỗi
    return validator();
  }

  // ── onChanged handlers ───────────────────────────────────────────────────────

  void onUsernameChanged(String value) {
    state = state.copyWith(
      username: value,
      usernameError: _maybeValidate(() => Validators.username(value)),
    );
  }

  void onPhoneChanged(String value) {
    state = state.copyWith(
      phone: value,
      // ✅ Luôn truyền kết quả validator (null = xóa lỗi, String = hiện lỗi)
      phoneError: _maybeValidate(() => Validators.phone(value)),
    );
  }

  void onPasswordChanged(String value) {
    state = state.copyWith(
      password: value,
      passwordError: _maybeValidate(() => Validators.password(value)),
      // Re-validate confirm nếu đã có giá trị
      confirmPasswordError: state.confirmPassword.isEmpty
          ? null
          : _maybeValidate(
              () => Validators.confirmPassword(value)(state.confirmPassword),
            ),
    );
  }

  void onConfirmPasswordChanged(String value) {
    state = state.copyWith(
      confirmPassword: value,
      confirmPasswordError: _maybeValidate(
        () => Validators.confirmPassword(state.password)(value),
      ),
    );
  }

  void onEmailChanged(String value) {
    state = state.copyWith(
      email: value,
      emailError: _maybeValidate(() => Validators.emailOptional(value)),
    );
  }

  // ── Toggle validate mode ─────────────────────────────────────────────────────

  /// Bật/tắt validate realtime từ bên ngoài nếu cần
  void setValidateOnChange({required bool value}) {
    state = state.copyWith(validateOnChange: value);
  }

  // ── validateAll (luôn chạy, bất kể validateOnChange) ────────────────────────

  bool validateAll() {
    final s = state;
    final next = s.copyWith(
      usernameError: Validators.username(s.username),
      phoneError: Validators.phone(s.phone),
      passwordError: Validators.password(s.password),
      confirmPasswordError: Validators.confirmPassword(s.password)(
        s.confirmPassword,
      ),
      emailError: Validators.emailOptional(s.email),
    );
    state = next;
    return next.isValid;
  }

  // ── submit ───────────────────────────────────────────────────────────────────

  Future<bool> register({required List<String> roleId}) async {
    if (!validateAll()) return false;

    state = state.copyWith(
      isSubmitting: true,
      errorMessage: null,
    ); // clear lỗi cũ
    final s = state;

    final result = await _register(
      username: s.username.trim(),
      password: s.password,
      phone: s.phone.trim(),
      email: s.email.trim().isEmpty ? null : s.email.trim(),
      roleId: roleId,
    );
    state = state.copyWith(
      isSubmitting: false,
      errorMessage: result.fold(
        (failure) => failure.message, // ← map ở đây
        (_) => null,
      ),
    );

    return result.fold((_) => false, (res) => res);
  }
}

final registerProvider =
    NotifierProvider.autoDispose<RegisterNotifier, RegisterFormState>(
      RegisterNotifier.new,
    );
