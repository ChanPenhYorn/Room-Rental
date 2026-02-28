import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:room_rental_client/room_rental_client.dart';
import 'package:room_rental_flutter/core/network/api_client_provider.dart';

// Provider to fetch all users (Admin only)
final allUsersProvider = FutureProvider.family
    .autoDispose<List<User>, ({String? searchTerm, UserRole? role})>(
      (ref, arg) async {
        final client = ref.watch(apiClientProvider);
        return await client.user.getAllUsers(
          searchTerm: arg.searchTerm,
          role: arg.role,
        );
      },
    );

// Provider to fetch user statistics (Admin only)
final userStatsProvider = FutureProvider.autoDispose<Map<String, int>>((
  ref,
) async {
  final client = ref.watch(apiClientProvider);
  return await client.user.getUserStats();
});

class UserController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  UserController(this._ref) : super(const AsyncData(null));

  Future<bool> updateUserRole(int targetUserId, UserRole newRole) async {
    state = const AsyncLoading();
    try {
      final client = _ref.read(apiClientProvider);
      final success = await client.user.updateUserRole(targetUserId, newRole);

      if (success) {
        state = const AsyncData(null);
        // Invalidate list to refresh
        _ref.invalidate(allUsersProvider);
      } else {
        state = AsyncError('Failed to update role', StackTrace.current);
      }
      return success;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final userControllerProvider =
    StateNotifierProvider<UserController, AsyncValue<void>>((ref) {
      return UserController(ref);
    });
