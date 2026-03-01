import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../utils/user_utils.dart';

class NotificationEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<AppNotification>> getMyNotifications(Session session) async {
    final user = await UserUtils.getOrCreateUser(session);
    if (user?.id == null) return [];

    return await AppNotification.db.find(
      session,
      where: (t) => t.userId.equals(user!.id!),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: 50,
    );
  }

  Future<int> getUnreadCount(Session session) async {
    final user = await UserUtils.getOrCreateUser(session);
    if (user?.id == null) return 0;

    return await AppNotification.db.count(
      session,
      where: (t) => t.userId.equals(user!.id!) & t.isRead.equals(false),
    );
  }

  Future<bool> markAsRead(Session session, int notificationId) async {
    final user = await UserUtils.getOrCreateUser(session);
    if (user?.id == null) return false;

    final notification = await AppNotification.db.findById(
      session,
      notificationId,
    );
    if (notification == null || notification.userId != user!.id) return false;

    notification.isRead = true;
    await AppNotification.db.updateRow(session, notification);
    return true;
  }

  Future<bool> markAllAsRead(Session session) async {
    final user = await UserUtils.getOrCreateUser(session);
    if (user?.id == null) return false;

    // Use a transaction or bulk update if supported
    final unread = await AppNotification.db.find(
      session,
      where: (t) => t.userId.equals(user!.id!) & t.isRead.equals(false),
    );

    for (final n in unread) {
      n.isRead = true;
      await AppNotification.db.updateRow(session, n);
    }
    return true;
  }
}
