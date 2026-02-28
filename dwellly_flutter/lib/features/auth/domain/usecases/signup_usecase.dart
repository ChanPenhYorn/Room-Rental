import 'package:dwellly_client/room_rental_client.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<UuidValue> execute({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    return await repository.signUp(
      email: email,
      password: password,
      fullName: fullName,
      role: role,
    );
  }
}
