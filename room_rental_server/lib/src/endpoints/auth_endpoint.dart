import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';
import '../utils/cloudinary_service.dart';
import '../utils/user_utils.dart';

/// Returns a comparable rank for user roles (higher = more privileged)
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

class AuthEndpoint extends Endpoint {
  /// Create a new user profile after registration
  Future<User?> createProfile(Session session, User user) async {
    final userInfoId = await UserUtils.getAuthenticatedUserId(session);
    final authInfo = await session.authenticated;

    if (authInfo != null) {
      user.authUserId = authInfo.userIdentifier;
    }

    if (userInfoId != null) {
      user.userInfoId = userInfoId;
    }

    user.createdAt = DateTime.now();
    return await User.db.insertRow(session, user);
  }

  /// Get current user profile
  Future<User?> getMyProfile(Session session) async {
    try {
      final authInfo = session.authenticated;
      if (authInfo == null) {
        session.log('getMyProfile: Not authenticated', level: LogLevel.warning);
        return null;
      }

      final userInfoId = await UserUtils.getAuthenticatedUserId(session);
      final userIdentifier = authInfo.userIdentifier;

      session.log(
        'getMyProfile: Loading profile. userInfoId: $userInfoId, identifier: $userIdentifier',
      );

      // Find ALL user records matching this identity (by userInfoId OR authUserId)
      // This handles the de-duplication case where duplicates were created
      User? user;
      final List<User> matchingUsers = [];

      if (userInfoId != null) {
        final byInfoId = await User.db.find(
          session,
          where: (t) => t.userInfoId.equals(userInfoId),
          include: User.include(userInfo: UserInfo.include()),
        );
        matchingUsers.addAll(byInfoId);
      }

      // Also search by authUserId to catch unlinked records
      final byAuthId = await User.db.find(
        session,
        where: (t) => t.authUserId.equals(userIdentifier),
        include: User.include(userInfo: UserInfo.include()),
      );
      for (final u in byAuthId) {
        if (!matchingUsers.any((m) => m.id == u.id)) {
          matchingUsers.add(u);
        }
      }

      // EMAIL FALLBACK: ALWAYS run this to catch cases where a higher-role
      // record (e.g. owner) is linked via email but a stale tenant record
      // was already found via authUserId. Merging all records ensures the
      // highest role always wins.
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
              include: User.include(userInfo: UserInfo.include()),
            );
            for (final u in byEmail) {
              if (!matchingUsers.any((m) => m.id == u.id)) {
                matchingUsers.add(u);
                session.log(
                  'getMyProfile: Email fallback added record id=${u.id} role=${u.role.name}',
                );
              }
            }
          }
        }
      } catch (e) {
        session.log(
          'getMyProfile: Email fallback error: $e',
          level: LogLevel.warning,
        );
      }

      if (matchingUsers.isNotEmpty) {
        // Prefer the record with the highest role (owner/admin over tenant)
        matchingUsers.sort(
          (a, b) => _roleRank(b.role).compareTo(_roleRank(a.role)),
        );
        user = matchingUsers.first;
        if (matchingUsers.length > 1) {
          session.log(
            'getMyProfile: Found ${matchingUsers.length} records, using id=${user.id} with role=${user.role.name}',
          );
        }

        // Auto-patch authUserId if it's missing — so future lookups are fast
        if (user.authUserId == null || user.authUserId!.isEmpty) {
          session.log(
            'getMyProfile: Patching authUserId=${userIdentifier} on user id=${user.id}',
          );
          user.authUserId = userIdentifier;
          user = await User.db.updateRow(session, user);
        }
      }

      // Auto-create only if truly no record exists
      if (user == null) {
        session.log('getMyProfile: Creating fresh profile');
        user = User(
          userInfoId: userInfoId,
          authUserId: userIdentifier,
          fullName: 'User',
          role: UserRole.tenant,
          createdAt: DateTime.now(),
        );
        user = await User.db.insertRow(session, user);
      }

      // SYNC & RESOLVE CONFLICTS: Ensure we have the latest data
      if (userInfoId != null) {
        final userInfo = await UserInfo.db.findById(session, userInfoId);
        if (userInfo != null) {
          try {
            bool needsUpdate = false;

            // 1. Link if missing
            if (user.userInfoId == null) {
              // Check if another user record already 'owns' this userInfoId
              final conflict = await User.db.findFirstRow(
                session,
                where: (t) =>
                    t.userInfoId.equals(userInfoId) & t.id.notEquals(user!.id!),
              );

              if (conflict != null) {
                session.log(
                  'getMyProfile: Found twin record conflict. Merging UUID into existing record ${conflict.id}',
                );
                conflict.authUserId = userIdentifier;
                if (conflict.fullName == 'User')
                  conflict.fullName = userInfo.fullName ?? 'User';
                user = await User.db.updateRow(session, conflict);
                // Note: We might want to delete the orignal 'user' record here if it was a temporary placeholder
              } else {
                user.userInfoId = userInfoId;
                needsUpdate = true;
              }
            }

            // 2. Sync Name
            if (user.fullName == 'User' && userInfo.fullName != null) {
              user.fullName = userInfo.fullName!;
              needsUpdate = true;
            }

            if (needsUpdate) {
              user = await User.db.updateRow(session, user);
              session.log(
                'getMyProfile: Synced profile with UserInfo ID: $userInfoId',
              );
            }
          } catch (e) {
            session.log(
              'getMyProfile: Sync warning (ignoring duplicate key): $e',
              level: LogLevel.warning,
            );
          }
        }
      }

      // Re-fetch clean copy
      return await User.db.findFirstRow(
        session,
        where: (t) => t.id.equals(user!.id!),
        include: User.include(userInfo: UserInfo.include()),
      );
    } catch (e, stack) {
      session.log(
        'getMyProfile: Error: $e',
        level: LogLevel.error,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Update profile
  Future<User?> updateProfile(
    Session session,
    User user, {
    String? imageBase64,
  }) async {
    try {
      final userInfoId = await UserUtils.getAuthenticatedUserId(session);
      if (userInfoId == null) {
        session.log(
          'updateProfile: Not authenticated',
          level: LogLevel.warning,
        );
        return null;
      }

      session.log(
        'updateProfile: Updating profile for user.id=${user.id}, userInfoId=$userInfoId',
      );

      // Crucial: If the incoming user object has no ID or wrong userInfoId, fix it
      if (user.id == null) {
        // Find the existing record in DB to get the correct ID
        final existing = await User.db.findFirstRow(
          session,
          where: (t) =>
              t.userInfoId.equals(userInfoId) |
              t.authUserId.equals(user.authUserId ?? ''),
        );
        if (existing != null) {
          user.id = existing.id;
          user.userInfoId = existing.userInfoId;
        }
      }

      // Authorization check (must match the authenticated user)
      if (user.userInfoId != null && user.userInfoId != userInfoId) {
        session.log(
          'updateProfile: Unauthorized update attempt. target=${user.userInfoId}, auth=$userInfoId',
          level: LogLevel.error,
        );
        return null;
      }

      // Sync IDs
      user.userInfoId = userInfoId;

      if (imageBase64 != null) {
        try {
          final service = CloudinaryService(session);
          var base64String = imageBase64;
          if (base64String.contains(',')) {
            base64String = base64String.split(',').last;
          }

          final bytes = base64Decode(base64String);
          final response = await service.uploadImageBytes(
            session,
            bytes,
            folder: 'users/$userInfoId',
            publicId: 'profile_${DateTime.now().millisecondsSinceEpoch}',
          );

          if (response != null && response.secureUrl != null) {
            session.log(
              'updateProfile: Image uploaded successfully: ${response.secureUrl}',
            );
            user.profileImage = response.secureUrl;

            // Also update UserInfo imageUrl for auth state
            final userInfo = await UserInfo.db.findById(session, userInfoId);
            if (userInfo != null) {
              userInfo.imageUrl = response.secureUrl;
              userInfo.fullName = user.fullName;
              await UserInfo.db.updateRow(session, userInfo);
              session.log('updateProfile: Updated UserInfo with new image');
            }
          }
        } catch (e, stack) {
          session.log(
            'Error updating profile image: $e',
            level: LogLevel.error,
            stackTrace: stack,
          );
        }
      } else {
        // Sync name to UserInfo even if no image
        final userInfo = await UserInfo.db.findById(session, userInfoId);
        if (userInfo != null) {
          userInfo.fullName = user.fullName;
          await UserInfo.db.updateRow(session, userInfo);
        }
      }

      // Save to database
      final updatedUser = await User.db.updateRow(session, user);
      session.log('updateProfile: Successfully updated User row');
      return updatedUser;
    } catch (e, stack) {
      session.log(
        'updateProfile: Crash prevented: $e',
        level: LogLevel.error,
        stackTrace: stack,
      );
      // Return the current state if update failed to prevent app crash
      return user;
    }
  }
}
