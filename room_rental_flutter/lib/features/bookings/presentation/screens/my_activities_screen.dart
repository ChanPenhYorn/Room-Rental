import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:room_rental_client/room_rental_client.dart';
import 'package:room_rental_flutter/core/theme/app_theme.dart';
import '../providers/booking_provider.dart';

/// My Activities Dashboard
/// Shows all user bookings (active, upcoming, past)
class MyActivitiesScreen extends ConsumerStatefulWidget {
  const MyActivitiesScreen({super.key});

  @override
  ConsumerState<MyActivitiesScreen> createState() => _MyActivitiesScreenState();
}

class _MyActivitiesScreenState extends ConsumerState<MyActivitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(myBookingsProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'My Activities',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlack,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryGreen,
          unselectedLabelColor: AppTheme.secondaryGray,
          indicatorColor: AppTheme.primaryGreen,
          labelStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: bookingsAsync.when(
        data: (bookings) {
          final activeBookings = bookings
              .where(
                (b) =>
                    b.status == BookingStatus.active ||
                    b.status == BookingStatus.confirmed ||
                    b.status == BookingStatus.pending_payment,
              )
              .toList();
          final pastBookings = bookings
              .where(
                (b) =>
                    b.status == BookingStatus.completed ||
                    b.status == BookingStatus.cancelled,
              )
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildBookingsList(activeBookings, isActive: true),
              _buildBookingsList(pastBookings, isActive: false),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryGreen),
        ),
        error: (error, stack) => Center(
          child: Text('Error loading bookings: $error'),
        ),
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings, {required bool isActive}) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? Icons.calendar_today_outlined : Icons.history,
              size: 64,
              color: AppTheme.dividerGray,
            ),
            const SizedBox(height: 16),
            Text(
              isActive ? 'No active bookings' : 'No past activities',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.secondaryGray,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isActive
                  ? 'Start exploring rooms for your next stay'
                  : 'Your past stays will appear here',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppTheme.secondaryGray,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(bookings[index]);
      },
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final checkIn = booking.checkIn;
    final checkOut = booking.checkOut;
    final isActive =
        booking.status == BookingStatus.active &&
        checkOut.isAfter(DateTime.now());
    final daysRemaining = isActive
        ? checkOut.difference(DateTime.now()).inDays
        : 0;

    final room = booking.room;
    final roomName = room?.title ?? 'Room Rental';
    final location = room?.location ?? 'Location';
    final imageUrl =
        room?.imageUrl ?? 'https://picsum.photos/seed/room/400/300';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Status Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 180,
                      color: AppTheme.dividerGray,
                      child: const Icon(Icons.home, size: 60),
                    );
                  },
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    booking.status.name.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Booking Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Booking ID
                Text(
                  'Booking ID: BK${booking.id}',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppTheme.secondaryGray,
                  ),
                ),
                const SizedBox(height: 8),

                // Room Name
                Text(
                  roomName,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlack,
                  ),
                ),
                const SizedBox(height: 4),

                // Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppTheme.secondaryGray,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppTheme.secondaryGray,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Dates
                Row(
                  children: [
                    Expanded(
                      child: _buildDateInfo(
                        'Check-in',
                        '${checkIn.day}/${checkIn.month}/${checkIn.year}',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDateInfo(
                        'Check-out',
                        '${checkOut.day}/${checkOut.month}/${checkOut.year}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Days Remaining (for active bookings)
                if (isActive && daysRemaining > 0) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 18,
                          color: AppTheme.primaryGreen,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$daysRemaining days remaining',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // View details
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppTheme.primaryGreen,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'View Details',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ),
                    ),
                    if (isActive) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // View contract
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'View Contract',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: AppTheme.secondaryGray,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlack,
          ),
        ),
      ],
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
