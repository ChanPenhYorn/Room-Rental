import 'package:room_rental_client/room_rental_client.dart';
import '../entities/room_entity.dart';

abstract class RoomRepository {
  Future<List<RoomEntity>> getRooms();
  Future<RoomEntity?> getRoomById(int id);
  Future<RoomEntity?> createRoom(Room room);
  Future<List<RoomEntity>> getPendingRooms();
  Future<bool> updateRoomStatus(
    int roomId,
    RoomStatus status, {
    String? rejectionReason,
  });
  Future<List<RoomEntity>> getMyRooms();
  Future<List<RoomEntity>> getAllRoomsAsAdmin();
  Future<bool> toggleRoomAvailability(int roomId);
  Future<bool> deleteRoom(int roomId);
  Future<bool> requestRoomUpdate(int roomId, Room updatedRoom);
}
