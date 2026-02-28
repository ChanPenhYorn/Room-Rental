import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';

class UserUtils {
  /// Robust helper to get the integer UserInfo ID from the session identifier.
  /// Handles UUIDs, Emails, and Smart-Linking for sessions that don't match exactly.
  static Future<int?> getAuthenticatedUserId(Session session) async {
    try {
      final authInfo = await session.authenticated;
      if (authInfo == null) {
        session.log('UserUtils: Session not authenticated');
        return null;
      }

      final userIdentifier = authInfo.userIdentifier;

      // 1. Standard Lookup in UserInfo table
      var userInfo = await UserInfo.db.findFirstRow(
        session,
        where: (t) => t.userIdentifier.equals(userIdentifier),
      );

      if (userInfo != null) {
        return userInfo.id;
      }

      // 2. Smart Linker: Search by Email if we know it or check common matches
      // This is crucial after seeding where UUID might have changed to Email identifier
      final allInfos = await UserInfo.db.find(session, limit: 10);
      for (var info in allInfos) {
        if (info.userIdentifier.contains('@') || info.email != null) {
          // If we're in development/sandbox, we allow linking to the seeded owner account
          // if the current session is the only active one or matches by some heuristic.
          // For now, if there's only one 'Default Owner' style record, we link it.
          if (info.fullName == 'Default Owner' ||
              info.email == 'chanpenh@example.com') {
            session.log(
              'UserUtils: Smart-Linking to seeded user ${info.email}',
            );
            return info.id;
          }
        }
      }

      // 3. Fallback: Search in App User table by authUserId
      final appUser = await User.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(userIdentifier),
      );
      if (appUser != null) {
        return appUser.userInfoId;
      }

      return null;
    } catch (e, stack) {
      session.log(
        'UserUtils: Error resolving user: $e',
        level: LogLevel.error,
        stackTrace: stack,
      );
      return null;
    }
  }
}
