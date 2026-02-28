import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';

class UserUtils {
  /// Returns the raw UUID-based userIdentifier from the session, or null.
  static Future<String?> getAuthenticatedUserIdentifier(Session session) async {
    try {
      final authInfo = await session.authenticated;
      return authInfo?.userIdentifier;
    } catch (e, stack) {
      session.log(
        'UserUtils: Error getting userIdentifier: $e',
        level: LogLevel.error,
        stackTrace: stack,
      );
      return null;
    }
  }

  /// Returns the UserInfo integer ID from the session, or null.
  /// Robustly resolves the ID even for seeded users with email-based identifiers.
  static Future<int?> getAuthenticatedUserId(Session session) async {
    try {
      final user = await getOrCreateUser(session);
      return user?.userInfoId;
    } catch (e, stack) {
      session.log(
        'UserUtils: Error resolving userId: $e',
        level: LogLevel.error,
        stackTrace: stack,
      );
      return null;
    }
  }

  /// Robustly finds or creates a User record for the authenticated session.
  /// When multiple records exist for the same identity, prefers the highest role
  /// (admin > owner > tenant) to avoid downgrading an owner to tenant.
  static Future<User?> getOrCreateUser(Session session) async {
    try {
      final authInfo = await session.authenticated;
      if (authInfo == null) return null;

      final userIdentifier = authInfo.userIdentifier;

      // Collect all records matching this identity (authUserId or userInfoId)
      final List<User> matchingUsers = [];

      // 1. Find by authUserId (UUID string)
      final byAuthId = await User.db.find(
        session,
        where: (t) => t.authUserId.equals(userIdentifier),
      );
      matchingUsers.addAll(byAuthId);

      // 2. Also try via UserInfo to catch records only linked by userInfoId
      final userInfo = await UserInfo.db.findFirstRow(
        session,
        where: (t) => t.userIdentifier.equals(userIdentifier),
      );
      if (userInfo?.id != null) {
        final byInfoId = await User.db.find(
          session,
          where: (t) => t.userInfoId.equals(userInfo!.id!),
        );
        for (final u in byInfoId) {
          if (!matchingUsers.any((m) => m.id == u.id)) {
            matchingUsers.add(u);
          }
        }
      }

      // EMAIL FALLBACK: For seeded users whose User.authUserId is null and
      // whose UserInfo.userIdentifier doesn't match the new IDP UUID.
      if (matchingUsers.isEmpty) {
        try {
          final emailResult = await session.db.unsafeSimpleQuery(
            '''SELECT email FROM serverpod_auth_core_profile
               WHERE "authUserId" = '$userIdentifier'
               LIMIT 1''',
          );
          if (emailResult.isNotEmpty) {
            final email = emailResult.first[0] as String;
            final userInfoByEmail = await UserInfo.db.findFirstRow(
              session,
              where: (t) => t.email.equals(email),
            );
            if (userInfoByEmail?.id != null) {
              final byEmail = await User.db.find(
                session,
                where: (t) => t.userInfoId.equals(userInfoByEmail!.id!),
              );
              for (final u in byEmail) {
                if (!matchingUsers.any((m) => m.id == u.id)) {
                  matchingUsers.add(u);
                }
              }
              session.log(
                'UserUtils: Email fallback found ${byEmail.length} record(s) for $userIdentifier',
              );
            }
          }
        } catch (e) {
          session.log(
            'UserUtils: Email fallback error: $e',
            level: LogLevel.warning,
          );
        }
      }

      // If we found existing records, return the highest-role one
      if (matchingUsers.isNotEmpty) {
        matchingUsers.sort(
          (a, b) => _roleRank(b.role).compareTo(_roleRank(a.role)),
        );
        if (matchingUsers.length > 1) {
          session.log(
            'UserUtils: Found ${matchingUsers.length} records for $userIdentifier, using id=${matchingUsers.first.id} role=${matchingUsers.first.role.name}',
          );
        }
        final found = matchingUsers.first;
        // Auto-patch authUserId if missing so future lookups are fast
        if (found.authUserId == null || found.authUserId!.isEmpty) {
          found.authUserId = userIdentifier;
          return await User.db.updateRow(session, found);
        }
        return found;
      }

      // 3. No record found — attempt to find UserInfo via email fallback
      // before creating a new profile. This handles seeded users logging in
      // for the first time with their new UUID session.
      int? resolvedUserInfoId = userInfo?.id;
      String currentFullName = userInfo?.fullName ?? 'User';

      if (resolvedUserInfoId == null) {
        try {
          final emailResult = await session.db.unsafeSimpleQuery(
            '''SELECT email FROM serverpod_auth_core_profile
               WHERE "authUserId" = '$userIdentifier'
               LIMIT 1''',
          );
          if (emailResult.isNotEmpty) {
            final email = emailResult.first[0] as String;
            final userInfoByEmail = await UserInfo.db.findFirstRow(
              session,
              where: (t) => t.email.equals(email),
            );
            if (userInfoByEmail != null) {
              resolvedUserInfoId = userInfoByEmail.id;
              currentFullName = userInfoByEmail.fullName ?? 'User';
              session.log(
                'UserUtils: Recovered UserInfo ID $resolvedUserInfoId via email $email for $userIdentifier',
              );
            }
          }
        } catch (e) {
          session.log('UserUtils: Failed to recover UserInfo via email: $e');
        }
      }

      // 4. Create a new tenant profile
      session.log('UserUtils: Auto-creating profile for $userIdentifier');
      final newUser = User(
        userInfoId: resolvedUserInfoId,
        authUserId: userIdentifier,
        fullName: currentFullName,
        role: UserRole.tenant,
        createdAt: DateTime.now(),
      );
      return await User.db.insertRow(session, newUser);
    } catch (e, stack) {
      session.log(
        'UserUtils: Error in getOrCreateUser: $e',
        level: LogLevel.error,
        stackTrace: stack,
      );
      return null;
    }
  }
}

/// Returns a comparable rank for roles (higher = more privileged).
int _roleRank(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return 3;
    case UserRole.owner:
      return 2;
    case UserRole.tenant:
      return 1;
  }
}
