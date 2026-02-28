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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
