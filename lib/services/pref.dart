import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static final Prefs _instance = Prefs._();

  Prefs._();

  static Prefs get instance => _instance;

  String userEmailPref = 'user-email-pref';
  String userPasswordPref = 'user-password-pref';
  String userPinPref = 'user-pin-pref';
  String isUserLoggedInPref = 'is-user-loggedin-pref';
  String userIdPref = 'user-id-pref';
  String userRoomPref = 'user-room-pref';
  String loginTokenPref = 'login-token-pref';

  Future<SharedPreferences> _init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  setString(String key, String value) async {
    var pref = await _init();
    pref.setString(key, value);
  }

  setBool(String key, bool value) async {
    var pref = await _init();
    pref.setBool(key, value);
  }

  setInt(String key, int value) async {
    var pref = await _init();
    pref.setInt(key, value);
  }

  Future<String> getString(String key) async {
    var pref = await _init();
    return pref.getString(key) ?? "";
  }

  Future<bool> getBool(String key) async {
    var pref = await _init();
    return pref.getBool(key) ?? false;
  }

  Future<int> getInt(String key) async {
    var pref = await _init();
    return pref.getInt(key) ?? 0;
  }

  Future clear() async {
    var pref = await _init();
    pref.clear();
  }

  setUserPrefs(
    bool isLoggedIn,
  ) async {
    await setBool(isUserLoggedInPref, isLoggedIn);
  }
}
