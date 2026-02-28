import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:room_rental_flutter/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError(
    'authRepositoryProvider must be overridden in main.dart',
  );
});
