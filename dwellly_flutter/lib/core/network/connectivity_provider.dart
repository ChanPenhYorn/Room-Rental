import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dwellly_client/room_rental_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../network/api_client_provider.dart';

part 'connectivity_provider.g.dart';

@riverpod
Stream<List<ConnectivityResult>> connectivity(ConnectivityRef ref) {
  return Connectivity().onConnectivityChanged;
}

@riverpod
class NetworkController extends _$NetworkController {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> checkServerHealth() async {
    state = const AsyncValue.loading();
    try {
      final client = ref.read(clientProvider);
      // We'll perform a simple light-weight call if available,
      // otherwise just try to connect to the base URL
      final serverUrl = client.host;

      try {
        final result = await InternetAddress.lookup(Uri.parse(serverUrl).host);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // Basic DNS/IP check passed, now let's try a simple endpoint
          // Since we don't have a specific 'ping' endpoint, we'll try a common one
          // that is likely to be fast.
          await client.room.getRooms().timeout(const Duration(seconds: 5));
          state = const AsyncValue.data(null);
          return true;
        }
      } catch (_) {
        // Fallback or specific error handling
      }

      state = const AsyncValue.data(null);
      return false;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
