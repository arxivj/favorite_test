import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  static Future<void> saveAuthToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  static Future<void> deleteAllTokens() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'refresh_token');
  }

  // 테마 모드 저장
  static Future<void> saveThemeMode(String themeMode) async {
    await _storage.write(key: 'theme_mode', value: themeMode);
  }

  // 테마 모드 불러오기
  static Future<String?> getThemeMode() async {
    return await _storage.read(key: 'theme_mode');
  }

  static Future<void> saveInterestList(String jsonString) async {
    await _storage.write(key: 'interestList', value: jsonString);
  }

  static Future<String?> readInterestList() async {
    return await _storage.read(key: 'interestList');
  }

}
