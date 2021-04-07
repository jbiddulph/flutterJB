import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static final _storage = FlutterSecureStorage();
  static const _keyUsername = 'test';
  static const _keyUserId = '1';
  static const _keyUserEmail = 'test@test.com';

// get set profilename
  static Future setProfileName(String profileName) async =>
      await _storage.write(key: _keyUsername, value: profileName);

  static Future<String> getProfileName() async =>
      await _storage.read(key: _keyUsername);

// get set profileemail
  static Future setProfileEmail(String profileEmail) async =>
      await _storage.write(key: _keyUserEmail, value: profileEmail);

  static Future<String> getProfileEmail() async =>
      await _storage.read(key: _keyUserEmail);

// get set profileid
  static Future setProfileId(String profileId) async =>
      await _storage.write(key: _keyUserId, value: profileId);

  static Future<String> getProfileId() async =>
      await _storage.read(key: _keyUserId);
}
