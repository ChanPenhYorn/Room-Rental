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
String _$myBookingsHash() => r'5934aceb94ea5b6963f378c1ed335ba8bb5d96ef';

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
String _$getBookingByIdHash() => r'596eb605e66e38f8a55f8e7074658d1b02bbb603';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [getBookingById].
@ProviderFor(getBookingById)
const getBookingByIdProvider = GetBookingByIdFamily();

/// See also [getBookingById].
class GetBookingByIdFamily extends Family<AsyncValue<Booking?>> {
  /// See also [getBookingById].
  const GetBookingByIdFamily();

  /// See also [getBookingById].
  GetBookingByIdProvider call(int id) {
    return GetBookingByIdProvider(id);
  }

  @override
  GetBookingByIdProvider getProviderOverride(
    covariant GetBookingByIdProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getBookingByIdProvider';
}

/// See also [getBookingById].
class GetBookingByIdProvider extends AutoDisposeFutureProvider<Booking?> {
  /// See also [getBookingById].
  GetBookingByIdProvider(int id)
    : this._internal(
        (ref) => getBookingById(ref as GetBookingByIdRef, id),
        from: getBookingByIdProvider,
        name: r'getBookingByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getBookingByIdHash,
        dependencies: GetBookingByIdFamily._dependencies,
        allTransitiveDependencies:
            GetBookingByIdFamily._allTransitiveDependencies,
        id: id,
      );

  GetBookingByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<Booking?> Function(GetBookingByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetBookingByIdProvider._internal(
        (ref) => create(ref as GetBookingByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Booking?> createElement() {
    return _GetBookingByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetBookingByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetBookingByIdRef on AutoDisposeFutureProviderRef<Booking?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _GetBookingByIdProviderElement
    extends AutoDisposeFutureProviderElement<Booking?>
    with GetBookingByIdRef {
  _GetBookingByIdProviderElement(super.provider);

  @override
  int get id => (origin as GetBookingByIdProvider).id;
}

String _$bookingControllerHash() => r'300aa1b1d124771b68d955fc26e211a477f0fbe1';

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
