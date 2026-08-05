import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalStorage {
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserId = 'user_id';

  final SharedPreferences _prefs;

  AuthLocalStorage(this._prefs);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _prefs.setString(_keyAccessToken, accessToken);
    await _prefs.setString(_keyRefreshToken, refreshToken);
  }

  Future<void> saveUserInfo({
    required String userId,
    required String userEmail,
  }) async {
    await _prefs.setString(_keyUserId, userId);
    await _prefs.setString(_keyUserEmail, userEmail);
  }

  String? getAccessToken() {
    return _prefs.getString(_keyAccessToken);
  }

  String? getRefreshToken() {
    return _prefs.getString(_keyRefreshToken);
  }

  String? getUserEmail() {
    return _prefs.getString(_keyUserEmail);
  }

  String? getUserId() {
    return _prefs.getString(_keyUserId);
  }

  bool get hasValidToken => getAccessToken() != null && getAccessToken()!.isNotEmpty;

  Future<void> clearSession() async {
    await _prefs.remove(_keyAccessToken);
    await _prefs.remove(_keyRefreshToken);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserId);
  }
}
