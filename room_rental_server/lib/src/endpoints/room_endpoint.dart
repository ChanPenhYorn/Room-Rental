import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../utils/user_utils.dart';

class RoomEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  /// Get all available rooms with owner info
  Future<List<Room>> getRooms(Session session) async {
    return await Room.db.find(
      session,
      where: (t) =>
          t.isAvailable.equals(true) & t.status.equals(RoomStatus.approved),
      include: Room.include(
        owner: User.include(),
      ),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
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
    final userInfoId = await UserUtils.getAuthenticatedUserId(session);
    if (userInfoId == null) return null;

    // Verify user exists and is an owner
    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userInfoId),
    );

    if (user == null || user.role != UserRole.owner) return null;

    room.ownerId = user.id!;
    room.createdAt = DateTime.now();
    room.status = RoomStatus.pending;

    return await Room.db.insertRow(session, room);
  }
}
