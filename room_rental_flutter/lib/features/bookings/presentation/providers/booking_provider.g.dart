// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingRepositoryHash() => r'4aa8e6513c886609ddf575ba0a15dda4aaa8e768';

/// See also [bookingRepository].
@ProviderFor(bookingRepository)
final bookingRepositoryProvider =
    AutoDisposeProvider<BookingRepository>.internal(
      bookingRepository,
      name: r'bookingRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bookingRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BookingRepositoryRef = AutoDisposeProviderRef<BookingRepository>;
String _$myBookingsHash() => r'34b662d9f2c6386a8b751bd87d31a9d48ba7ce59';

/// See also [myBookings].
@ProviderFor(myBookings)
final myBookingsProvider = AutoDisposeFutureProvider<List<Booking>>.internal(
  myBookings,
  name: r'myBookingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myBookingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyBookingsRef = AutoDisposeFutureProviderRef<List<Booking>>;
String _$bookingControllerHash() => r'92f922c4809a4362842e2d09d7574f30be834287';

/// See also [BookingController].
@ProviderFor(BookingController)
final bookingControllerProvider =
    AutoDisposeNotifierProvider<BookingController, AsyncValue<void>>.internal(
      BookingController.new,
      name: r'bookingControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bookingControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BookingController = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
