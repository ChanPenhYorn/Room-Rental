import 'package:dwellly_client/room_rental_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:dwellly_flutter/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:dwellly_flutter/features/owner_request/presentation/screens/become_owner_screen.dart';
import 'package:dwellly_flutter/features/property_management/presentation/screens/edit_room_screen.dart';
import 'package:dwellly_flutter/features/listings/presentation/providers/room_provider.dart';

class NotificationDetailScreen extends ConsumerWidget {
  final AppNotification notification;

  const NotificationDetailScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(
      '🧐 [NotificationDetailScreen] building with data: ${notification.data}',
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Notification Details',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlack,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.primaryBlack),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(notification.title),
                color: AppTheme.primaryGreen,
                size: 32,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              notification.title,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlack,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('MMM d, yyyy • h:mm a').format(notification.createdAt),
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppTheme.secondaryGray,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Text(
              notification.body,
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 48),
            if (notification.data != null) ...[
              if (notification.data!['type'] == 'role_change')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Go to Profile',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              if (notification.data!['type'] == 'owner_request')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AdminDashboardScreen(initialIndex: 1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.verified_user_outlined),
                    label: Text(
                      'Review Owner Request',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              if (notification.data!['type'] == 'room_listing_request' ||
                  notification.data!['type'] == 'room_submission')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AdminDashboardScreen(initialIndex: 0),
                        ),
                      );
                    },
                    icon: const Icon(Icons.home_work_outlined),
                    label: Text(
                      'Review Room Listing',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              if (notification.data!['type'] == 'room_status' &&
                  notification.data!['status'] == 'rejected' &&
                  notification.data!['roomId'] != null)
                SizedBox(
                  width: double.infinity,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final roomId = int.tryParse(
                        notification.data!['roomId']!,
                      );
                      if (roomId == null) return const SizedBox.shrink();

                      return ElevatedButton.icon(
                        onPressed: () async {
                          // Show loading barrier
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) => const Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          );

                          try {
                            // Fetch the room using the repository provider
                            final repo = ref.read(roomRepositoryProvider);
                            final room = await repo.getRoomById(roomId);

                            // Hide loading
                            if (context.mounted) Navigator.pop(context);

                            if (room != null && context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditRoomScreen(room: room),
                                ),
                              );
                            } else if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Room not found or may have been deleted.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              Navigator.pop(context); // Hide loading
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error loading room: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.edit_note_outlined),
                        label: Text(
                          'Edit Rejected Room',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade700,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (notification.data!['type'] == 'owner_request_status' &&
                  notification.data!['status'] == 'rejected')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BecomeOwnerScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.refresh_outlined),
                    label: Text(
                      'Submit New Request',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String title) {
    title = title.toLowerCase();
    if (title.contains('booking')) return Icons.calendar_today_outlined;
    if (title.contains('payment')) return Icons.account_balance_wallet_outlined;
    if (title.contains('message')) return Icons.chat_bubble_outline;
    if (title.contains('owner')) return Icons.verified_user_outlined;
    return Icons.notifications_outlined;
  }
}
