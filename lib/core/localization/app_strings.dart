import 'package:flutter/material.dart';

abstract class AppStrings {
  // MARK: APP
  String get appName;
  String get appTagline;
  // MARK: AUTH
  String get login;
  String get logout;
  String get register;
  String get username;
  String get password;
  String get forgotPassword;
  String get noAccountMessage;
  String get loginInstruction;
  String get loginFailed;
  String get changePassword;
  String get editProfile;
  String get loginToContinue;
  String get guestSubtitle;

  String get loginRequiredTitle;
  String loginRequiredSubtitle(String? featureName);
  String get loginNow;
  String get createAccount;
  String get skipContinue;
  String get benefitBooking;
  String get benefitHealthRecord;
  String get benefitMore;
  // MARK: COMMON
  String get save;
  String get cancel;
  String get loading;
  String get error;
  String get changeLanguage;
  String get all;
  String get viewAll;
  String get setting;
  String get account;
  String get notification;
  String get security;
  String get preferences;
  String get darkMode;
  String get language;
  String get languageName;
  String get support;
  String get contactSupport;
  String get privacyPolicy;
  String get termOfUse;
  // MARK: SHELL
  String get home;
  String get document;
  String get health;
  String get profile;

  // MARK: DASHBOARD
  String get features;
  String get doctors;
  String get packages;
  String get testServices;
  String get medicalTopics;
  String get explore;

  String get specialty;
  String get consultation;
  String get labTest;
  String get medication;
  String get emergency;
  String get lookup;

  // MARK: BOOKING
  String get booking;
  String get package;
  String get service;
  String get serviceBooking;
  String get packageBooking;
  String get specialtyBooking;
  String get patientInfo;
  String get fillPatientInfo;
  String get confirmBooking;
  String get checkAndConfirm;
  String get bookingSuccess;
  String get estimatedFee;
  String get editService;
  String get free;
  String get pickService;
  String get pickDate;
  String get pickTime;
  String get pickDateAndTime;
  String get today;
  String get next;
  // MARK: DATETIME
  String get monday;
  String get tuesday;
  String get wednesday;
  String get thursday;
  String get friday;
  String get saturday;
  String get sunday;

  String get monShort;
  String get tueShort;
  String get wedShort;
  String get thuShort;
  String get friShort;
  String get satShort;
  String get sunShort;

  String get january;
  String get february;
  String get march;
  String get april;
  String get may;
  String get june;
  String get july;
  String get august;
  String get september;
  String get october;
  String get november;
  String get december;

  String get janShort;
  String get febShort;
  String get marShort;
  String get aprShort;
  String get mayShort;
  String get junShort;
  String get julShort;
  String get augShort;
  String get sepShort;
  String get octShort;
  String get novShort;
  String get decShort;

  String get morning;
  String get afternoon;

  String selectedServiceCount(int count);
  String monthName(int month);
  String shortMonth(int month);
  String weekdayName(int weekday);
  String shortWeekday(int weekday);
  String dayLabel(DateTime date); // tự handle "Hôm nay" / "Today" bên trong
  String bookingSummary(DateTime? date, TimeOfDay? time);
  // MARK: DYNAMIC
  String welcome(String name);
  String required(String field);
}
