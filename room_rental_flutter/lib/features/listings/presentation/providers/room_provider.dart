import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:room_rental_client/room_rental_client.dart';
import '../../../../core/network/api_client_provider.dart';
import '../../data/repositories/room_repository_impl.dart';
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
    // Category Filter (Tab Bar)
    if (selectedCategory != 'All' && room.type.uiLabel != selectedCategory) {
      return false;
    }

    // Price Filter (Filter Modal)
    if (room.price < filter.minPrice || room.price > filter.maxPrice) {
      return false;
    }

    // Property Types Filter (If selected in Modal)
    if (filter.propertyTypes.isNotEmpty &&
        !filter.propertyTypes.contains(room.type.uiLabel)) {
      return false;
    }

    // Rating Filter
    if (filter.minRating != null && room.rating < filter.minRating!) {
      return false;
    }

    // Amenities Filter
    if (filter.amenities.isNotEmpty) {
      bool hasAllAmenities = true;
      for (final requiredAmenity in filter.amenities) {
        // Simple string match check for demo
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
