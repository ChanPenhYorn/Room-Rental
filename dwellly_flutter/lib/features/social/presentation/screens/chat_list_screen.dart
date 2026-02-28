import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dwellly_flutter/core/theme/app_theme.dart';
import 'package:dwellly_flutter/features/social/presentation/screens/chat_detail_screen.dart';

/// Chat List Screen
/// Displays a list of recent conversations
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  // Mock data for conversations
  final List<Map<String, dynamic>> _conversations = [
    {
      'id': '1',
      'name': 'John Doe',
      'avatarUrl': 'https://i.pravatar.cc/150?u=1',
      'lastMessage': 'Is the apartment still available?',
      'time': '10:30 AM',
      'unreadCount': 2,
      'isOnline': true,
    },
    {
      'id': '2',
      'name': 'Sarah Smith',
      'avatarUrl': 'https://i.pravatar.cc/150?u=2',
      'lastMessage': 'Thanks for the tour yesterday!',
      'time': 'Yesterday',
      'unreadCount': 0,
      'isOnline': false,
    },
    {
      'id': '3',
      'name': 'Mike Johnson',
      'avatarUrl': 'https://i.pravatar.cc/150?u=3',
      'lastMessage': 'I will let you know by tomorrow.',
      'time': 'Mon',
      'unreadCount': 0,
      'isOnline': true,
    },
    {
      'id': '4',
      'name': 'Emily Davis',
      'avatarUrl': 'https://i.pravatar.cc/150?u=4',
      'lastMessage': 'What is the security deposit amount?',
      'time': 'Sun',
      'unreadCount': 5,
      'isOnline': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        itemCount: _conversations.length,
        itemBuilder: (context, index) {
          final conversation = _conversations[index];
          return _buildConversationItem(conversation);
        },
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

  Widget _buildConversationItem(Map<String, dynamic> conversation) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatDetailScreen(
              userName: conversation['name'],
              avatarUrl: conversation['avatarUrl'],
              isOnline: conversation['isOnline'],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            // Avatar with Online Status
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(conversation['avatarUrl']),
                  backgroundColor: AppTheme.dividerGray,
                ),
                if (conversation['isOnline'])
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conversation['name'],
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlack,
                        ),
                      ),
                      Text(
                        conversation['time'],
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: conversation['unreadCount'] > 0
                              ? AppTheme.primaryGreen
                              : AppTheme.secondaryGray,
                          fontWeight: conversation['unreadCount'] > 0
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
                          conversation['lastMessage'],
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: conversation['unreadCount'] > 0
                                ? AppTheme.primaryBlack
                                : AppTheme.secondaryGray,
                            fontWeight: conversation['unreadCount'] > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (conversation['unreadCount'] > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            conversation['unreadCount'].toString(),
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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
