import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../utils/user_utils.dart';

/// Endpoint for managing user favorites.
class FavoriteEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  /// Toggles the favorite status of a room.
  Future<bool> toggleFavorite(Session session, int roomId) async {
    try {
      final user = await UserUtils.getOrCreateUser(session);
      final userId = user?.id;
      if (userId == null) throw Exception('Not authenticated');
      session.log(
        '❤️ Toggling favorite for user $userId, room $roomId',
        level: LogLevel.debug,
      );

      // Verify room exists
      final room = await Room.db.findById(session, roomId);
      if (room == null) {
        session.log('❌ Room $roomId not found', level: LogLevel.warning);
        throw Exception('Room not found');
      }

      return await session.db.transaction<bool>((transaction) async {
        final existing = await Favorite.db.findFirstRow(
          session,
          where: (t) => t.userId.equals(userId) & t.roomId.equals(roomId),
          transaction: transaction,
        );

        if (existing != null) {
          session.log('💔 Removing favorite', level: LogLevel.debug);
          await Favorite.db.deleteRow(
            session,
            existing,
            transaction: transaction,
          );
          return false; // Removed
        } else {
          session.log('💖 Adding favorite', level: LogLevel.debug);
          await Favorite.db.insertRow(
            session,
            Favorite(
              userId: userId,
              roomId: roomId,
              createdAt: DateTime.now().toUtc(),
            ),
            transaction: transaction,
          );
          return true; // Added
        }
      });
    } catch (e, stackTrace) {
      session.log(
        '🔥 Error in toggleFavorite: $e',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
      // Re-throw to ensure client gets strict error if needed, or handle gracefully
      throw Exception('Internal server error in toggleFavorite: $e');
    }
  }

  /// Get list of favorite room IDs.
  Future<List<int>> getFavoriteRoomIds(Session session) async {
    final user = await UserUtils.getOrCreateUser(session);
    final userId = user?.id;
    if (userId == null) return [];

    final favorites = await Favorite.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );
    return favorites.map((f) => f.roomId).toList();
  }

  /// Get full favorite objects with room details.
  Future<List<Favorite>> getUserFavorites(Session session) async {
    final user = await UserUtils.getOrCreateUser(session);
    final userId = user?.id;
    if (userId == null) return [];

    return await Favorite.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      include: Favorite.include(
        room: Room.include(owner: User.include()),
      ),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }
}
