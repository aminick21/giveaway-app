import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const _tokenKey = 'idToken';
  static const _storage = FlutterSecureStorage();

  // Function to save the token securely
  static Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      print('Error saving token: $e');
    }
  }

  // Function to retrieve the token from storage
  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      print('Error retrieving token: $e');
      return null;
    }
  }

  // Function to delete the token from storage
  static Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _tokenKey);
      print('delete successful');
    } catch (e) {
      print('Error deleting token: $e');
    }

  }

}
