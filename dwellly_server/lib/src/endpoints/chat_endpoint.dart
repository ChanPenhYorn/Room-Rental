import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../utils/user_utils.dart';
import '../utils/notification_utils.dart';

class ChatEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Future<void> streamOpened(StreamingSession session) async {
    final user = await UserUtils.getOrCreateUser(session);
    if (user != null && user.id != null) {
      // Add user to their private channel based on their User ID
      session.messages.addListener('channel_user_${user.id}', (message) {
        sendStreamMessage(session, message);
      });
      session.log('User ${user.id} connected to chat stream.');
    }
  }

  @override
  Future<void> streamClosed(StreamingSession session) async {
    final user = await UserUtils.getOrCreateUser(session);
    if (user != null && user.id != null) {
      // Optionally handle disconnection
      session.log('User ${user.id} disconnected from chat stream.');
    }
  }

  /// Send a message to another user
  Future<ChatMessage?> sendMessage(
    Session session,
    int receiverId,
    String content,
  ) async {
    final user = await UserUtils.getOrCreateUser(session);
    if (user == null || user.id == null) return null;

    final message = ChatMessage(
      senderId: user.id!,
      receiverId: receiverId,
      message: content,
      sentAt: DateTime.now(),
      isRead: false,
    );

    final savedMessage = await ChatMessage.db.insertRow(session, message);
    if (savedMessage != null) {
      // Fetch with relations for the recipient to see sender details
      final fullMessage = await ChatMessage.db.findById(
        session,
        savedMessage.id!,
        include: ChatMessage.include(
          sender: User.include(),
          receiver: User.include(),
        ),
      );

      if (fullMessage != null) {
        // Broadcast the message to both participants' private channels (WebSockets)
        session.messages.postMessage(
          'channel_user_$receiverId',
          fullMessage,
        );
        session.messages.postMessage(
          'channel_user_${user.id}',
          fullMessage,
        );

        // Send Push Notification (FCM)
        await NotificationUtils.sendNotification(
          session,
          recipientId: receiverId,
          title: 'New Message from ${fullMessage.sender?.fullName ?? "User"}',
          body: content,
          data: {
            'type': 'chat',
            'senderId': fullMessage.senderId.toString(),
            'senderName': fullMessage.sender?.fullName ?? "User",
            'senderAvatar': fullMessage.sender?.profileImage ?? "",
          },
        );
      }
    }
    return savedMessage;
  }

  /// Get all unique conversations for the current user
  /// Returns the last message for each conversation
  Future<List<ChatMessage>> getConversations(Session session) async {
    final user = await UserUtils.getOrCreateUser(session);
    if (user == null || user.id == null) return [];

    // Simple approach: Get all messages involving the user, ordered by time
    final messages = await ChatMessage.db.find(
      session,
      where: (t) => t.senderId.equals(user.id!) | t.receiverId.equals(user.id!),
      orderBy: (t) => t.sentAt,
      orderDescending: true,
      include: ChatMessage.include(
        sender: User.include(),
        receiver: User.include(),
      ),
    );

    // Filter for unique conversations (keep only the latest message for each contact)
    final Map<int, ChatMessage> conversations = {};
    for (final msg in messages) {
      final contactId = msg.senderId == user.id ? msg.receiverId : msg.senderId;
      if (!conversations.containsKey(contactId)) {
        conversations[contactId] = msg;
      }
    }

    return conversations.values.toList();
  }

  /// Get message history with a specific user
  Future<List<ChatMessage>> getMessagesWithUser(
    Session session,
    int otherUserId,
  ) async {
    final user = await UserUtils.getOrCreateUser(session);
    if (user == null || user.id == null) return [];

    return await ChatMessage.db.find(
      session,
      where: (t) =>
          (t.senderId.equals(user.id!) & t.receiverId.equals(otherUserId)) |
          (t.senderId.equals(otherUserId) & t.receiverId.equals(user.id!)),
      orderBy: (t) => t.sentAt,
      orderDescending: false, // Timeline order
      include: ChatMessage.include(
        sender: User.include(),
        receiver: User.include(),
      ),
    );
  }

  /// Mark all messages from a user as read
  Future<void> markAsRead(Session session, int otherUserId) async {
    final user = await UserUtils.getOrCreateUser(session);
    if (user == null || user.id == null) return;

    // Update isRead = true for all messages where user is receiver and otherUserId is sender
    await session.db.unsafeSimpleQuery(
      'UPDATE chat_message SET "isRead" = true WHERE "receiverId" = ${user.id} AND "senderId" = $otherUserId AND "isRead" = false',
    );
  }
}
