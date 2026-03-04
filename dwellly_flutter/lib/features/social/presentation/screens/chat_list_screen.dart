import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dwellly_client/room_rental_client.dart';
import 'package:dwellly_flutter/core/theme/app_theme.dart';
import 'package:dwellly_flutter/features/social/presentation/controllers/chat_controller.dart';
import 'package:dwellly_flutter/features/auth/presentation/providers/auth_providers.dart';
import 'package:dwellly_flutter/features/social/presentation/screens/chat_detail_screen.dart';
import 'package:intl/intl.dart';

/// Chat List Screen
/// Displays a list of recent conversations
class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsState = ref.watch(conversationsProvider);
    final authState = ref.watch(authStateProvider);

    final currentUserId = authState.maybeWhen(
      authenticated: (userInfo) => userInfo.id,
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

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final message = conversations[index];

              // Identify the contact
              final isSenderMe =
                  message.senderId == currentUserId ||
                  (message.sender?.userInfoId == currentUserId);

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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
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
    final avatarUrl =
        contact?.profileImage ?? 'https://i.pravatar.cc/150?u=$contactId';
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
              isOnline: false,
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
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(avatarUrl),
                  backgroundColor: AppTheme.dividerGray,
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
                      Expanded(
                        child: Text(
                          message.message,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color:
                                !message.isRead && message.senderId == contactId
                                ? AppTheme.primaryBlack
                                : AppTheme.secondaryGray,
                            fontWeight:
                                !message.isRead && message.senderId == contactId
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
}
