abstract class AppStrings {
  // MARK: App
  String get appName;
  String get appTagline;
  // MARK: Auth
  String get authLogin;
  String get authLogout;
  String get authRegister;
  String get authUsername;
  String get authPassword;
  String get authForgotPassword;
  String get authNoAccountMessage;
  String get authLoginInstruction;
  String get authLoginFailed;

  // MARK: Common
  String get commonSave;
  String get commonCancel;
  String get commonLoading;
  String get commonError;
  String get commonChangeLanguage;

  // MARK: Dynamic
  String welcome(String name);
  String required(String field);
}
