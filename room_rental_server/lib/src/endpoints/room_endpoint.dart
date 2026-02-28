import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';
import '../utils/user_utils.dart';

class RoomEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  /// Get all available rooms with owner info
  Future<List<Room>> getRooms(Session session) async {
    final rooms = await Room.db.find(
      session,
      where: (t) =>
          t.isAvailable.equals(true) & t.status.equals(RoomStatus.approved),
      include: Room.include(
        owner: User.include(),
      ),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
    return rooms;
  }

  /// Get a specific room by ID with detailed info
  Future<Room?> getRoomById(Session session, int id) async {
    return await Room.db.findById(
      session,
      id,
      include: Room.include(
        owner: User.include(),
        reviews: Review.includeList(
          include: Review.include(user: User.include()),
        ),
        facilities: RoomFacility.includeList(
          include: RoomFacility.include(facility: Facility.include()),
        ),
      ),
    );
  }

  /// Search rooms by title or location
  Future<List<Room>> searchRooms(Session session, String query) async {
    return await Room.db.find(
      session,
      where: (t) =>
          (t.title.ilike('%$query%') | t.location.ilike('%$query%')) &
          t.isAvailable.equals(true) &
          t.status.equals(RoomStatus.approved),
      include: Room.include(owner: User.include()),
    );
  }

  /// Filter rooms by various criteria
  Future<List<Room>> filterRooms(
    Session session, {
    double? minPrice,
    double? maxPrice,
    RoomType? type,
    double? minRating,
  }) async {
    return await Room.db.find(
      session,
      where: (t) {
        var filter =
            t.isAvailable.equals(true) & t.status.equals(RoomStatus.approved);
        if (minPrice != null) {
          filter &= (t.price >= minPrice);
        }
        if (maxPrice != null) {
          filter &= (t.price <= maxPrice);
        }
        if (type != null) {
          filter &= t.type.equals(type);
        }
        if (minRating != null) {
          filter &= (t.rating >= minRating);
        }
        return filter;
      },
      include: Room.include(owner: User.include()),
    );
  }

  Future<Room?> createRoom(Session session, Room room) async {
    final user = await UserUtils.getOrCreateUser(session);
    if (user == null || user.id == null) {
      session.log(
        'createRoom: Could not resolve user profile',
        level: LogLevel.error,
      );
      return null;
    }

    room.ownerId = user.id!;
    room.createdAt = DateTime.now();
    room.status = RoomStatus.pending;

    final createdRoom = await Room.db.insertRow(session, room);
    session.log(
      'createRoom: Room created with id=${createdRoom.id} for user=${user.id}',
    );
    return createdRoom;
  }

  /// Owner/Admin: Get all rooms owned by the current user
  Future<List<Room>> getMyRooms(Session session) async {
    final user = await UserUtils.getOrCreateUser(session);
    if (user == null || user.id == null) return [];

    return await Room.db.find(
      session,
      where: (t) => t.ownerId.equals(user.id!),
      include: Room.include(owner: User.include()),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Admin: Get ALL rooms in the system, regardless of status or availability
  Future<List<Room>> getAllRoomsAsAdmin(Session session) async {
    final user = await UserUtils.getOrCreateUser(session);
    if (user == null || user.role != UserRole.admin) return [];

    return await Room.db.find(
      session,
      include: Room.include(owner: User.include()),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Admin/Owner: Get all pending rooms for review
  /// - Admin: sees ALL pending rooms in the system
  /// - Owner: sees only THEIR OWN pending rooms
  Future<List<Room>> getPendingRooms(Session session) async {
    final user = await UserUtils.getOrCreateUser(session);
    if (user == null) return [];

    session.log('getPendingRooms: user id=${user.id} role=${user.role.name}');

    if (user.role == UserRole.admin) {
      final rooms = await Room.db.find(
        session,
        where: (t) => t.status.equals(RoomStatus.pending),
        include: Room.include(owner: User.include()),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );
      session.log('getPendingRooms: admin found ${rooms.length} pending');
      return rooms;
    } else if (user.role == UserRole.owner) {
      final rooms = await Room.db.find(
        session,
        where: (t) =>
            t.status.equals(RoomStatus.pending) & t.ownerId.equals(user.id!),
        include: Room.include(owner: User.include()),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );
      session.log('getPendingRooms: owner found ${rooms.length} pending');
      return rooms;
    }

    session.log('getPendingRooms: user has no admin/owner role, returning []');
    return [];
  }

  /// Admin/Owner: Update room status (approve/reject)
  /// Owner can only update their own rooms; admin can update any.
  Future<bool> updateRoomStatus(
    Session session,
    int roomId,
    RoomStatus status, {
    String? rejectionReason,
  }) async {
    final user = await UserUtils.getOrCreateUser(session);
    if (user == null) return false;

    final room = await Room.db.findById(session, roomId);
    if (room == null) return false;

    // Admin can update any room; owner can only update their own
    if (user.role == UserRole.admin ||
        (user.role == UserRole.owner && room.ownerId == user.id)) {
      room.status = status;
      if (status == RoomStatus.rejected && rejectionReason != null) {
        room.rejectionReason = rejectionReason;
      } else if (status == RoomStatus.approved) {
        room.rejectionReason = null;
      }
      await Room.db.updateRow(session, room);
      return true;
    }

    return false;
  }

  /// Owner/Admin: Toggle isAvailable for a room
  Future<bool> toggleRoomAvailability(Session session, int roomId) async {
    final user = await UserUtils.getOrCreateUser(session);
    if (user == null) return false;

    final room = await Room.db.findById(session, roomId);
    if (room == null) return false;

    if (user.role != UserRole.admin && room.ownerId != user.id) return false;

    room.isAvailable = !room.isAvailable;
    await Room.db.updateRow(session, room);
    return true;
  }

  /// Owner/Admin: Delete a room (cascade-deletes all related records first)
  Future<bool> deleteRoom(Session session, int roomId) async {
    final user = await UserUtils.getOrCreateUser(session);
    if (user == null) return false;

    final room = await Room.db.findById(session, roomId);
    if (room == null) return false;

    if (user.role != UserRole.admin && room.ownerId != user.id) return false;

    // 1. Delete favorites referencing this room
    final favs = await Favorite.db.find(
      session,
      where: (t) => t.roomId.equals(roomId),
    );
    if (favs.isNotEmpty) await Favorite.db.delete(session, favs);

    // 2. Delete reviews referencing this room
    final reviews = await Review.db.find(
      session,
      where: (t) => t.roomId.equals(roomId),
    );
    if (reviews.isNotEmpty) await Review.db.delete(session, reviews);

    // 3. Delete room_facility junction rows
    final facilities = await RoomFacility.db.find(
      session,
      where: (t) => t.roomId.equals(roomId),
    );
    if (facilities.isNotEmpty)
      await RoomFacility.db.delete(session, facilities);

    // 4. Delete bookings (and their contracts) referencing this room
    final bookings = await Booking.db.find(
      session,
      where: (t) => t.roomId.equals(roomId),
      include: Booking.include(contract: Contract.include()),
    );
    for (final booking in bookings) {
      if (booking.contract != null) {
        await Contract.db.deleteRow(session, booking.contract!);
      }
    }
    if (bookings.isNotEmpty) await Booking.db.delete(session, bookings);

    // 5. Finally delete the room itself
    await Room.db.deleteRow(session, room);
    session.log('deleteRoom: Deleted room id=$roomId');
    return true;
  }
}
