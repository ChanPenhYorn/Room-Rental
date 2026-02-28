import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:dwellly_client/room_rental_client.dart';
import 'package:flutter/material.dart';
import 'shared/widgets/connection_error_dialog.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/network/api_client_provider.dart';
import 'core/theme/app_theme.dart';

import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/providers/auth_providers.dart';

/// Global client used to talk to the server.
late final Client client;

/// Global navigator key for showing dialogs without context.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// The new Serverpod 3.3 session manager (replaces the old SessionManager).
late final FlutterAuthSessionManager authSessionManager;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final serverUrl = await getServerUrl();
  print('🌐 [INIT] Server URL: $serverUrl');

  // 1. Create the new session manager.
  //    It uses SecureClientAuthSuccessStorage internally (flutter_secure_storage).
  authSessionManager = FlutterAuthSessionManager();

  // 2. Create the client with FlutterAuthenticationKeyManager.
  //    This reads the token saved by the session manager.
  client = Client(
    serverUrl,
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
    onSucceededCall: (context) {
      print('🚀 [API SUCCESS] ${context.endpointName}.${context.methodName}');
    },
    onFailedCall: (context, error, stackTrace) {
      print('❌ [API FAILURE] ${context.endpointName}.${context.methodName}');
      print('   Error: $error');

      // Handle connection errors globally
      if (error is SocketException || error is ServerpodClientException) {
        showConnectionErrorDialog();
      }
    },
  )..connectivityMonitor = FlutterConnectivityMonitor();

  // 3. Connect Session Manager to Client
  client.authSessionManager = authSessionManager;

  // 4. Restore any persisted session from secure storage.
  await authSessionManager.restore();

  // 5. Wait a bit for session to be fully initialized (helps with iOS simulator)
  await Future.delayed(const Duration(milliseconds: 500));

  // 6. Validate session early to catch issues
  try {
    final isValid = await authSessionManager.validateAuthentication();
    print('🔍 [INIT] Session validation result: $isValid');
    if (!isValid) {
      print('⚠️ [INIT] Session invalid, will require re-login');
    }
  } catch (e) {
    print('⚠️ [INIT] Session validation failed: $e');
  }

  print('✅ [INIT] Client and FlutterAuthSessionManager initialized');

  runApp(
    ProviderScope(
      overrides: [
        apiClientProvider.overrideWithValue(client),
        authRepositoryProvider.overrideWith(
          (ref) => AuthRepositoryImpl(client, authSessionManager),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Dwellly',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

bool _isDialogShowing = false;

void showConnectionErrorDialog() {
  if (_isDialogShowing) return;

  final context = navigatorKey.currentContext;
  if (context == null) return;

  _isDialogShowing = true;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const ConnectionErrorDialog(),
  ).then((_) {
    _isDialogShowing = false;
  });
}

Future<String> getServerUrl() async {
  try {
    final configString = await rootBundle.loadString('assets/config.json');
    final config = jsonDecode(configString);
    return config['apiUrl'] ?? 'http://localhost:8080/';
  } catch (e) {
    return 'http://localhost:8080/';
  }
}
