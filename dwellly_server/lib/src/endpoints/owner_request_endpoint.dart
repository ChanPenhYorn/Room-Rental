import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';
import '../utils/user_utils.dart';
import '../utils/notification_utils.dart';

class OwnerRequestEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Submit a request to become an owner
  Future<BecomeOwnerRequest?> submitRequest(
    Session session, {
    String? message,
  }) async {
    session.log(
      'OwnerRequestEndpoint: Starting submitRequest for message: $message',
    );
    final user = await UserUtils.getOrCreateUser(session);
    if (user == null) {
      session.log('OwnerRequestEndpoint: User profile not found');
      return null;
    }
    session.log('OwnerRequestEndpoint: Found user id: ${user.id}');

    // Check if there's already a pending or approved request
    final existingRequest = await BecomeOwnerRequest.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(user.id!),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
    session.log(
      'OwnerRequestEndpoint: Existing request found: ${existingRequest?.id}, status: ${existingRequest?.status}',
    );

    if (existingRequest != null &&
        (existingRequest.status == OwnerRequestStatus.pending ||
            existingRequest.status == OwnerRequestStatus.approved)) {
      session.log('OwnerRequestEndpoint: Returning existing request');
      return existingRequest;
    }

    session.log('OwnerRequestEndpoint: Inserting new request');
    final request = BecomeOwnerRequest(
      userId: user.id!,
      message: message,
      status: OwnerRequestStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final inserted = await BecomeOwnerRequest.db.insertRow(session, request);
    session.log('OwnerRequestEndpoint: Inserted request id: ${inserted.id}');

    // Notify Admins
    await NotificationUtils.notifyAdmins(
      session,
      title: 'New Owner Request',
      body: '${user.fullName} has requested to become an owner.',
      data: {'type': 'owner_request', 'requestId': inserted.id.toString()},
    );

    return inserted;
  }

  /// Get the current user's most recent owner request
  Future<BecomeOwnerRequest?> getMyRequest(Session session) async {
    final user = await UserUtils.getOrCreateUser(session);
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
    final user = await UserUtils.getOrCreateUser(session);
    if (user == null || user.role != UserRole.admin) return [];

    return await BecomeOwnerRequest.db.find(
      session,
      include: BecomeOwnerRequest.include(
        user: User.include(userInfo: UserInfo.include()),
      ),
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
    final adminUser = await UserUtils.getOrCreateUser(session);
    if (adminUser == null || adminUser.role != UserRole.admin) return false;

    final request = await BecomeOwnerRequest.db.findById(session, requestId);
    if (request == null) return false;

    request.status = status;
    request.updatedAt = DateTime.now();

    await BecomeOwnerRequest.db.updateRow(session, request);

    // Notify User
    await NotificationUtils.sendNotification(
      session,
      recipientId: request.userId,
      title:
          'Owner Request ${status == OwnerRequestStatus.approved ? 'Approved' : 'Rejected'}',
      body: status == OwnerRequestStatus.approved
          ? 'Congratulations! You are now an owner.'
          : 'Your request to become an owner was rejected.',
      data: {'type': 'owner_request_status', 'status': status.name},
    );

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
