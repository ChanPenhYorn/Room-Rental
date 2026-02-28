// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$roomRepositoryHash() => r'dc648b96d30988afec06e0e64ccee232885e58d3';

/// See also [roomRepository].
@ProviderFor(roomRepository)
final roomRepositoryProvider = AutoDisposeProvider<RoomRepository>.internal(
  roomRepository,
  name: r'roomRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$roomRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RoomRepositoryRef = AutoDisposeProviderRef<RoomRepository>;
String _$roomListHash() => r'05ad43f33d11a6480195ec7dfed5aaad453e9bb4';

/// See also [roomList].
@ProviderFor(roomList)
final roomListProvider = AutoDisposeFutureProvider<List<RoomEntity>>.internal(
  roomList,
  name: r'roomListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$roomListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RoomListRef = AutoDisposeFutureProviderRef<List<RoomEntity>>;
String _$pendingRoomsHash() => r'6ff41b0b4e9cf8888162f85ba81af81a59eec10a';

/// See also [pendingRooms].
@ProviderFor(pendingRooms)
final pendingRoomsProvider =
    AutoDisposeFutureProvider<List<RoomEntity>>.internal(
      pendingRooms,
      name: r'pendingRoomsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pendingRoomsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingRoomsRef = AutoDisposeFutureProviderRef<List<RoomEntity>>;
String _$myRoomsHash() => r'300c2ede0f657760739d08a7344545926a9fb770';

/// See also [myRooms].
@ProviderFor(myRooms)
final myRoomsProvider = AutoDisposeFutureProvider<List<RoomEntity>>.internal(
  myRooms,
  name: r'myRoomsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myRoomsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyRoomsRef = AutoDisposeFutureProviderRef<List<RoomEntity>>;
String _$adminRoomsHash() => r'43395407c1b3774a4468f2926e19de9b102e801d';

/// See also [adminRooms].
@ProviderFor(adminRooms)
final adminRoomsProvider = AutoDisposeFutureProvider<List<RoomEntity>>.internal(
  adminRooms,
  name: r'adminRoomsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminRoomsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminRoomsRef = AutoDisposeFutureProviderRef<List<RoomEntity>>;
String _$selectedCategoryHash() => r'9fbcb369d480ede1bc875040ab35bd83542a1ec4';

/// See also [SelectedCategory].
@ProviderFor(SelectedCategory)
final selectedCategoryProvider =
    AutoDisposeNotifierProvider<SelectedCategory, String>.internal(
      SelectedCategory.new,
      name: r'selectedCategoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedCategoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedCategory = AutoDisposeNotifier<String>;
String _$roomFilterHash() => r'336cfd9be3665a0ee11ec0626ec73b60f6752874';

/// See also [RoomFilter].
@ProviderFor(RoomFilter)
final roomFilterProvider =
    AutoDisposeNotifierProvider<RoomFilter, FilterOptions>.internal(
      RoomFilter.new,
      name: r'roomFilterProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$roomFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RoomFilter = AutoDisposeNotifier<FilterOptions>;
String _$roomControllerHash() => r'0bf4d13cf8c75f0b934a5b2cbe966adfab9935de';

/// See also [RoomController].
@ProviderFor(RoomController)
final roomControllerProvider =
    AutoDisposeNotifierProvider<RoomController, AsyncValue<void>>.internal(
      RoomController.new,
      name: r'roomControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$roomControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RoomController = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
