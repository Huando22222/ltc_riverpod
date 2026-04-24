abstract class AppStrings {
  // MARK: App
  String get appName;
  String get appTagline;
  // MARK: Auth
  String get login;
  String get logout;
  String get register;
  String get username;
  String get password;
  String get forgotPassword;
  String get noAccountMessage;
  String get loginInstruction;
  String get loginFailed;

  // MARK: Common
  String get save;
  String get cancel;
  String get loading;
  String get error;
  String get changeLanguage;
  String get viewAll;

  // MARK: Shell
  String get home;
  String get document;
  String get health;
  String get profile;

  // MARK: Dashboard
  String get features;
  String get doctors;
  String get packages;
  String get testServices;
  String get medicalTopics;
  String get explore;

  // MARK: Dynamic
  String welcome(String name);
  String required(String field);
}
