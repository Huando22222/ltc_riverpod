import 'package:ltc/core/localization/app_strings.dart';

class EnStrings extends AppStrings {
  EnStrings();

  @override
  String get appName => 'LTC';
  @override
  String get appTagline => 'Healthcare Management Solution';

  @override
  String get authLogin => 'Login';
  @override
  String get authLogout => 'Logout';
  @override
  String get authUsername => 'Username';
  @override
  String get authPassword => 'Password';
  @override
  String get authLoginFailed => 'Login failed';
  @override
  String get authForgotPassword => 'Forgot Password?';
  @override
  String get authLoginInstruction => 'Please enter your credentials to log in.';
  @override
  String get authNoAccountMessage => 'Don\'t have an account?';
  @override
  String get authRegister => 'Register';

  @override
  String get commonSave => 'Save';
  @override
  String get commonCancel => 'Cancel';
  @override
  String get commonLoading => 'Loading...';
  @override
  String get commonError => 'An error occurred';
  @override
  String get commonChangeLanguage => 'Change language';

  @override
  String welcome(String name) => 'Hello, $name';
  @override
  String required(String field) => '$field is required';
}
