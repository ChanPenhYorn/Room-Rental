import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:room_rental_client/room_rental_client.dart';
import '../../../../core/network/api_client_provider.dart';
import '../../data/repositories/room_repository_impl.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/room_entity.dart';
import '../../domain/repositories/room_repository.dart';

import '../widgets/filter_modal.dart';

part 'room_provider.g.dart';

@riverpod
RoomRepository roomRepository(RoomRepositoryRef ref) {
  final client = ref.watch(clientProvider);
  return RoomRepositoryImpl(client);
}

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String build() => 'All';

  void setCategory(String category) => state = category;
}

@riverpod
class RoomFilter extends _$RoomFilter {
  @override
  FilterOptions build() => FilterOptions();

  void setFilter(FilterOptions filter) => state = filter;

  void reset() => state = FilterOptions();
}

@riverpod
Future<List<RoomEntity>> roomList(RoomListRef ref) async {
  final repository = ref.watch(roomRepositoryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final filter = ref.watch(roomFilterProvider);

  final rooms = await repository.getRooms();

  return rooms.where((room) {
    if (selectedCategory != 'All' && room.type.uiLabel != selectedCategory) {
      return false;
    }
    if (room.price < filter.minPrice || room.price > filter.maxPrice) {
      return false;
    }
    if (filter.propertyTypes.isNotEmpty &&
        !filter.propertyTypes.contains(room.type.uiLabel)) {
      return false;
    }
    if (filter.minRating != null && room.rating < filter.minRating!) {
      return false;
    }
    if (filter.amenities.isNotEmpty) {
      bool hasAllAmenities = true;
      for (final requiredAmenity in filter.amenities) {
        if (!room.facilities.any((f) => f.contains(requiredAmenity))) {
          hasAllAmenities = false;
          break;
        }
      }
      if (!hasAllAmenities) return false;
    }
    return true;
  }).toList();
}

@riverpod
Future<List<RoomEntity>> pendingRooms(PendingRoomsRef ref) async {
  ref.watch(authStateProvider);
  final repository = ref.watch(roomRepositoryProvider);
  return await repository.getPendingRooms();
}

@riverpod
Future<List<RoomEntity>> myRooms(MyRoomsRef ref) async {
  ref.watch(authStateProvider);
  final repository = ref.watch(roomRepositoryProvider);
  return await repository.getMyRooms();
}

@riverpod
Future<List<RoomEntity>> adminRooms(AdminRoomsRef ref) async {
  ref.watch(authStateProvider);
  final repository = ref.watch(roomRepositoryProvider);
  return await repository.getAllRoomsAsAdmin();
}

@riverpod
class RoomController extends _$RoomController {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> updateRoomStatus(
    int roomId,
    RoomStatus status, {
    String? rejectionReason,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(roomRepositoryProvider);
      final result = await repository.updateRoomStatus(
        roomId,
        status,
        rejectionReason: rejectionReason,
      );
      if (result) {
        ref.invalidate(roomListProvider);
        ref.invalidate(pendingRoomsProvider);
        ref.invalidate(myRoomsProvider);
        ref.invalidate(adminRoomsProvider);
      }
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> toggleAvailability(int roomId) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(roomRepositoryProvider);
      final result = await repository.toggleRoomAvailability(roomId);
      if (result) {
        ref.invalidate(roomListProvider);
        ref.invalidate(myRoomsProvider);
        ref.invalidate(adminRoomsProvider);
      }
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> deleteRoom(int roomId) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(roomRepositoryProvider);
      final result = await repository.deleteRoom(roomId);
      if (result) {
        ref.invalidate(roomListProvider);
        ref.invalidate(pendingRoomsProvider);
        ref.invalidate(myRoomsProvider);
        ref.invalidate(adminRoomsProvider);
      }
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

extension RoomTypeX on RoomType {
  String get uiLabel {
    switch (this) {
      case RoomType.studio:
        return 'Studio';
      case RoomType.apartment1br:
        return '1BR Apt';
      case RoomType.apartment2br:
        return '2BR Apt';
      case RoomType.dormitory:
        return 'Dormitory';
      case RoomType.villa:
        return 'Villa';
      case RoomType.house:
        return 'House';
      case RoomType.condo:
        return 'Condo';
    }
  }
}
