import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';
import '../utils/user_utils.dart';

class UserEndpoint extends Endpoint {
  /// Fetch all users in the system (Admin only)
  Future<List<User>> getAllUsers(
    Session session, {
    String? searchTerm,
    UserRole? role,
  }) async {
    try {
      final authInfo = session.authenticated;
      if (authInfo == null) {
        throw Exception('Not authenticated');
      }

      final currentUser = await UserUtils.getOrCreateUser(session);
      if (currentUser == null || currentUser.role != UserRole.admin) {
        session.log(
          'Unauthorized access attempt by ${session.authenticated?.userIdentifier}',
          level: LogLevel.warning,
        );
        throw Exception('Unauthorized. Admin access required.');
      }

      WhereExpressionBuilder<UserTable>? where;
      if ((searchTerm != null && searchTerm.trim().isNotEmpty) ||
          role != null) {
        where = (t) {
          Expression? expr;
          if (searchTerm != null && searchTerm.trim().isNotEmpty) {
            final q = searchTerm.trim().toLowerCase();
            expr = (t.fullName.ilike('%$q%') | t.userInfo.email.ilike('%$q%'));
          }
          if (role != null) {
            final roleExpr = t.role.equals(role);
            expr = expr == null ? roleExpr : expr & roleExpr;
          }
          return expr!;
        };
      }

      final users = await User.db.find(
        session,
        where: where,
        orderBy: (t) => t.createdAt,
        orderDescending: true,
        include: User.include(userInfo: UserInfo.include()),
      );

      return users;
    } catch (e, stack) {
      session.log(
        'getAllUsers: Error: $e',
        level: LogLevel.error,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Update a user's role (Admin only)
  Future<bool> updateUserRole(
    Session session,
    int targetUserId,
    UserRole newRole,
  ) async {
    try {
      final authInfo = session.authenticated;
      if (authInfo == null) {
        throw Exception('Not authenticated');
      }

      final currentUser = await UserUtils.getOrCreateUser(session);
      if (currentUser == null || currentUser.role != UserRole.admin) {
        session.log(
          'Unauthorized role update attempt by ${session.authenticated?.userIdentifier}',
          level: LogLevel.warning,
        );
        throw Exception('Unauthorized. Admin access required.');
      }

      final targetUser = await User.db.findById(session, targetUserId);
      if (targetUser == null) {
        throw Exception('Target user not found');
      }

      // Prevent Admins from accidentally demoting themselves
      if (targetUser.id == currentUser.id && newRole != UserRole.admin) {
        throw Exception('Cannot downgrade your own Admin account.');
      }

      targetUser.role = newRole;
      await User.db.updateRow(session, targetUser);

      session.log(
        'Admin ${currentUser.id} updated user ${targetUser.id} role to ${newRole.name}',
      );
      return true;
    } catch (e, stack) {
      session.log(
        'updateUserRole: Error: $e',
        level: LogLevel.error,
        stackTrace: stack,
      );
      return false;
    }
  }

  /// Get statistics about users (Admin only)
  Future<Map<String, int>> getUserStats(Session session) async {
    try {
      final authInfo = session.authenticated;
      if (authInfo == null) {
        throw Exception('Not authenticated');
      }

      final currentUser = await UserUtils.getOrCreateUser(session);
      if (currentUser == null || currentUser.role != UserRole.admin) {
        throw Exception('Unauthorized');
      }

      final total = await User.db.count(session);
      final admins = await User.db.count(
        session,
        where: (t) => t.role.equals(UserRole.admin),
      );
      final owners = await User.db.count(
        session,
        where: (t) => t.role.equals(UserRole.owner),
      );
      final tenants = await User.db.count(
        session,
        where: (t) => t.role.equals(UserRole.tenant),
      );

      return {
        'total': total,
        'admins': admins,
        'owners': owners,
        'tenants': tenants,
      };
    } catch (e) {
      return {};
    }
  }
}
