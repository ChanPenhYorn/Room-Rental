import 'package:dwellly_client/room_rental_client.dart';

abstract class BookingRepository {
  Future<Booking?> createBooking(Booking booking);
  Future<List<Booking>> getMyBookings();
  Future<Booking?> getBookingById(int id);
}
