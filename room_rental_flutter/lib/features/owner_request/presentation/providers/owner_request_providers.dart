import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:room_rental_client/room_rental_client.dart';
import 'package:room_rental_flutter/features/auth/data/providers.dart';
import '../../domain/repositories/owner_request_repository.dart';
import '../../data/repositories/owner_request_repository_impl.dart';

final ownerRequestRepositoryProvider = Provider<OwnerRequestRepository>((ref) {
  final client = ref.watch(authRepositoryProvider).authenticatedClient;
  return OwnerRequestRepositoryImpl(client);
});

final myOwnerRequestProvider = FutureProvider((ref) async {
  final repo = ref.watch(ownerRequestRepositoryProvider);
  return await repo.getMyRequest();
});

final allOwnerRequestsProvider = FutureProvider((ref) async {
  final repo = ref.watch(ownerRequestRepositoryProvider);
  return await repo.getAllRequests();
});

class OwnerRequestController extends StateNotifier<AsyncValue<void>> {
  final OwnerRequestRepository _repository;
  final Ref _ref;

  OwnerRequestController(this._repository, this._ref)
    : super(const AsyncData(null));

  Future<bool> updateRequestStatus(
    int requestId,
    OwnerRequestStatus status,
  ) async {
    state = const AsyncLoading();
    try {
      final success = await _repository.updateRequestStatus(requestId, status);
      if (success) {
        _ref.invalidate(allOwnerRequestsProvider);
        _ref.invalidate(myOwnerRequestProvider);
      }
      state = const AsyncData(null);
      return success;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final ownerRequestControllerProvider =
    StateNotifierProvider<OwnerRequestController, AsyncValue<void>>((ref) {
      return OwnerRequestController(
        ref.watch(ownerRequestRepositoryProvider),
        ref,
      );
    });
