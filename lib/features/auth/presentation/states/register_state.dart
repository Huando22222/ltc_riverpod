import 'package:flutter/foundation.dart';

@immutable
class RegisterFormState {
  final String username;
  final String phone;
  final String password;
  final String confirmPassword;
  final String email;

  final String? usernameError;
  final String? phoneError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? emailError;
  final String? errorMessage;
  final bool isSubmitting;

  /// true  → validate realtime ngay khi gõ (onChanged)
  /// false → chỉ validate khi bấm submit (validateAll)
  final bool validateOnChange;

  const RegisterFormState({
    this.username = '',
    this.phone = '',
    this.password = '',
    this.confirmPassword = '',
    this.email = '',
    this.usernameError,
    this.phoneError,
    this.passwordError,
    this.confirmPasswordError,
    this.emailError,
    this.errorMessage,
    this.isSubmitting = false,
    this.validateOnChange = true,
  });

  bool get isValid =>
      usernameError == null &&
      phoneError == null &&
      passwordError == null &&
      confirmPasswordError == null &&
      emailError == null &&
      username.isNotEmpty &&
      phone.isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty;

  // ── Sentinel: phân biệt "không truyền" vs "truyền null có chủ đích" ────────
  static const _keep = Object();

  RegisterFormState copyWith({
    String? username,
    String? phone,
    String? password,
    String? confirmPassword,
    String? email,
    bool? isSubmitting,
    bool? validateOnChange,
    // Object? cho phép truyền null để XÓA lỗi
    Object? usernameError = _keep,
    Object? phoneError = _keep,
    Object? errorMessage = _keep,
    Object? passwordError = _keep,
    Object? confirmPasswordError = _keep,
    Object? emailError = _keep,
  }) {
    return RegisterFormState(
      username: username ?? this.username,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      email: email ?? this.email,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      validateOnChange: validateOnChange ?? this.validateOnChange,
      usernameError: identical(usernameError, _keep)
          ? this.usernameError
          : usernameError as String?,
      phoneError: identical(phoneError, _keep)
          ? this.phoneError
          : phoneError as String?,
      passwordError: identical(passwordError, _keep)
          ? this.passwordError
          : passwordError as String?,
      confirmPasswordError: identical(confirmPasswordError, _keep)
          ? this.confirmPasswordError
          : confirmPasswordError as String?,
      emailError: identical(emailError, _keep)
          ? this.emailError
          : emailError as String?,
      errorMessage: identical(errorMessage, _keep)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
