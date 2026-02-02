import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// SharedPreferences wrapper for simple key-value storage
class PreferencesStorage {
  SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw StateError('PreferencesStorage not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // Onboarding
  bool get isOnboarded => _preferences.getBool(AppConstants.isOnboardedKey) ?? false;
  Future<void> setOnboarded(bool value) async {
    await _preferences.setBool(AppConstants.isOnboardedKey, value);
  }

  // Login state
  bool get isLoggedIn => _preferences.getBool(AppConstants.isLoggedInKey) ?? false;
  Future<void> setLoggedIn(bool value) async {
    await _preferences.setBool(AppConstants.isLoggedInKey, value);
  }

  // Theme
  String get themeMode => _preferences.getString(AppConstants.themeKey) ?? 'system';
  Future<void> setThemeMode(String value) async {
    await _preferences.setString(AppConstants.themeKey, value);
  }

  // Language
  String get language => _preferences.getString(AppConstants.languageKey) ?? 'en';
  Future<void> setLanguage(String value) async {
    await _preferences.setString(AppConstants.languageKey, value);
  }

  // Notifications
  bool get notificationsEnabled =>
      _preferences.getBool(AppConstants.notificationsKey) ?? true;
  Future<void> setNotificationsEnabled(bool value) async {
    await _preferences.setBool(AppConstants.notificationsKey, value);
  }

  // Generic getters/setters
  String? getString(String key) => _preferences.getString(key);
  Future<void> setString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  int? getInt(String key) => _preferences.getInt(key);
  Future<void> setInt(String key, int value) async {
    await _preferences.setInt(key, value);
  }

  bool? getBool(String key) => _preferences.getBool(key);
  Future<void> setBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  double? getDouble(String key) => _preferences.getDouble(key);
  Future<void> setDouble(String key, double value) async {
    await _preferences.setDouble(key, value);
  }

  List<String>? getStringList(String key) => _preferences.getStringList(key);
  Future<void> setStringList(String key, List<String> value) async {
    await _preferences.setStringList(key, value);
  }

  // Remove a key
  Future<void> remove(String key) async {
    await _preferences.remove(key);
  }

  // Clear all preferences (except important ones)
  Future<void> clearUserData() async {
    final isOnboarded = this.isOnboarded;
    await _preferences.clear();
    // Restore onboarding state
    await setOnboarded(isOnboarded);
  }
}
