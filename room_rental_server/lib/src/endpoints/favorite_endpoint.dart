import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart';
import '../generated/protocol.dart';

/// Endpoint for managing user favorites.
class FavoriteEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Helper to get the authenticated UserInfo ID (int) safely.
  /// This handles the case where `session.authenticated.userId` throws a FormatException
  /// because the underlying ID is a UUID string.
  Future<int> _getSafeUserInfoId(Session session) async {
    final auth = session.authenticated;
    if (auth == null) throw Exception('Not authenticated');

    // 1. Try standard integer ID (if supported by auth provider)
    try {
      return auth
          .userId!; // Linter claims non-nullable, but let's keep bang just in case it's actually nullable but flow analysis is confused, or access generic getter.
      // Actually, if linter says "receiver can't be null" for `auth.userId!`, then `auth.userId` is non-nullable.
      // But if it is non-nullable, accessing it might throw.
    } catch (_) {
      // Ignore FormatException from getter if it tries to parse UUID
    }

    final userIdentifier =
        auth.userIdentifier; // This is the String (UUID or Email)
    session.log(
      '🔍 resolving UserID for identifier: $userIdentifier',
      level: LogLevel.debug,
    );

    // 2. Look up UserInfo by identifier (UUID)
    final userInfo = await UserInfo.db.findFirstRow(
      session,
      where: (t) => t.userIdentifier.equals(userIdentifier),
    );
    if (userInfo != null) return userInfo.id!;

    // 3. Fallback: Look up by Email via EmailAccount (UUID -> Email -> UserInfo)
    // This fixes the specific issue observed where session has UUID but UserInfo has Email.
    try {
      final emailAccount = await EmailAccount.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(UuidValue.fromString(userIdentifier)),
      );

      if (emailAccount != null) {
        final byEmail = await UserInfo.db.findFirstRow(
          session,
          where: (t) => t.email.equals(emailAccount.email),
        );
        if (byEmail != null) return byEmail.id!;
      }
    } catch (e) {
      session.log('⚠️ EmailAccount lookup failed: $e', level: LogLevel.warning);
    }

    throw Exception('User not found for identifier: $userIdentifier');
  }

  /// Toggles the favorite status of a room.
  Future<bool> toggleFavorite(Session session, int roomId) async {
    try {
      final userId = await _getSafeUserInfoId(session);
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
    final userId = await _getSafeUserInfoId(session);

    final favorites = await Favorite.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );
    return favorites.map((f) => f.roomId).toList();
  }

  /// Get full favorite objects with room details.
  Future<List<Favorite>> getUserFavorites(Session session) async {
    final userId = await _getSafeUserInfoId(session);

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
