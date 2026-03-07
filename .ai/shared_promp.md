# Enhanced Opencode Command - Context-Aware Chat Notifications

This command refines the chat notification logic to be context-aware: only suppressing alerts for the active chat while allowing them for others.

## 1. Notification Service: Context-Aware Suppression
Modify `dwellly_flutter/lib/core/services/notification_service.dart`:
- **Update** `_showLocalNotification` to check against `activeChatUserId`:
  ```dart
  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    // ...
    if (notification != null) {
      final type = message.data['type'];
      if (type == 'chat') {
        final senderId = int.tryParse(message.data['senderId'] ?? '0') ?? 0;
        // Suppress ONLY if user is already in this specific chat
        if (senderId != 0 && senderId == activeChatUserId) {
          print('🔔 [FCM] Suppressing foreground alert for active chat with user $senderId');
          return; 
        }
        // Otherwise, proceed to show local notification banner
      }
      // ... show notification logic continues ...
    }
  }
  ```

## 2. Notification List & Scrolling (Existing)
Maintain the following from previous updates:
- **Backend**: Skip persistence for chat messages in `NotificationUtils`.
- **Frontend Filter**: `NotificationNotifier` fallback filter.
- **Scrolling**: `_scrollToBottom` refinements and `ref.listen` for initial load.
