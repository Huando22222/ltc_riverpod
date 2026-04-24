import 'package:ltc/core/localization/app_strings.dart';

class EnStrings extends AppStrings {
  EnStrings();

  @override
  String get appName => 'LTC';
  @override
  String get appTagline => 'Healthcare Management Solution';

  @override
  String get login => 'Login';
  @override
  String get logout => 'Logout';
  @override
  String get username => 'Username';
  @override
  String get password => 'Password';
  @override
  String get loginFailed => 'Login failed';
  @override
  String get forgotPassword => 'Forgot Password?';
  @override
  String get loginInstruction => 'Please enter your credentials to log in.';
  @override
  String get noAccountMessage => 'Don\'t have an account?';
  @override
  String get register => 'Register';

  @override
  String get save => 'Save';
  @override
  String get cancel => 'Cancel';
  @override
  String get loading => 'Loading...';
  @override
  String get error => 'An error occurred';
  @override
  String get changeLanguage => 'Change language';

  @override
  String get home => 'Home';
  @override
  String get document => 'Documents';
  @override
  String get health => 'Health';
  @override
  String get profile => 'Profile';

  @override
  String welcome(String name) => 'Hello, $name';
  @override
  String required(String field) => '$field is required';

  @override
  String get doctors => 'Doctors';

  @override
  String get features => 'Features';

  @override
  String get medicalTopics => 'Medical Topics';

  @override
  String get packages => 'Packages';

  @override
  String get testServices => 'Test Services';

  @override
  String get viewAll => 'View All';

  @override
  String get explore => 'Explore';
}
