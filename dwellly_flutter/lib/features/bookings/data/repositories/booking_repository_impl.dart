import 'package:dwellly_client/room_rental_client.dart';
import '../../domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final Client client;

  BookingRepositoryImpl(this.client);

  @override
  Future<Booking?> createBooking(Booking booking) async {
    try {
      print('🔵 [API] Calling client.booking.createBooking()...');
      final result = await client.booking.createBooking(booking);
      print('✅ [API] Booking created: ${result?.id}');
      return result;
    } catch (e) {
      print('❌ [API] Error creating booking: $e');
      rethrow;
    }
  }

  @override
  Future<List<Booking>> getMyBookings() async {
    try {
      print('🔵 [API] Calling client.booking.getMyBookings()...');
      final result = await client.booking.getMyBookings();
      print('✅ [API] Got ${result.length} bookings');
      return result;
    } catch (e) {
      print('❌ [API] Error fetching bookings: $e');
      return [];
    }
  }

  @override
  Future<Booking?> getBookingById(int id) async {
    try {
      return await client.booking.getBookingById(id);
    } catch (e) {
      print('❌ [API] Error fetching booking by id: $e');
      return null;
    }
  }
}
