import 'package:ltc/core/constants/pref_constants.dart';
import 'package:ltc/features/auth/data/models/user_model.dart';
import 'package:ltc/features/auth/domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  Future<UserEntity?> getUser() async {
    final userStr = _prefs.getString(PrefConstants.profile);
    if (userStr == null) {
      return null;
    }
    return UserModel.fromRawJson(userStr);
  }

  Future<String> getLocale() async {
    return _prefs.getString(PrefConstants.appLocale) ?? 'vi';
  }

  Future<String> getTheme() async {
    return _prefs.getString(PrefConstants.themeMode) ?? 'system';
  }

  String? getString(String key) => _prefs.getString(key);

  Future<void> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  Future<void> remove(String key) {
    return _prefs.remove(key);
  }
}
