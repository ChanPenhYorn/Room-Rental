import 'package:dwellly_client/room_rental_client.dart';
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

  @override
  Future<RoomEntity?> createRoom(Room room) async {
    try {
      final result = await client.room.createRoom(room);
      if (result == null) {
        print('❌ [API] createRoom returned null from server');
        return null;
      }
      print('✅ [API] createRoom succeeded, id=${result.id}');
      return _mapToEntity(result);
    } catch (e, stack) {
      print('❌ [API] Error creating room: $e');
      print('❌ [API] Stack: $stack');
      return null;
    }
  }

  @override
  Future<List<RoomEntity>> getPendingRooms() async {
    try {
      final rooms = await client.room.getPendingRooms();
      print('✅ [API] Got ${rooms.length} pending rooms from server');
      return rooms.map((room) => _mapToEntity(room)).toList();
    } catch (e) {
      print('❌ [API] Error fetching pending rooms: $e');
      return [];
    }
  }

  @override
  Future<bool> updateRoomStatus(
    int roomId,
    RoomStatus status, {
    String? rejectionReason,
  }) async {
    try {
      return await client.room.updateRoomStatus(
        roomId,
        status,
        rejectionReason: rejectionReason,
      );
    } catch (e) {
      print('❌ [API] Error updating room status: $e');
      return false;
    }
  }

  @override
  Future<List<RoomEntity>> getMyRooms() async {
    try {
      final rooms = await client.room.getMyRooms();
      print('✅ [API] Got ${rooms.length} my rooms from server');
      return rooms.map((room) => _mapToEntity(room)).toList();
    } catch (e) {
      print('❌ [API] Error fetching my rooms: $e');
      return [];
    }
  }

  @override
  Future<List<RoomEntity>> getAllRoomsAsAdmin() async {
    try {
      final rooms = await client.room.getAllRoomsAsAdmin();
      print('✅ [API] Got ${rooms.length} total rooms from server for admin');
      return rooms.map((room) => _mapToEntity(room)).toList();
    } catch (e) {
      print('❌ [API] Error fetching all admin rooms: $e');
      return [];
    }
  }

  @override
  Future<bool> toggleRoomAvailability(int roomId) async {
    try {
      return await client.room.toggleRoomAvailability(roomId);
    } catch (e) {
      print('❌ [API] Error toggling room availability: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteRoom(int roomId) async {
    try {
      return await client.room.deleteRoom(roomId);
    } catch (e) {
      print('❌ [API] Error deleting room: $e');
      return false;
    }
  }

  RoomEntity _mapToEntity(Room dto) {
    return RoomEntity(
      id: dto.id ?? 0,
      ownerId: dto.ownerId,
      title: dto.title ?? '',
      description: dto.description ?? '',
      price: dto.price ?? 0.0,
      location: dto.location ?? '',
      latitude: dto.latitude ?? 0.0,
      longitude: dto.longitude ?? 0.0,
      imageUrl: dto.imageUrl,
      images: dto.images ?? [],
      isAvailable: dto.isAvailable ?? true,
      rating: dto.rating ?? 0.0,
      type: dto.type ?? RoomType.apartment1br,
      status: dto.status ?? RoomStatus.pending,
      ownerName: dto.owner?.fullName,
      rejectionReason: dto.rejectionReason,
      facilities:
          dto.facilities
              ?.map((f) => f.facility?.name ?? '')
              .where((n) => n.isNotEmpty)
              .toList() ??
          [],
      hasPendingEdit: dto.hasPendingEdit,
      pendingData: dto.pendingData,
    );
  }

  @override
  Future<bool> requestRoomUpdate(int roomId, Room updatedRoom) async {
    try {
      return await client.room.requestRoomUpdate(roomId, updatedRoom);
    } catch (e) {
      print('❌ [API] Error requesting room update: $e');
      return false;
    }
  }
}
