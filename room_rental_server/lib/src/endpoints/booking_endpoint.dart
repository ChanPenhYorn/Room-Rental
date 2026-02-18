import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';

class BookingEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Helper to get the integer UserInfo ID from the session identifier
  Future<int?> _getAuthenticatedUserId(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;

    final userIdentifier = authInfo.userIdentifier;

    // Standard lookup in UserInfo table
    final userInfo = await UserInfo.db.findFirstRow(
      session,
      where: (t) => t.userIdentifier.equals(userIdentifier),
    );

    if (userInfo != null) return userInfo.id;

    // Fallback search in User table
    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userIdentifier),
    );

    return user?.userInfoId;
  }

  /// Create a new booking
  Future<Booking?> createBooking(Session session, Booking booking) async {
    final userInfoId = await _getAuthenticatedUserId(session);
    if (userInfoId == null) return null;

    // Fetch the User record associated with the authenticated UserInfo
    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userInfoId),
    );

    if (user == null) {
      session.log('User not found for userInfoId: $userInfoId');
      return null;
    }

    // Set internal fields
    booking.userId = user.id!;
    booking.createdAt = DateTime.now();
    // Default to pending_payment if not specified
    booking.status ??= BookingStatus.pending_payment;

    // Check if room is available
    final roomId = booking.roomId;

    final room = await Room.db.findById(session, roomId);
    if (room == null || !room.isAvailable) {
      session.log('Room not available for booking: $roomId');
      return null;
    }

    // Insert booking
    final savedBooking = await Booking.db.insertRow(session, booking);

    return savedBooking;
  }

  /// Get all bookings for the current user
  Future<List<Booking>> getMyBookings(Session session) async {
    final userInfoId = await _getAuthenticatedUserId(session);
    if (userInfoId == null) return [];

    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userInfoId),
    );

    if (user == null) return [];

    return await Booking.db.find(
      session,
      where: (t) => t.userId.equals(user.id!),
      include: Booking.include(
        room: Room.include(
          owner: User.include(),
        ),
      ),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Get a specific booking by ID
  Future<Booking?> getBookingById(Session session, int id) async {
    final userInfoId = await _getAuthenticatedUserId(session);
    if (userInfoId == null) return null;

    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userInfoId),
    );

    if (user == null) return null;

    final booking = await Booking.db.findById(
      session,
      id,
      include: Booking.include(
        room: Room.include(
          owner: User.include(),
        ),
        user: User.include(),
        contract: Contract.include(),
      ),
    );

    // Ensure the booking belongs to the user or they are the room owner
    if (booking == null) return null;
    if (booking.userId != user.id && booking.room?.ownerId != user.id) {
      return null;
    }

    return booking;
  }
}
