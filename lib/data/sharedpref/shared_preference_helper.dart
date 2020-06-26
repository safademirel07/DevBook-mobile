import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class SharedPreferenceHelper {
  static Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  static Future<String> getString(String key) async {
    final p = await prefs;
    return p.getString(key) ?? '';
  }

  static Future setString(String key, String value) async {
    final p = await prefs;
    return p.setString(key, value);
  }

  static Future<String> get getAuthToken => getString(Constants.auth_token);
  static Future setAuthToken(String value) =>
      setString(Constants.auth_token, value);

  static Future<String> get getUID => getString(Constants.uid_token);
  static Future setUID(String value) => setString(Constants.uid_token, value);

  static Future<String> get getUser => getString(Constants.user_token);
  static Future setUser(String value) {
    setString(Constants.user_token, value);
  }

  static Future<String> get getPassword => getString(Constants.password_token);
  static Future setPassword(String value) =>
      setString(Constants.password_token, value);
}
