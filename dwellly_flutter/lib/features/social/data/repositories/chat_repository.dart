import 'package:dwellly_client/room_rental_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client_provider.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return ChatRepositoryImpl(client);
});

abstract class ChatRepository {
  Future<ChatMessage?> sendMessage(int receiverId, String content);
  Future<ChatMessage?> sendAttachmentMessage(
    int receiverId,
    String messageType,
    String attachmentUrl, {
    String? message,
    int? attachmentDuration,
    String? attachmentName,
    int? attachmentSize,
  });
  Future<String?> uploadAttachment(String fileBase64, String fileName);
  Future<List<ChatMessage>> getConversations();
  Future<List<ChatMessage>> getMessagesWithUser(int otherUserId);
  Future<void> markAsRead(int otherUserId);
  Stream<ChatMessage> getMessageStream();
}

class ChatRepositoryImpl implements ChatRepository {
  final Client _client;
  late final Stream<ChatMessage> _broadcastStream;

  ChatRepositoryImpl(this._client) {
    _broadcastStream = _client.chat.stream
        .where((msg) => msg is ChatMessage)
        .cast<ChatMessage>()
        .asBroadcastStream();
  }

  @override
  Stream<ChatMessage> getMessageStream() => _broadcastStream;

  @override
  Future<ChatMessage?> sendMessage(int receiverId, String content) async {
    try {
      return await _client.chat.sendMessage(receiverId, content);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<ChatMessage?> sendAttachmentMessage(
    int receiverId,
    String messageType,
    String attachmentUrl, {
    String? message,
    int? attachmentDuration,
    String? attachmentName,
    int? attachmentSize,
  }) async {
    try {
      return await _client.chat.sendAttachmentMessage(
        receiverId,
        messageType,
        attachmentUrl,
        message: message,
        attachmentDuration: attachmentDuration,
        attachmentName: attachmentName,
        attachmentSize: attachmentSize,
      );
    } catch (e) {
      throw Exception('Failed to send attachment message: $e');
    }
  }

  @override
  Future<String?> uploadAttachment(String fileBase64, String fileName) async {
    try {
      return await _client.chat.uploadAttachment(fileBase64, fileName);
    } catch (e) {
      throw Exception('Failed to upload attachment: $e');
    }
  }

  @override
  Future<List<ChatMessage>> getConversations() async {
    try {
      return await _client.chat.getConversations();
    } catch (e) {
      throw Exception('Failed to fetch conversations: $e');
    }
  }

  @override
  Future<List<ChatMessage>> getMessagesWithUser(int otherUserId) async {
    try {
      return await _client.chat.getMessagesWithUser(otherUserId);
    } catch (e) {
      throw Exception('Failed to fetch messages: $e');
    }
  }

  @override
  Future<void> markAsRead(int otherUserId) async {
    try {
      await _client.chat.markAsRead(otherUserId);
    } catch (e) {
      print('Warning: Failed to mark messages as read: $e');
    }
  }
}
