import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';
import '../utils/cloudinary_service.dart';
import '../utils/user_utils.dart';

class AuthEndpoint extends Endpoint {
  /// Get current user profile
  Future<User?> getMyProfile(Session session) async {
    try {
      final user = await UserUtils.getOrCreateUser(session);
      if (user == null) return null;

      // Always return with UserInfo included for the frontend state
      return await User.db.findFirstRow(
        session,
        where: (t) => t.id.equals(user.id!),
        include: User.include(userInfo: UserInfo.include()),
      );
    } catch (e, stack) {
      session.log(
        'getMyProfile Error: $e',
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
