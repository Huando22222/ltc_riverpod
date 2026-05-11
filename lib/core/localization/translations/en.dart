import 'package:flutter/src/material/time.dart';
import 'package:intl/intl.dart';
import 'package:ltc/common/util/date_time_util.dart';
import 'package:ltc/core/localization/app_strings.dart';

class EnStrings extends AppStrings {
  EnStrings();

  static const _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static const _short = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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
  @override
  String get account => 'Account';
  @override
  String get booking => 'Booking';
  @override
  String get changePassword => 'ChangePassword';
  @override
  String get darkMode => 'DarkMode';
  @override
  String get language => 'Language';
  @override
  String get languageName => 'LanguageName';
  @override
  String get notification => 'Notification';
  @override
  String get preferences => 'Preferences';
  @override
  String get security => 'Security';
  @override
  String get setting => 'Setting';

  @override
  String get contactSupport => 'Contact support';
  @override
  String get editProfile => 'Edit profile';
  @override
  String get privacyPolicy => 'Privacy policy';
  @override
  String get support => 'Support';
  @override
  String get termOfUse => 'Term Of Use';
  @override
  String get guestSubtitle => 'View profile, medical history and more';
  @override
  String get loginToContinue => 'Sign in to continue';
  @override
  String get serviceBooking => 'Service booking';
  @override
  String get specialtyBooking => 'Specialty booking';
  @override
  String get consultation => 'Consultation';
  @override
  String get emergency => 'Emergency';
  @override
  String get labTest => 'Test';
  @override
  String get lookup => 'Lookup';
  @override
  String get medication => 'Med';
  @override
  String get specialty => 'Specialty';
  @override
  String get all => 'All';
  @override
  String get service => 'Service';
  @override
  String get package => 'Package';
  @override
  String get packageBooking => 'Package booking';
  @override
  String get loginRequiredTitle => 'Login required';
  @override
  String loginRequiredSubtitle(String? featureName) {
    if (featureName != null) {
      return 'You need to log in to use "$featureName".';
    }
    return 'Log in to fully experience your healthcare features.';
  }

  @override
  String get loginNow => 'Login now';
  @override
  String get createAccount => 'Create account';
  @override
  String get skipContinue => 'Skip and continue';
  @override
  String get benefitBooking => 'Book appointments & track results';
  @override
  String get benefitHealthRecord => 'Store personal health records';
  @override
  String get benefitMore => 'And many feature more';
  @override
  String get monday => 'Monday';
  @override
  String get tuesday => 'Tuesday';
  @override
  String get wednesday => 'Wednesday';
  @override
  String get thursday => 'Thursday';
  @override
  String get friday => 'Friday';
  @override
  String get saturday => 'Saturday';
  @override
  String get sunday => 'Sunday';

  @override
  String get monShort => 'Mon';
  @override
  String get tueShort => 'Tue';
  @override
  String get wedShort => 'Wed';
  @override
  String get thuShort => 'Thu';
  @override
  String get friShort => 'Fri';
  @override
  String get satShort => 'Sat';
  @override
  String get sunShort => 'Sun';

  @override
  String get morning => 'Morning';
  @override
  String get afternoon => 'Afternoon';

  @override
  String shortWeekday(int w) => _short[w];
  @override
  String dayLabel(DateTime d) =>
      DateTimeUtil.isToday(d) ? 'Today' : shortWeekday(d.weekday);

  @override
  String bookingSummary(DateTime? d, TimeOfDay? t) {
    if (d == null && t == null) return '';
    if (d == null) return DateTimeUtil.formatTimeOfDay(t!);
    if (t == null) {
      return '${weekdayName(d.weekday)}, ${DateFormat('MM/dd/yyyy').format(d)}';
    }
    return '${weekdayName(d.weekday)}, ${DateFormat('MM/dd/yyyy').format(d)} · ${DateTimeUtil.formatTimeOfDay(t)}';
  }

  @override
  String weekdayName(int w) => _weekdays[w];
  @override
  String get january => 'January';
  @override
  String get february => 'February';
  @override
  String get march => 'March';
  @override
  String get april => 'April';
  @override
  String get may => 'May';
  @override
  String get june => 'June';
  @override
  String get july => 'July';
  @override
  String get august => 'August';
  @override
  String get september => 'September';
  @override
  String get october => 'October';
  @override
  String get november => 'November';
  @override
  String get december => 'December';

  @override
  String get janShort => 'Jan';
  @override
  String get febShort => 'Feb';
  @override
  String get marShort => 'Mar';
  @override
  String get aprShort => 'Apr';
  @override
  String get mayShort => 'May';
  @override
  String get junShort => 'Jun';
  @override
  String get julShort => 'Jul';
  @override
  String get augShort => 'Aug';
  @override
  String get sepShort => 'Sep';
  @override
  String get octShort => 'Oct';
  @override
  String get novShort => 'Nov';
  @override
  String get decShort => 'Dec';

  @override
  String monthName(int m) => [
    january,
    february,
    march,
    april,
    may,
    june,
    july,
    august,
    september,
    october,
    november,
    december,
  ][m];

  @override
  String shortMonth(int m) => [
    janShort,
    febShort,
    marShort,
    aprShort,
    mayShort,
    junShort,
    julShort,
    augShort,
    sepShort,
    octShort,
    novShort,
    decShort,
  ][m];
  @override
  String get pickDate => 'Select date';
  @override
  String get pickTime => 'Select time';
  @override
  String get pickDateAndTime => 'Select date and time slot';
  @override
  String get today => 'Today';
  @override
  String get next => 'Next';
  @override
  String get patientInfo => 'Patient information';
  @override
  String get fillPatientInfo => 'Fill in patient details';
  @override
  String get confirmBooking => 'Confirm booking';
  @override
  String get checkAndConfirm => 'Review and confirm your information';
  @override
  String get bookingSuccess => 'Booking confirmed';
  @override
  String get estimatedFee => 'Estimated fee';
  @override
  String get editService => 'Edit services';
  @override
  String get free => 'Free';
  @override
  String get pickService => 'Select services';
  @override
  String selectedServiceCount(int count) =>
      '$count service${count > 1 ? 's' : ''} selected';
}
