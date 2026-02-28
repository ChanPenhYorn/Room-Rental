import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/data/providers.dart';

part 'favourite_provider.g.dart';

/// Provider that manages user's favorite rooms with server persistence.
@riverpod
class FavouriteRooms extends _$FavouriteRooms {
  @override
  Future<List<int>> build() async {
    // Load favorite room IDs from server on initialization
    return await _loadFavorites();
  }

  /// Load favorites from server
  Future<List<int>> _loadFavorites() async {
    try {
      final user = await ref.read(authRepositoryProvider).getCurrentUser();
      if (user == null) {
        return [];
      }

      final authRepo = ref.read(authRepositoryProvider);
      final client = authRepo.authenticatedClient;

      final favoriteIds = await client.favorite.getFavoriteRoomIds();
      debugPrint(
        '✅ [FavoritesProvider] Loaded ${favoriteIds.length} favorites',
      );
      return favoriteIds;
    } catch (e) {
      debugPrint('❌ [FavoritesProvider] Error loading favorites: $e');
      return [];
    }
  }

  /// Toggle favorite status for a room.
  /// Uses optimistic updates for immediate UI feedback.
  Future<void> toggleFavourite(int roomId) async {
    try {
      // Check authentication first
      final user = await ref.read(authRepositoryProvider).getCurrentUser();
      if (user == null) {
        debugPrint(
          '❌ [FavoritesProvider] Cannot toggle favorite: User not authenticated',
        );
        throw Exception('Please login to save favorites');
      }

      final authRepo = ref.read(authRepositoryProvider);
      final client = authRepo.authenticatedClient;

      // Optimistic Update
      final currentIds = state.value ?? [];
      final isFavorited = currentIds.contains(roomId);
      final newIds = isFavorited
          ? currentIds.where((id) => id != roomId).toList()
          : [...currentIds, roomId];

      state = AsyncValue.data(newIds);

      debugPrint(
        '📡 [FavoritesProvider] Toggling favorite for room $roomId (Optimistic: ${!isFavorited})',
      );

      // Sync with server
      try {
        final result = await client.favorite.toggleFavorite(roomId);
        debugPrint('✅ [FavoritesProvider] Synced with server: $result');
      } catch (e) {
        debugPrint('❌ [FavoritesProvider] Server error: $e');
        // Revert optimistic update
        ref.invalidateSelf();
        rethrow;
      }
    } catch (e, st) {
      debugPrint('❌ [FavoritesProvider] Error toggling favorite: $e\n$st');
      // Revert optimistic update
      ref.invalidateSelf();
      rethrow;
    }
  }

  /// Helper to check if a room is favorited
  bool isFavourite(int roomId) {
    return state.value?.contains(roomId) ?? false;
  }
}
