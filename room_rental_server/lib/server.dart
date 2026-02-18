import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';
import 'src/web/routes/app_config_route.dart';
import 'src/web/routes/root.dart';
import 'src/utils/test_utils.dart';
import 'src/utils/seeder.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  final bool forceSeed = args.contains('--force-seed');
  final serverpodArgs = args.where((arg) => arg != '--force-seed').toList();

  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(serverpodArgs, Protocol(), Endpoints());

  // Initialize authentication services for the server.
  // Token managers will be used to validate and issue authentication keys,
  // and the identity providers will be the authentication options available for users.
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Use JWT for authentication keys towards the server.
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      // Configure the email identity provider for email/password authentication.
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode: _sendRegistrationCode,
        sendPasswordResetVerificationCode: _sendPasswordResetCode,
      ),
    ],
  );

  // Setup a default page at the web root.
  // These are used by the default page.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');

  // Serve all files in the web/static relative directory under /.
  // These are used by the default web page.
  final root = Directory(Uri(path: 'web/static').toFilePath());
  pod.webServer.addRoute(StaticRoute.directory(root));

  // Setup the app config route.
  // We build this configuration based on the servers api url and serve it to
  // the flutter app.
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/app/assets/assets/config.json',
  );

  // Checks if the flutter web app has been built and serves it if it has.
  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    // Serve the flutter web app under the /app path.
    pod.webServer.addRoute(
      FlutterRoute(
        Directory(
          Uri(path: 'web/app').toFilePath(),
        ),
      ),
      '/app',
    );
  } else {
    // If the flutter web app has not been built, serve the build app page.
    pod.webServer.addRoute(
      StaticRoute.file(
        File(
          Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
        ),
      ),
      '/app/**',
    );
  }

  // Start the server.
  await pod.start();

  // Seed default data
  final session = await pod.createSession();
  try {
    await DataSeeder.seed(session, force: forceSeed);
  } catch (e, stack) {
    session.log(
      'Error during seeding: $e',
      level: LogLevel.error,
      stackTrace: stack,
    );
  } finally {
    await session.close();
  }
}

void _sendRegistrationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) async {
  // Store code for dev access
  print('DEV_MODE: Storing verification code for $email: $verificationCode');
  TestUtils.verificationCodes[email] = verificationCode;

  session.log(
    '[EmailIdp] Sending registration code to $email: $verificationCode',
  );

  try {
    await _sendEmail(
      session: session,
      to: email,
      subject: 'Verify your Room Rental account',
      body:
          '''
<!DOCTYPE html>
<html>
<head>
  <style>
    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
    .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }
    .code { background: #667eea; color: white; font-size: 32px; font-weight: bold; padding: 20px; text-align: center; border-radius: 8px; letter-spacing: 8px; margin: 20px 0; }
    .footer { text-align: center; margin-top: 20px; color: #666; font-size: 12px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>Welcome to Room Rental!</h1>
    </div>
    <div class="content">
      <p>Hi there,</p>
      <p>Thank you for signing up! Please use the verification code below to complete your registration:</p>
      <div class="code">$verificationCode</div>
      <p>This code will expire in 10 minutes.</p>
      <p>If you didn't request this code, please ignore this email.</p>
    </div>
    <div class="footer">
      <p>© 2026 Room Rental. All rights reserved.</p>
    </div>
  </div>
</body>
</html>
      ''',
    );
    session.log('[EmailIdp] Successfully sent registration email to $email');
  } catch (e) {
    session.log(
      '[EmailIdp] Failed to send email to $email: $e',
      level: LogLevel.error,
    );
  }
}

void _sendPasswordResetCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) async {
  // Store code for dev access
  print('DEV_MODE: Storing password reset code for $email: $verificationCode');
  TestUtils.verificationCodes[email] = verificationCode;

  session.log(
    '[EmailIdp] Sending password reset code to $email: $verificationCode',
  );

  try {
    await _sendEmail(
      session: session,
      to: email,
      subject: 'Reset your Room Rental password',
      body:
          '''
<!DOCTYPE html>
<html>
<head>
  <style>
    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
    .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }
    .code { background: #667eea; color: white; font-size: 32px; font-weight: bold; padding: 20px; text-align: center; border-radius: 8px; letter-spacing: 8px; margin: 20px 0; }
    .footer { text-align: center; margin-top: 20px; color: #666; font-size: 12px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>Password Reset Request</h1>
    </div>
    <div class="content">
      <p>Hi there,</p>
      <p>We received a request to reset your password. Use the code below to proceed:</p>
      <div class="code">$verificationCode</div>
      <p>This code will expire in 10 minutes.</p>
      <p>If you didn't request this, please ignore this email and your password will remain unchanged.</p>
    </div>
    <div class="footer">
      <p>© 2026 Room Rental. All rights reserved.</p>
    </div>
  </div>
</body>
</html>
      ''',
    );
    session.log('[EmailIdp] Successfully sent password reset email to $email');
  } catch (e) {
    session.log(
      '[EmailIdp] Failed to send email to $email: $e',
      level: LogLevel.error,
    );
  }
}

Future<void> _sendEmail({
  required Session session,
  required String to,
  required String subject,
  required String body,
}) async {
  final smtpHost = session.passwords['smtpHost'];
  final smtpPort =
      int.tryParse(session.passwords['smtpPort'] ?? '2525') ?? 2525;
  final smtpUsername = session.passwords['smtpUsername'];
  final smtpPassword = session.passwords['smtpPassword'];
  final fromAddress =
      session.passwords['emailFromAddress'] ?? 'noreply@roomrental.com';
  final fromName = session.passwords['emailFromName'] ?? 'Room Rental';

  if (smtpHost == null || smtpUsername == null || smtpPassword == null) {
    session.log('SMTP credentials not configured', level: LogLevel.error);
    return;
  }

  final smtpServer = SmtpServer(
    smtpHost,
    port: smtpPort,
    username: smtpUsername,
    password: smtpPassword,
  );

  final message = mailer.Message()
    ..from = mailer.Address(fromAddress, fromName)
    ..recipients.add(to)
    ..subject = subject
    ..html = body;

  try {
    await mailer.send(message, smtpServer);
  } catch (e) {
    session.log('Error sending email: $e', level: LogLevel.error);
    rethrow;
  }
}
