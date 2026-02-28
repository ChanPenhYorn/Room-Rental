import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(UserInfo user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.failure(String message) = _Failure;
}
