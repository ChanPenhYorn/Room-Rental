import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:room_rental_client/room_rental_client.dart';
import '../../../../core/network/api_client_provider.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/repositories/booking_repository.dart';

part 'booking_provider.g.dart';

@riverpod
BookingRepository bookingRepository(BookingRepositoryRef ref) {
  final client = ref.watch(clientProvider);
  return BookingRepositoryImpl(client);
}

@riverpod
class BookingController extends _$BookingController {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<Booking?> createBooking({
    required int roomId,
    required DateTime checkIn,
    required DateTime checkOut,
    required double totalPrice,
    String? transactionId,
    BookingStatus? status,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(bookingRepositoryProvider);
      final booking = Booking(
        roomId: roomId,
        checkIn: checkIn,
        checkOut: checkOut,
        totalPrice: totalPrice,
        status: status ?? BookingStatus.pending_payment,
        transactionId: transactionId,
        createdAt: DateTime.now(),
        userId: 0,
      );

      final result = await repository.createBooking(booking);
      state = const AsyncValue.data(null);

      // Invalidate the booking list to trigger a refresh
      ref.invalidate(myBookingsProvider);

      return result;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }
}

@riverpod
Future<List<Booking>> myBookings(MyBookingsRef ref) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return await repository.getMyBookings();
}

@riverpod
Future<Booking?> getBookingById(GetBookingByIdRef ref, int id) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return await repository.getBookingById(id);
}
