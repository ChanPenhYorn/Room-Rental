import 'package:dwellly_client/room_rental_client.dart';

abstract class OwnerRequestRepository {
  Future<BecomeOwnerRequest?> submitRequest({String? message});
  Future<BecomeOwnerRequest?> getMyRequest();
  Future<List<BecomeOwnerRequest>> getAllRequests();
  Future<bool> updateRequestStatus(int requestId, OwnerRequestStatus status);
}
