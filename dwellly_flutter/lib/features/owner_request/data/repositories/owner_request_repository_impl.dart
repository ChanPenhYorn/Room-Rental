import 'package:dwellly_client/room_rental_client.dart';
import '../../domain/repositories/owner_request_repository.dart';

class OwnerRequestRepositoryImpl implements OwnerRequestRepository {
  final Client _client;

  OwnerRequestRepositoryImpl(this._client);

  @override
  Future<BecomeOwnerRequest?> submitRequest({String? message}) async {
    try {
      return await _client.ownerRequest.submitRequest(message: message);
    } catch (e) {
      print('OwnerRequestRepo: submitRequest error: $e');
      return null;
    }
  }

  @override
  Future<BecomeOwnerRequest?> getMyRequest() async {
    try {
      return await _client.ownerRequest.getMyRequest();
    } catch (e) {
      print('OwnerRequestRepo: getMyRequest error: $e');
      return null;
    }
  }

  @override
  Future<List<BecomeOwnerRequest>> getAllRequests() async {
    try {
      return await _client.ownerRequest.getAllRequests();
    } catch (e) {
      print('OwnerRequestRepo: getAllRequests error: $e');
      return [];
    }
  }

  @override
  Future<bool> updateRequestStatus(
    int requestId,
    OwnerRequestStatus status,
  ) async {
    try {
      return await _client.ownerRequest.updateRequestStatus(requestId, status);
    } catch (e) {
      print('OwnerRequestRepo: updateRequestStatus error: $e');
      return false;
    }
  }
}
