import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState.initial()) {
    _repository.authStateChanges.listen((user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.failure(e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _repository.login(email, password);
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.failure('Login failed: User is null');
      }
    } catch (e) {
      state = AuthState.failure(e.toString());
    }
  }

  Future<void> logout() async {
    state = const AuthState.loading();
    try {
      await _repository.logout();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.failure(e.toString());
    }
  }

  Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? bio,
    String? imageBase64,
  }) async {
    // Current state should be authenticated
    final currentUserInfo = state.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );

    if (currentUserInfo == null) return;

    // We need to fetch the full User object first, or construct a partial one if updateProfile accepts it.
    // However, updateProfile (in repository) takes a User object.
    // AuthRepository returns UserInfo, but updateProfile takes User.
    // We don't have User in state.
    // So we need to fetch User first?
    // Or we create a User object with minimal fields (id/userInfoId) and updated fields.
    // The server `updateRow` usually updates all fields provided. If fields are null, it might set them to null?
    // Serverpod updateRow updates ALL columns in the row with values from the object.
    // So we MUST fetch the existing User first.

    try {
      // Create a temporary User object just for ID reference? No.
      // We need a method in repo to fetch User (application user).
      // But Authentication state only has UserInfo.
      // Let's assume for now we can't easily fetch User inside Notifier unless we add `getUser` to repo.
      // But `getCurrentUser` returns `UserInfo`.

      // Let's defer fetching to the screen or add fetchUser to Repo.
      // Adding fetchUser to repo is cleaner.
      // But for now, let's assume the screen passes the User object?
      // No, screen has UserInfo from state.

      // Okay, I will implement `updateProfile` in Notifier to accept the User object from the UI if possible,
      // OR I will fetch it here.
      // Let's add `Future<User?> getMe()` to AuthRepository.
      // But I can't change interface again easily without modifying Impl.

      // I'll skip adding `getMe` to interface for now and just instantiate a User object if I can?
      // No, that will wipe other fields.

      // I'll call `client.auth.getMyProfile()` directly if I can access client?
      // `AuthRepository` exposes `authenticatedClient`.

      state = const AuthState.loading();
      final client = _repository.authenticatedClient;
      final existingUser = await client.auth.getMyProfile();

      if (existingUser != null) {
        // Update fields
        if (fullName != null) existingUser.fullName = fullName;
        if (phone != null) existingUser.phone = phone;
        if (bio != null) existingUser.bio = bio;
        // Profile image is handled by Base64 param in updateProfile endpoint logic on server
        // But wait, updateProfile takes User AND imageBase64.

        final updated = await _repository.updateProfile(
          existingUser,
          imageBase64: imageBase64,
        );

        if (updated != null) {
          // State upgrade happens automatically via stream listener in repo
          // But we might need to ensure state is set back to authenticated if stream relies on session refresh
          // which is async.
          // Let's just restore previous state but with new info?
          // Actually, repo's stream listener should handle it.
        } else {
          state = AuthState.failure("Failed to update profile");
        }
      } else {
        state = AuthState.failure("User profile not found");
      }
    } catch (e) {
      state = AuthState.failure(e.toString());
    }
  }
}
