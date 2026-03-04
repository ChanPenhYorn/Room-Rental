import 'dart:async';
import 'package:dwellly_client/room_rental_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/chat_repository.dart';

/// Provider for the list of all conversations
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

    // Cancel existing subscription if any
    _subscription?.cancel();

    // Listen for real-time updates
    _subscription = _repository.getMessageStream().listen((message) {
      final currentList = state.value ?? [];

      // Check if conversation already exists in list
      final index = currentList.indexWhere((m) {
        return (m.senderId == message.senderId &&
                m.receiverId == message.receiverId) ||
            (m.senderId == message.receiverId &&
                m.receiverId == message.senderId);
      });

      if (index != -1) {
        // Update existing conversation item and move to top
        final updatedList = List<ChatMessage>.from(currentList);
        updatedList.removeAt(index);
        updatedList.insert(0, message);
        state = AsyncValue.data(updatedList);
      } else {
        // New conversation, add to top
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

/// Provider for messages within a specific conversation
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

    // Cancel existing subscription if any
    _subscription?.cancel();

    // Listen to real-time stream
    _subscription = _repository.getMessageStream().listen((message) {
      // Check if this message belongs to THIS conversation
      if (message.senderId == arg || message.receiverId == arg) {
        final currentMessages = state.value ?? [];
        // Avoid duplicate messages if also added optimistically
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
        // Optimistically update the local state if not already there from stream
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
    // Refresh conversations list to update unread counts/dots in UI list
    ref.read(conversationsProvider.notifier).refresh();
  }
}
