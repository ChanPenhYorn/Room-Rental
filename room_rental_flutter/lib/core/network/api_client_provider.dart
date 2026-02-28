import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:room_rental_client/room_rental_client.dart';

// These are initialized in main() and overridden in ProviderScope
final clientProvider = Provider<Client>((ref) {
  throw UnimplementedError('clientProvider must be overridden in main.dart');
});

// For backward compatibility with some files
final apiClientProvider = clientProvider;
