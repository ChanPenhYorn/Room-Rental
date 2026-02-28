import 'dart:async';
import 'package:dwellly_client/room_rental_client.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Client _client;
  final FlutterAuthSessionManager _authSessionManager;
  final _authStateController = StreamController<UserInfo?>.broadcast();

  AuthRepositoryImpl(this._client, this._authSessionManager) {
    // Listen to the new auth manager's listenable for state changes.
    _authSessionManager.authInfoListenable.addListener(_onAuthStateChanged);
    // Initial check
    _onAuthStateChanged();
  }

  Future<void> _onAuthStateChanged() async {
    final authInfo = _authSessionManager.authInfo;
    if (authInfo == null) {
      _authStateController.add(null);
      return;
    }

    try {
      // Use our custom UUID-safe getMyProfile instead of built-in getUserInfo
      // which crashes on the server when userIdentifiers are UUIDs.
      final user = await _client.auth.getMyProfile();
      if (user != null && user.userInfo != null) {
        _authStateController.add(user.userInfo);
      } else {
        // If profile doesn't exist yet, fallback to basic info
        _authStateController.add(_basicUserInfo(authInfo));
      }
    } catch (e) {
      // Fallback if server call fails
      _authStateController.add(_basicUserInfo(authInfo));
    }
  }

  UserInfo _basicUserInfo(AuthSuccess authInfo) {
    return UserInfo(
      id: null, // UserInfo.id is int?, authInfo.authUserId is UuidValue
      userIdentifier: authInfo.authUserId.toString(),
      userName: authInfo.authUserId.toString(),
      fullName: authInfo.authUserId.toString(),
      created: DateTime.now(),
      scopeNames: authInfo.scopeNames.toList(),
      blocked: false,
    );
  }

  @override
  Future<UserInfo?> login(String email, String password) async {
    try {
      print('AuthRepo: Attempting login for $email');

      // 1. Call emailIdp.login() to verify credentials and get the AuthSuccess object.
      final authSuccess = await _client.emailIdp.login(
        email: email,
        password: password,
      );

      print('AuthRepo: Login succeeded, authUserId: ${authSuccess.authUserId}');

      // 2. IMPORTANT: Update the session manager.
      // This persists the token and configures the client's authentication key manager.
      // 2. IMPORTANT: Update the session manager.
      // This persists the token and configures the client's authentication key manager.
      await _authSessionManager.updateSignedInUser(authSuccess);

      print(
        'AuthRepo: Session registered. IsAuthenticated: ${_authSessionManager.isAuthenticated}',
      );

      return _basicUserInfo(authSuccess);
    } catch (e, stack) {
      print('AuthRepo: Login exception: $e');
      print(stack);
      rethrow;
    }
  }

  @override
  Future<UuidValue> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    try {
      final accountRequestId = await _client.emailIdp.startRegistration(
        email: email,
      );
      return accountRequestId;
    } catch (e) {
      print('AuthRepo: Signup failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _authSessionManager.signOutDevice();
      print('AuthRepo: Logged out successfully');
    } catch (e) {
      print('AuthRepo: Logout error: $e');
      rethrow;
    }
  }

  @override
  Future<UserInfo?> getCurrentUser() async {
    // Just return what the session manager has.
    // Use restore() at app startup in main.dart, not here.
    final authInfo = _authSessionManager.authInfo;
    if (authInfo != null) {
      return _basicUserInfo(authInfo);
    }
    return null;
  }

  /// Get an authenticated client for making API calls
  @override
  Client get authenticatedClient => _client;

  @override
  Stream<UserInfo?> get authStateChanges => _authStateController.stream;

  @override
  Future<User?> updateProfile(User user, {String? imageBase64}) async {
    try {
      print('AuthRepo: Updating profile for user ${user.id}...');
      final updatedUser = await _client.auth.updateProfile(
        user,
        imageBase64: imageBase64,
      );
      if (updatedUser != null) {
        print('AuthRepo: Profile updated successfully.');
        // Refresh session to get updated UserInfo (imageUrl)
        await _authSessionManager.validateAuthentication();
        await _onAuthStateChanged();
      } else {
        print('AuthRepo: Profile update returned null.');
      }
      return updatedUser;
    } catch (e) {
      print('AuthRepo: Profile update error: $e');
      return null;
    }
  }

  void dispose() {
    _authSessionManager.authInfoListenable.removeListener(_onAuthStateChanged);
    _authStateController.close();
  }
}
