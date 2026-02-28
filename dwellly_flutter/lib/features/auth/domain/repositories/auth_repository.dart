import 'package:dwellly_client/room_rental_client.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';

abstract class AuthRepository {
  Future<UserInfo?> login(String email, String password);
  Future<UuidValue> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  });
  Future<void> logout();
  Future<UserInfo?> getCurrentUser();
  Future<User?> updateProfile(User user, {String? imageBase64});
  Stream<UserInfo?> get authStateChanges;
  Client get authenticatedClient;
}
