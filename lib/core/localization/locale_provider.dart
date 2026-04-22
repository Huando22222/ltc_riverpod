import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:ltc/core/constants/pref_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_strings.dart';
import 'translations/vi.dart';
import 'translations/en.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('vi'));

  // Gọi ở SplashScreen — khôi phục locale đã lưu
  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(PrefConstants.appLocale) ?? 'vi';
    state = Locale(code);
  }

  // Gọi khi nhấn nút đổi ngôn ngữ
  Future<void> changeLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefConstants.appLocale, locale.languageCode);
  }

  // Toggle nhanh Vi ↔ En
  Future<void> toggleLocale() async {
    final newLocale = state.languageCode == 'vi'
        ? const Locale('en')
        : const Locale('vi');
    await changeLocale(newLocale);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);

final stringsProvider = Provider<AppStrings>((ref) {
  final locale = ref.watch(localeProvider);
  return switch (locale.languageCode) {
    'en' => EnStrings(),
    _ => ViStrings(),
  };
});


// final s = ref.watch(stringsProvider);
// s.welcome(user.fullname)
// ref
//           .read(localeProvider.notifier)
//           .toggleLocale(), 