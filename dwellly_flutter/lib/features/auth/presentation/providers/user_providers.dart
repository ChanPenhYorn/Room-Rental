import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dwellly_client/room_rental_client.dart';
import 'package:dwellly_flutter/features/auth/data/providers.dart';

/// Provider for the full User profile (including role, etc.)
final userProfileProvider = FutureProvider<User?>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final client = authRepo.authenticatedClient;

  try {
    return await client.auth.getMyProfile();
  } catch (e) {
    print('❌ [userProfileProvider] Error fetching profile: $e');
    return null;
  }
});
