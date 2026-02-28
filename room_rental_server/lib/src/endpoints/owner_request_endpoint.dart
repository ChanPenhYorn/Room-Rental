import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../utils/user_utils.dart';

class OwnerRequestEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Submit a request to become an owner
  Future<BecomeOwnerRequest?> submitRequest(
    Session session, {
    String? message,
  }) async {
    final userInfoId = await UserUtils.getAuthenticatedUserId(session);
    if (userInfoId == null) return null;

    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userInfoId),
    );

    if (user == null) return null;

    // Check if there's already a pending or approved request
    final existingRequest = await BecomeOwnerRequest.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(user.id!),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );

    if (existingRequest != null &&
        (existingRequest.status == OwnerRequestStatus.pending ||
            existingRequest.status == OwnerRequestStatus.approved)) {
      return existingRequest;
    }

    final request = BecomeOwnerRequest(
      userId: user.id!,
      message: message,
      status: OwnerRequestStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await BecomeOwnerRequest.db.insertRow(session, request);
  }

  /// Get the current user's most recent owner request
  Future<BecomeOwnerRequest?> getMyRequest(Session session) async {
    final userInfoId = await UserUtils.getAuthenticatedUserId(session);
    if (userInfoId == null) return null;

    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userInfoId),
    );

    if (user == null) return null;

    return await BecomeOwnerRequest.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(user.id!),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Get all requests (Admin only)
  Future<List<BecomeOwnerRequest>> getAllRequests(Session session) async {
    final userInfoId = await UserUtils.getAuthenticatedUserId(session);
    if (userInfoId == null) return [];

    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userInfoId),
    );

    if (user == null || user.role != UserRole.admin) return [];

    return await BecomeOwnerRequest.db.find(
      session,
      include: BecomeOwnerRequest.include(user: User.include()),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Update request status (Admin only)
  Future<bool> updateRequestStatus(
    Session session,
    int requestId,
    OwnerRequestStatus status,
  ) async {
    final userInfoId = await UserUtils.getAuthenticatedUserId(session);
    if (userInfoId == null) return false;

    final adminUser = await User.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userInfoId),
    );

    if (adminUser == null || adminUser.role != UserRole.admin) return false;

    final request = await BecomeOwnerRequest.db.findById(session, requestId);
    if (request == null) return false;

    request.status = status;
    request.updatedAt = DateTime.now();

    await BecomeOwnerRequest.db.updateRow(session, request);

    // If approved, update user role to owner
    if (status == OwnerRequestStatus.approved) {
      final user = await User.db.findById(session, request.userId);
      if (user != null) {
        user.role = UserRole.owner;
        await User.db.updateRow(session, user);
      }
    }

    return true;
  }
}
