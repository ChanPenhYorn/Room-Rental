import 'package:room_rental_client/room_rental_client.dart';
import '../../domain/repositories/room_repository.dart';
import '../../domain/entities/room_entity.dart';

class RoomRepositoryImpl implements RoomRepository {
  final Client client;

  RoomRepositoryImpl(this.client);

  @override
  Future<List<RoomEntity>> getRooms() async {
    try {
      print('🔵 [API] Calling client.room.getRooms()...');
      final result = await client.room.getRooms();
      print('✅ [API] Got ${result.length} rooms from server');
      return result.map((e) => _mapToEntity(e)).toList();
    } catch (e) {
      print('❌ [API] Error fetching rooms: $e');
      throw Exception('Failed to fetch rooms: $e');
    }
  }

  @override
  Future<RoomEntity?> getRoomById(int id) async {
    try {
      final result = await client.room.getRoomById(id);
      if (result == null) return null;
      return _mapToEntity(result);
    } catch (e) {
      return null;
    }
  }

  RoomEntity _mapToEntity(Room dto) {
    return RoomEntity(
      id: dto.id ?? 0,
      title: dto.title,
      description: dto.description,
      price: dto.price,
      location: dto.location,
      latitude: dto.latitude,
      longitude: dto.longitude,
      imageUrl: dto.imageUrl,
      images: dto.images ?? [],
      isAvailable: dto.isAvailable,
      rating: dto.rating,
      type: dto.type,
      facilities:
          dto.facilities
              ?.map((f) => f.facility?.name ?? '')
              .where((n) => n.isNotEmpty)
              .toList() ??
          [],
    );
  }
}
