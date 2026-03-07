import 'dart:async';
import 'package:dwellly_client/room_rental_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatClientProvider = Provider<Client>((ref) {
  throw UnimplementedError(
    'chatClientProvider must be overridden in dwellly_flutter',
  );
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final client = ref.watch(chatClientProvider);
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

final conversationsProvider =
    AsyncNotifierProvider<ConversationsController, List<ChatMessage>>(
      ConversationsController.new,
    );

class ConversationsController extends AsyncNotifier<List<ChatMessage>> {
  late ChatRepository _repository;
  StreamSubscription? _subscription;

  @override
  Future<List<ChatMessage>> build() async {
    _repository = ref.watch(chatRepositoryProvider);

    _subscription?.cancel();

    _subscription = _repository.getMessageStream().listen((message) {
      final currentList = state.value ?? [];

      final index = currentList.indexWhere((m) {
        return (m.senderId == message.senderId &&
                m.receiverId == message.receiverId) ||
            (m.senderId == message.receiverId &&
                m.receiverId == message.senderId);
      });

      if (index != -1) {
        final updatedList = List<ChatMessage>.from(currentList);
        updatedList.removeAt(index);
        updatedList.insert(0, message);
        state = AsyncValue.data(updatedList);
      } else {
        state = AsyncValue.data([message, ...currentList]);
      }
    });

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return await _repository.getConversations();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _repository.getConversations());
  }
}

final chatHistoryProvider =
    AsyncNotifierProvider.family<ChatHistoryController, List<ChatMessage>, int>(
      ChatHistoryController.new,
    );

class ChatHistoryController
    extends FamilyAsyncNotifier<List<ChatMessage>, int> {
  late ChatRepository _repository;
  StreamSubscription? _subscription;

  @override
  Future<List<ChatMessage>> build(int arg) async {
    _repository = ref.watch(chatRepositoryProvider);

    _subscription?.cancel();

    _subscription = _repository.getMessageStream().listen((message) {
      if (message.senderId == arg || message.receiverId == arg) {
        final currentMessages = state.value ?? [];
        if (!currentMessages.any((m) => m.id != null && m.id == message.id)) {
          state = AsyncValue.data([...currentMessages, message]);
        }
      }
    });

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return await _repository.getMessagesWithUser(arg);
  }

  Future<void> sendMessage(String content) async {
    try {
      final newMessage = await _repository.sendMessage(arg, content);
      if (newMessage != null) {
        final currentMessages = state.value ?? [];
        if (!currentMessages.any((m) => m.id == newMessage.id)) {
          state = AsyncValue.data([...currentMessages, newMessage]);
        }
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markRead() async {
    await _repository.markAsRead(arg);
    ref.read(conversationsProvider.notifier).refresh();
  }

  Future<void> sendAttachmentMessage({
    required String messageType,
    required String attachmentUrl,
    String? message,
    int? attachmentDuration,
    String? attachmentName,
    int? attachmentSize,
  }) async {
    try {
      final newMessage = await _repository.sendAttachmentMessage(
        arg,
        messageType,
        attachmentUrl,
        message: message,
        attachmentDuration: attachmentDuration,
        attachmentName: attachmentName,
        attachmentSize: attachmentSize,
      );
      if (newMessage != null) {
        final currentMessages = state.value ?? [];
        if (!currentMessages.any((m) => m.id == newMessage.id)) {
          state = AsyncValue.data([...currentMessages, newMessage]);
        }
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<String?> uploadAttachment(String fileBase64, String fileName) async {
    return await _repository.uploadAttachment(fileBase64, fileName);
  }
}
