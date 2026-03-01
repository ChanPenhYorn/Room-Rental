import 'dart:convert';
import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:googleapis_auth/auth_io.dart';
import '../generated/protocol.dart';

class NotificationUtils {
  static const String _fcmUrl =
      'https://fcm.googleapis.com/v1/projects/dwellly-34ced/messages:send';

  static const String _serviceAccountPath =
      'config/dwellly-34ced-firebase-adminsdk-fbsvc-ff189a5bad.json';

  static AutoRefreshingAuthClient? _authClient;

  /// Sends a push notification to a specific user.
  static Future<bool> sendNotification(
    Session session, {
    required int recipientId,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      // 1. Persist notification in database
      await AppNotification.db.insertRow(
        session,
        AppNotification(
          userId: recipientId,
          title: title,
          body: body,
          data: data,
          isRead: false,
          createdAt: DateTime.now(),
        ),
      );

      // 2. Send push notification
      final recipient = await User.db.findById(session, recipientId);
      if (recipient == null) {
        session.log('FCM: Recipient $recipientId not found');
        return false;
      }

      if (recipient.fcmToken == null) {
        session.log(
          'FCM: User ${recipient.fullName} (id: ${recipient.id}) has no FCM token. Push skipped.',
        );
        return false;
      }

      return await _sendToToken(
        session,
        token: recipient.fcmToken!,
        title: title,
        body: body,
        data: data,
      );
    } catch (e) {
      session.log('FCM Error: $e', level: LogLevel.error);
      return false;
    }
  }

  /// Sends a notification to all admins.
  static Future<void> notifyAdmins(
    Session session, {
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    final admins = await User.db.find(
      session,
      where: (t) => t.role.equals(UserRole.admin),
    );

    for (final admin in admins) {
      if (admin.id != null) {
        // Persist notification
        await AppNotification.db.insertRow(
          session,
          AppNotification(
            userId: admin.id!,
            title: title,
            body: body,
            data: data,
            isRead: false,
            createdAt: DateTime.now(),
          ),
        );

        if (admin.fcmToken != null) {
          await _sendToToken(
            session,
            token: admin.fcmToken!,
            title: title,
            body: body,
            data: data,
          );
        }
      }
    }
  }

  static Future<bool> _sendToToken(
    Session session, {
    required String token,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      final authClient = await _getAuthClient(session);
      if (authClient == null) return false;

      final payload = {
        'message': {
          'token': token,
          'notification': {
            'title': title,
            'body': body,
          },
          'android': {
            'priority': 'high',
            'notification': {
              'channel_id': 'high_importance_channel',
              'sound': 'default',
            },
          },
          'apns': {
            'payload': {
              'aps': {
                'alert': {
                  'title': title,
                  'body': body,
                },
                'sound': 'default',
                'badge': 1,
              },
            },
          },
          if (data != null) 'data': data,
        },
      };

      final response = await authClient.post(
        Uri.parse(_fcmUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        session.log('FCM: Successfully sent notification to token: $token');
        return true;
      } else {
        session.log(
          'FCM Send Failed: ${response.statusCode} - ${response.body}',
          level: LogLevel.error,
        );
        return false;
      }
    } catch (e) {
      session.log('FCM Request Error: $e', level: LogLevel.error);
      return false;
    }
  }

  /// Returns an authenticated HTTP client for FCM HTTP v1.
  static Future<AutoRefreshingAuthClient?> _getAuthClient(
    Session session,
  ) async {
    if (_authClient != null) return _authClient;

    try {
      final file = File(_serviceAccountPath);
      if (!await file.exists()) {
        session.log(
          'FCM: Service account file not found at $_serviceAccountPath',
          level: LogLevel.error,
        );
        return null;
      }

      final accountCredentials = ServiceAccountCredentials.fromJson(
        await file.readAsString(),
      );

      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      _authClient = await clientViaServiceAccount(accountCredentials, scopes);
      return _authClient;
    } catch (e) {
      session.log(
        'FCM: Failed to create AuthClient: $e',
        level: LogLevel.error,
      );
      return null;
    }
  }
}
