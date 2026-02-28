import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserInfo?> execute(String email, String password) async {
    // Basic validation could happen here
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password cannot be empty');
    }
    return await repository.login(email, password);
  }
}
