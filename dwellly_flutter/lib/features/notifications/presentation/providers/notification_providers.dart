import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dwellly_client/room_rental_client.dart';
import '../../../../main.dart';

final unreadNotificationCountProvider = StateProvider<int>((ref) => 0);
final newNotificationEventProvider = StateProvider<AppNotification?>(
  (ref) => null,
);

final notificationsProvider =
    StateNotifierProvider<
      NotificationNotifier,
      AsyncValue<List<AppNotification>>
    >((ref) {
      return NotificationNotifier(ref);
    });

class NotificationNotifier
    extends StateNotifier<AsyncValue<List<AppNotification>>> {
  final Ref _ref;
  Timer? _timer;

  NotificationNotifier(this._ref) : super(const AsyncValue.loading()) {
    refresh();
    _startPolling();
  }

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _silentRefresh(),
    );
  }

  Future<void> _silentRefresh() async {
    print('🔔 [Notifications] Polling for updates...');
    try {
      final notifications = await client.notification.getMyNotifications();

      // Check for new notifications to alert the user
      state.whenData((previousList) {
        for (final n in notifications) {
          // If it's unread and wasn't in our previous list, it's new!
          if (!n.isRead && !previousList.any((prev) => prev.id == n.id)) {
            print('🔔 [Notifications] NEW notification detected: ${n.id}');
            _ref.read(newNotificationEventProvider.notifier).state = n;
            break; // Only alert for the newest one
          }
        }
      });

      state = AsyncValue.data(notifications);

      final unreadCount = await client.notification.getUnreadCount();
      _ref.read(unreadNotificationCountProvider.notifier).state = unreadCount;
    } catch (e) {
      print('🔔 [Notifications] Polling error: $e');
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final notifications = await client.notification.getMyNotifications();
      state = AsyncValue.data(notifications);

      // Update unread count
      final unreadCount = await client.notification.getUnreadCount();
      _ref.read(unreadNotificationCountProvider.notifier).state = unreadCount;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      final success = await client.notification.markAsRead(id);
      if (success) {
        // Optimistically update UI
        state.whenData((list) {
          final updatedList = list.map((n) {
            if (n.id == id) {
              return n.copyWith(isRead: true);
            }
            return n;
          }).toList();
          state = AsyncValue.data(updatedList);

          // Decrement unread count
          final currentUnread = _ref.read(unreadNotificationCountProvider);
          if (currentUnread > 0) {
            _ref.read(unreadNotificationCountProvider.notifier).state =
                currentUnread - 1;
          }
        });
      }
    } catch (e) {
      // Quietly handle error
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final success = await client.notification.markAllAsRead();
      if (success) {
        state.whenData((list) {
          final updatedList = list
              .map((n) => n.copyWith(isRead: true))
              .toList();
          state = AsyncValue.data(updatedList);
          _ref.read(unreadNotificationCountProvider.notifier).state = 0;
        });
      }
    } catch (e) {
      // Quietly handle error
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
