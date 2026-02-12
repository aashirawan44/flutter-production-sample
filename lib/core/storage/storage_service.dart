import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageService {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<bool> containsKey(String key);
  Future<void> clearAll();
}

class SecureStorageServiceImpl implements StorageService {
  final FlutterSecureStorage _storage;

  SecureStorageServiceImpl(this._storage);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<bool> containsKey(String key) => _storage.containsKey(key: key);

  @override
  Future<void> clearAll() => _storage.deleteAll();
}

class SharedPreferencesServiceImpl implements StorageService {
  final SharedPreferences _prefs;

  SharedPreferencesServiceImpl(this._prefs);

  @override
  Future<void> write(String key, String value) => _prefs.setString(key, value);

  @override
  Future<String?> read(String key) async => _prefs.getString(key);

  @override
  Future<void> delete(String key) => _prefs.remove(key);

  @override
  Future<bool> containsKey(String key) async => _prefs.containsKey(key);

  @override
  Future<void> clearAll() => _prefs.clear();
}
