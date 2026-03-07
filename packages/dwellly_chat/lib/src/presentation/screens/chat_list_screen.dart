import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:dwellly_client/room_rental_client.dart';
import 'package:dwellly_chat/src/presentation/controllers/chat_controller.dart';
import 'package:dwellly_chat/src/presentation/screens/chat_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:dwellly_flutter/core/theme/app_theme.dart';
import 'package:dwellly_flutter/core/utils/avatar_utils.dart';
import 'package:dwellly_flutter/features/auth/presentation/providers/user_providers.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsState = ref.watch(conversationsProvider);
    final userProfile = ref.watch(userProfileProvider);

    final currentUserId = userProfile.maybeWhen(
      data: (user) => user?.id,
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Messages',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlack,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.primaryBlack),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppTheme.primaryBlack),
            onPressed: () {
              // TODO: Show options
            },
          ),
        ],
      ),
      body: conversationsState.when(
        data: (conversations) {
          if (conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No messages yet',
                    style: GoogleFonts.outfit(
                      color: Colors.grey[500],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(conversationsProvider);
            },
            color: AppTheme.primaryGreen,
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final message = conversations[index];

                final isSenderMe = message.senderId == currentUserId;

                final contact = isSenderMe ? message.receiver : message.sender;
                final contactId = isSenderMe
                    ? message.receiverId
                    : message.senderId;

                return _buildConversationItem(
                  context,
                  ref,
                  message,
                  contact,
                  contactId,
                );
              },
            ),
          );
        },
        loading: () => _buildSkeletonLoading(),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                'Error loading messages',
                style: GoogleFonts.outfit(
                  color: Colors.red.shade400,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  ref.invalidate(conversationsProvider);
                },
                child: Text(
                  'Retry',
                  style: GoogleFonts.outfit(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: New generic chat or contact
        },
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.add_comment_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    final fakeData = List.generate(
      8,
      (index) => _FakeConversation(
        name: 'Contact Name',
        message: 'Last message preview',
        time: '12:30 PM',
        isUnread: index % 2 == 0,
      ),
    );

    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: fakeData.length,
        itemBuilder: (context, index) {
          final fake = fakeData[index];
          return _buildSkeletonConversationItem(
            fake.name,
            fake.message,
            fake.time,
            fake.isUnread,
          );
        },
      ),
    );
  }

  Widget _buildSkeletonConversationItem(
    String name,
    String message,
    String time,
    bool isUnread,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          const Skeleton.leaf(
            child: CircleAvatar(radius: 28, backgroundColor: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Skeleton.leaf(
                      child: Container(
                        width: 100,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Skeleton.leaf(
                      child: Container(
                        width: 40,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Skeleton.leaf(
                        child: Container(
                          width: double.infinity,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateDay = DateTime(date.year, date.month, date.day);

    if (dateDay == today) {
      return DateFormat.jm().format(date);
    } else if (today.difference(dateDay).inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat.MMMd().format(date);
    }
  }

  Widget _buildConversationItem(
    BuildContext context,
    WidgetRef ref,
    ChatMessage message,
    User? contact,
    int contactId,
  ) {
    final contactName = contact?.fullName ?? 'Unknown';
    final avatarUrl = contact?.profileImage;
    final timeStr = _formatTime(message.sentAt);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatDetailScreen(
              userId: contactId,
              userName: contactName,
              avatarUrl: avatarUrl,
              isOnline: contact?.isOnline ?? false,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Stack(
              children: [
                AvatarUtils.buildAvatar(
                  imageUrl: avatarUrl,
                  fallbackName: contactName,
                  radius: 28,
                ),
                if (contact?.isOnline ?? false)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        contactName,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlack,
                        ),
                      ),
                      Text(
                        timeStr,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color:
                              !message.isRead && message.senderId == contactId
                              ? AppTheme.primaryGreen
                              : AppTheme.secondaryGray,
                          fontWeight:
                              !message.isRead && message.senderId == contactId
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildMessagePreview(message, contactId),
                      if (!message.isRead && message.senderId == contactId)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagePreview(ChatMessage message, int contactId) {
    final messageType = message.messageType;
    IconData? typeIcon;
    String prefix = '';

    if (messageType == 'image') {
      typeIcon = Icons.image;
      prefix = '📷 ';
    } else if (messageType == 'voice') {
      typeIcon = Icons.mic;
      prefix = '🎤 ';
    } else if (messageType == 'file') {
      typeIcon = Icons.insert_drive_file;
      prefix = '📎 ';
    }

    return Expanded(
      child: Row(
        children: [
          if (typeIcon != null) ...[
            Icon(typeIcon, size: 16, color: AppTheme.secondaryGray),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Text(
              '$prefix${message.message}',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: !message.isRead && message.senderId == contactId
                    ? AppTheme.primaryBlack
                    : AppTheme.secondaryGray,
                fontWeight: !message.isRead && message.senderId == contactId
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _FakeConversation {
  final String name;
  final String message;
  final String time;
  final bool isUnread;

  _FakeConversation({
    required this.name,
    required this.message,
    required this.time,
    required this.isUnread,
  });
}
