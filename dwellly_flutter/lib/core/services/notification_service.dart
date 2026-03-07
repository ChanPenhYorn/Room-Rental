import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dwellly_client/room_rental_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dwellly_flutter/main.dart';
import '../../features/notifications/presentation/screens/notification_detail_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/social/presentation/screens/chat_detail_screen.dart';

final notificationServiceProvider = Provider((ref) => NotificationService());

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Static variable to track the currently active chat user ID.
  /// Used to suppress notifications when the user is already in the relevant chat.
  static int? activeChatUserId;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  Future<void> initialize() async {
    // 1. Request Permission
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('🔔 [FCM] User granted permission');

      // 2. Initialize Local Notifications for Foreground Alerts
      await _initLocalNotifications();

      // 3. Register Token
      await _registerToken();

      // 4. Handle terminated state (Deep Link)
      RemoteMessage? initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        _handleMessage(initialMessage, isClick: true);
      }

      // 5. Listen for foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('🔔 [FCM] Foreground message: ${message.notification?.title}');
        _showLocalNotification(message);
        // We handle it silently in foreground, or update state
        _handleMessage(message, isClick: false);
      });

      // 6. Handle background state (Deep Link)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleMessage(message, isClick: true);
      });
    } else {
      print('🔔 [FCM] User declined or has not accepted permission');
    }
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle foreground notification click
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          _handleMessage(
            RemoteMessage(
              data: Map<String, String>.from(data['data'] ?? {}),
              notification: RemoteNotification(
                title: data['title'],
                body: data['body'],
              ),
            ),
            isClick: true,
          );
        }
      },
    );

    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      final type = message.data['type'];
      if (type == 'chat') {
        final senderId = int.tryParse(message.data['senderId'] ?? '0') ?? 0;
        if (senderId != 0 && senderId == activeChatUserId) {
          print(
            '🔔 [FCM] Suppressing foreground alert for active chat with user $senderId',
          );
          return;
        }
      }
      final payload = jsonEncode({
        'title': notification.title,
        'body': notification.body,
        'data': message.data,
      });

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            icon: android?.smallIcon ?? '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
      );
    }
  }

  Future<void> _registerToken() async {
    try {
      if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        if (!iosInfo.isPhysicalDevice) {
          print(
            '🔔 [FCM] Running on iOS Simulator: Skipping token registration',
          );
          return;
        }
      }

      String? token = await _fcm.getToken();
      if (token != null) {
        print('🔔 [FCM] Token: ${token.substring(0, 5)}...');
        await client.user.registerFcmToken(token);
      }
    } catch (e) {
      print('❌ [FCM] Failed to get token: $e');
    }
  }

  void _handleMessage(RemoteMessage message, {required bool isClick}) {
    print('🔔 [FCM] Handling message (isClick: $isClick): ${message.data}');

    if (isClick) {
      final notification = message.notification;
      final type = message.data['type'];

      if (type == 'owner_request') {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => const AdminDashboardScreen(initialIndex: 1),
          ),
        );
      } else if (type == 'room_listing_request') {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => const AdminDashboardScreen(initialIndex: 0),
          ),
        );
      } else if (type == 'chat') {
        final senderId = int.tryParse(message.data['senderId'] ?? '0') ?? 0;
        final senderName = message.data['senderName'] ?? 'Property Host';
        final senderAvatar = message.data['senderAvatar'] ?? '';

        if (senderId != 0) {
          // If already in this chat, don't push again
          if (senderId == activeChatUserId) {
            print(
              '🔔 [FCM] Already in chat with user $senderId, skipping push',
            );
            return;
          }

          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => ChatDetailScreen(
                userId: senderId,
                userName: senderName,
                avatarUrl: senderAvatar,
                isOnline: true,
              ),
            ),
          );
        }
      } else if (notification != null) {
        final appNotif = AppNotification(
          title: notification.title ?? 'Notification',
          body: notification.body ?? '',
          createdAt: DateTime.now(),
          isRead: true,
          userId: 0,
          data: message.data.cast<String, String>(),
        );

        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => NotificationDetailScreen(notification: appNotif),
          ),
        );
      }
    }
  }
}
