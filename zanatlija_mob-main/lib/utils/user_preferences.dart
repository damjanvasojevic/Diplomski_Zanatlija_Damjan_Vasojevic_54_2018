import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  UserPreferences._privateConstructor();

  static final UserPreferences _instance =
      UserPreferences._privateConstructor();

  static UserPreferences get instance => _instance;

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> saveUserCredentials(String username, String password) async {
    await _prefs?.setString('username', username);
    await _prefs?.setString('password', password);
  }

  String? getUsername() {
    return _prefs?.getString('username');
  }

  String? getPassword() {
    return _prefs?.getString('password');
  }

  Future<void> clearCredentials() async {
    await _prefs?.remove('username');
    await _prefs?.remove('password');
  }
}
