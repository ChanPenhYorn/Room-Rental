import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

/// An implementation of [Storage] that uses [FlutterSecureStorage] for
/// persistence. This allows us to store both session info and authentication
/// keys in a secure way.
class SecureStorage implements Storage {
  final FlutterSecureStorage _storage;

  SecureStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<int?> getInt(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null ? int.tryParse(value) : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> getString(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> remove(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await _storage.write(key: key, value: value.toString());
  }

  @override
  Future<void> setString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
}

/// Uses the default Serverpod key manager which correctly formats the
/// Authorization header as "Basic <keyId:secret>" — the only format
/// Serverpod's server-side auth middleware understands.
class AppAuthenticationKeyManager extends FlutterAuthenticationKeyManager {
  AppAuthenticationKeyManager({super.runMode, super.storage});
}
