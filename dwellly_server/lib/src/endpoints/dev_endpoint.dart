import 'package:serverpod/serverpod.dart';
import '../utils/test_utils.dart';

class DevEndpoint extends Endpoint {
  /// Retreive the last generated verification code for [email] for testing purposes.
  Future<String?> getRegistrationCode(Session session, String email) async {
    return TestUtils.verificationCodes[email];
  }
}
