import 'package:shared_preferences/shared_preferences.dart';

enum PreferencesNames {
  check_login,
  check_account_auth,
  check_account_data_completed,
  check_email_verified,
  check_halaqa_created,
  email
}

class MySharedPreferences {
  static final MySharedPreferences _instance = MySharedPreferences._internal();

  factory MySharedPreferences() {
    return _instance;
  }
  // Map<String, dynamic> preferencesNames = {
  //   'check_login': 'login',
  //   'check_account_auth': 'account_auth',
  //   'check_account_data_completed': 'account_data_completed',
  //   'check_onboarding_completed': 'onboarding_completed',
  //   'check_email_verified': 'email_verified',
  //   'check_halaqa_created': 'halaqa_created',
  // };
  MySharedPreferences._internal();

  SharedPreferences? _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> setString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  Set<String>? getAllKeys() {
    return _preferences?.getKeys();
  }

  String? getString(String key) {
    return _preferences?.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  static Future<void> logout() async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();

    MySharedPreferences()
        .setBool(PreferencesNames.check_account_auth.name, false);
    MySharedPreferences()
        .setBool(PreferencesNames.check_account_data_completed.name, false);
    MySharedPreferences()
        .setBool(PreferencesNames.check_email_verified.name, false);
    MySharedPreferences()
        .setBool(PreferencesNames.check_halaqa_created.name, false);
    MySharedPreferences().setBool(PreferencesNames.check_login.name, false);

  }
}
