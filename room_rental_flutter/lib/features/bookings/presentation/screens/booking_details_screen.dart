import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:room_rental_client/room_rental_client.dart';
import 'package:room_rental_flutter/core/theme/app_theme.dart';
import '../providers/booking_provider.dart';

class BookingDetailsScreen extends ConsumerWidget {
  final int bookingId;

  const BookingDetailsScreen({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(getBookingByIdProvider(bookingId));

    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      body: bookingAsync.when(
        data: (booking) {
          if (booking == null) {
            return const Center(child: Text('Booking not found'));
          }
          return _buildContent(context, booking);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryGreen),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Booking booking) {
    final room = booking.room;
    final checkIn = booking.checkIn;
    final checkOut = booking.checkOut;
    final duration = checkOut.difference(checkIn).inDays;
    final owner = room?.owner;

    return CustomScrollView(
      slivers: [
        // Hero Image App Bar
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          leading: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.8),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTheme.primaryBlack),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  room?.imageUrl ?? 'https://picsum.photos/seed/room/800/600',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppTheme.dividerGray,
                    child: const Icon(Icons.home, size: 100),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Details Body
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(booking.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: _getStatusColor(booking.status),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            booking.status.name.toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(booking.status),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '#BK${booking.id}',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppTheme.secondaryGray,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Title and Location
                Text(
                  room?.title ?? 'Room Rental',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 18,
                      color: AppTheme.secondaryGray,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      room?.location ?? 'Location',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: AppTheme.secondaryGray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Date Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildDateCard(
                        'Check-in',
                        DateFormat('EEE, MMM d, yyyy').format(checkIn),
                        Icons.calendar_today_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDateCard(
                        'Check-out',
                        DateFormat('EEE, MMM d, yyyy').format(checkOut),
                        Icons.calendar_month_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Summary
                _buildInfoRow('Duration', '$duration Nights'),
                const Divider(height: 32),
                _buildInfoRow(
                  'Total Amount',
                  '\$${booking.totalPrice.toStringAsFixed(2)}',
                  isTitle: true,
                ),
                const SizedBox(height: 32),

                // Host Section
                if (owner != null) ...[
                  Text(
                    'Host Information',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppTheme.dividerGray,
                        backgroundImage: owner.profileImage != null
                            ? NetworkImage(owner.profileImage!)
                            : null,
                        child: owner.profileImage == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              owner.fullName,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Verified Host',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: AppTheme.secondaryGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildHostAction(
                          context,
                          'Call',
                          Icons.phone_outlined,
                          () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildHostAction(
                          context,
                          'Message',
                          Icons.message_outlined,
                          () {},
                          isPrimary: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],

                // Payment Details
                Text(
                  'Payment Details',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildPaymentRow(
                  'Transaction ID',
                  booking.transactionId ?? 'N/A',
                ),
                _buildPaymentRow('Payment Method', 'ABA Pay / Sandbox'),
                _buildPaymentRow(
                  'Status',
                  'Paid',
                  color: AppTheme.primaryGreen,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateCard(String label, String date, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.dividerGray),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.primaryGreen),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppTheme.secondaryGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTitle = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: isTitle ? 18 : 16,
            color: isTitle ? AppTheme.primaryBlack : AppTheme.secondaryGray,
            fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: isTitle ? 20 : 16,
            color: isTitle ? AppTheme.primaryGreen : AppTheme.primaryBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AppTheme.secondaryGray,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: color ?? AppTheme.primaryBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostAction(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap, {
    bool isPrimary = false,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(
        icon,
        size: 20,
        color: isPrimary ? Colors.white : AppTheme.primaryGreen,
      ),
      label: Text(
        label,
        style: GoogleFonts.outfit(
          color: isPrimary ? Colors.white : AppTheme.primaryGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: isPrimary ? AppTheme.primaryGreen : Colors.transparent,
        side: BorderSide(color: AppTheme.primaryGreen, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending_payment:
        return Colors.orange;
      case BookingStatus.confirmed:
      case BookingStatus.active:
        return AppTheme.primaryGreen;
      case BookingStatus.completed:
        return AppTheme.secondaryGray;
      case BookingStatus.cancelled:
        return Colors.red;
    }
  }
}
