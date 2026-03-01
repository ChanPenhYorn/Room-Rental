/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:dwellly_client/src/protocol/user.dart' as _i5;
import 'package:dwellly_client/src/protocol/booking.dart' as _i6;
import 'package:dwellly_client/src/protocol/favorite.dart' as _i7;
import 'package:dwellly_client/src/protocol/app_notification.dart' as _i8;
import 'package:dwellly_client/src/protocol/become_owner_request.dart' as _i9;
import 'package:dwellly_client/src/protocol/owner_request_status.dart' as _i10;
import 'package:dwellly_client/src/protocol/payment_request.dart' as _i11;
import 'package:dwellly_client/src/protocol/room.dart' as _i12;
import 'package:dwellly_client/src/protocol/room_type.dart' as _i13;
import 'package:dwellly_client/src/protocol/room_status.dart' as _i14;
import 'package:dwellly_client/src/protocol/user_role.dart' as _i15;
import 'package:dwellly_client/src/protocol/greetings/greeting.dart' as _i16;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i17;
import 'protocol.dart' as _i18;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _i1.EndpointEmailIdpBase {
  EndpointEmailIdp(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i3.Future<_i2.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _i3.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i4.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i3.Future<_i4.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// {@category Endpoint}
class EndpointAuth extends _i2.EndpointRef {
  EndpointAuth(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  /// Get current user profile
  _i3.Future<_i5.User?> getMyProfile() => caller.callServerEndpoint<_i5.User?>(
    'auth',
    'getMyProfile',
    {},
  );

  /// Update profile
  _i3.Future<_i5.User?> updateProfile(
    _i5.User user, {
    String? imageBase64,
  }) => caller.callServerEndpoint<_i5.User?>(
    'auth',
    'updateProfile',
    {
      'user': user,
      'imageBase64': imageBase64,
    },
  );
}

/// {@category Endpoint}
class EndpointBooking extends _i2.EndpointRef {
  EndpointBooking(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'booking';

  /// Create a new booking
  _i3.Future<_i6.Booking?> createBooking(_i6.Booking booking) =>
      caller.callServerEndpoint<_i6.Booking?>(
        'booking',
        'createBooking',
        {'booking': booking},
      );

  /// Get all bookings for the current user
  _i3.Future<List<_i6.Booking>> getMyBookings() =>
      caller.callServerEndpoint<List<_i6.Booking>>(
        'booking',
        'getMyBookings',
        {},
      );

  /// Get a specific booking by ID
  _i3.Future<_i6.Booking?> getBookingById(int id) =>
      caller.callServerEndpoint<_i6.Booking?>(
        'booking',
        'getBookingById',
        {'id': id},
      );
}

/// {@category Endpoint}
class EndpointDev extends _i2.EndpointRef {
  EndpointDev(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'dev';

  /// Retreive the last generated verification code for [email] for testing purposes.
  _i3.Future<String?> getRegistrationCode(String email) =>
      caller.callServerEndpoint<String?>(
        'dev',
        'getRegistrationCode',
        {'email': email},
      );
}

/// Endpoint for managing user favorites.
/// {@category Endpoint}
class EndpointFavorite extends _i2.EndpointRef {
  EndpointFavorite(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'favorite';

  /// Toggles the favorite status of a room.
  _i3.Future<bool> toggleFavorite(int roomId) =>
      caller.callServerEndpoint<bool>(
        'favorite',
        'toggleFavorite',
        {'roomId': roomId},
      );

  /// Get list of favorite room IDs.
  _i3.Future<List<int>> getFavoriteRoomIds() =>
      caller.callServerEndpoint<List<int>>(
        'favorite',
        'getFavoriteRoomIds',
        {},
      );

  /// Get full favorite objects with room details.
  _i3.Future<List<_i7.Favorite>> getUserFavorites() =>
      caller.callServerEndpoint<List<_i7.Favorite>>(
        'favorite',
        'getUserFavorites',
        {},
      );
}

/// {@category Endpoint}
class EndpointNotification extends _i2.EndpointRef {
  EndpointNotification(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notification';

  _i3.Future<List<_i8.AppNotification>> getMyNotifications() =>
      caller.callServerEndpoint<List<_i8.AppNotification>>(
        'notification',
        'getMyNotifications',
        {},
      );

  _i3.Future<int> getUnreadCount() => caller.callServerEndpoint<int>(
    'notification',
    'getUnreadCount',
    {},
  );

  _i3.Future<bool> markAsRead(int notificationId) =>
      caller.callServerEndpoint<bool>(
        'notification',
        'markAsRead',
        {'notificationId': notificationId},
      );

  _i3.Future<bool> markAllAsRead() => caller.callServerEndpoint<bool>(
    'notification',
    'markAllAsRead',
    {},
  );
}

/// {@category Endpoint}
class EndpointOwnerRequest extends _i2.EndpointRef {
  EndpointOwnerRequest(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'ownerRequest';

  /// Submit a request to become an owner
  _i3.Future<_i9.BecomeOwnerRequest?> submitRequest({String? message}) =>
      caller.callServerEndpoint<_i9.BecomeOwnerRequest?>(
        'ownerRequest',
        'submitRequest',
        {'message': message},
      );

  /// Get the current user's most recent owner request
  _i3.Future<_i9.BecomeOwnerRequest?> getMyRequest() =>
      caller.callServerEndpoint<_i9.BecomeOwnerRequest?>(
        'ownerRequest',
        'getMyRequest',
        {},
      );

  /// Get all requests (Admin only)
  _i3.Future<List<_i9.BecomeOwnerRequest>> getAllRequests() =>
      caller.callServerEndpoint<List<_i9.BecomeOwnerRequest>>(
        'ownerRequest',
        'getAllRequests',
        {},
      );

  /// Update request status (Admin only)
  _i3.Future<bool> updateRequestStatus(
    int requestId,
    _i10.OwnerRequestStatus status,
  ) => caller.callServerEndpoint<bool>(
    'ownerRequest',
    'updateRequestStatus',
    {
      'requestId': requestId,
      'status': status,
    },
  );
}

/// {@category Endpoint}
class EndpointPayment extends _i2.EndpointRef {
  EndpointPayment(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'payment';

  _i3.Future<_i11.PaymentRequest?> createAbaPaymentRequest({
    required double amount,
    required int roomId,
  }) => caller.callServerEndpoint<_i11.PaymentRequest?>(
    'payment',
    'createAbaPaymentRequest',
    {
      'amount': amount,
      'roomId': roomId,
    },
  );

  _i3.Future<bool> verifyAbaTransaction(String tranId) =>
      caller.callServerEndpoint<bool>(
        'payment',
        'verifyAbaTransaction',
        {'tranId': tranId},
      );
}

/// {@category Endpoint}
class EndpointRoom extends _i2.EndpointRef {
  EndpointRoom(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'room';

  /// Get all available rooms with owner info
  _i3.Future<List<_i12.Room>> getRooms() =>
      caller.callServerEndpoint<List<_i12.Room>>(
        'room',
        'getRooms',
        {},
      );

  /// Get a specific room by ID with detailed info
  _i3.Future<_i12.Room?> getRoomById(int id) =>
      caller.callServerEndpoint<_i12.Room?>(
        'room',
        'getRoomById',
        {'id': id},
      );

  /// Search rooms by title or location
  _i3.Future<List<_i12.Room>> searchRooms(String query) =>
      caller.callServerEndpoint<List<_i12.Room>>(
        'room',
        'searchRooms',
        {'query': query},
      );

  /// Filter rooms by various criteria
  _i3.Future<List<_i12.Room>> filterRooms({
    double? minPrice,
    double? maxPrice,
    _i13.RoomType? type,
    double? minRating,
  }) => caller.callServerEndpoint<List<_i12.Room>>(
    'room',
    'filterRooms',
    {
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'type': type,
      'minRating': minRating,
    },
  );

  _i3.Future<_i12.Room?> createRoom(_i12.Room room) =>
      caller.callServerEndpoint<_i12.Room?>(
        'room',
        'createRoom',
        {'room': room},
      );

  /// Owner/Admin: Get all rooms owned by the current user
  _i3.Future<List<_i12.Room>> getMyRooms() =>
      caller.callServerEndpoint<List<_i12.Room>>(
        'room',
        'getMyRooms',
        {},
      );

  /// Admin: Get ALL rooms in the system, regardless of status or availability
  _i3.Future<List<_i12.Room>> getAllRoomsAsAdmin() =>
      caller.callServerEndpoint<List<_i12.Room>>(
        'room',
        'getAllRoomsAsAdmin',
        {},
      );

  /// Admin/Owner: Get all pending rooms for review
  /// - Admin: sees ALL pending rooms in the system
  /// - Owner: sees only THEIR OWN pending rooms
  _i3.Future<List<_i12.Room>> getPendingRooms() =>
      caller.callServerEndpoint<List<_i12.Room>>(
        'room',
        'getPendingRooms',
        {},
      );

  /// Admin/Owner: Update room status (approve/reject)
  /// Owner can only update their own rooms; admin can update any.
  _i3.Future<bool> updateRoomStatus(
    int roomId,
    _i14.RoomStatus status, {
    String? rejectionReason,
  }) => caller.callServerEndpoint<bool>(
    'room',
    'updateRoomStatus',
    {
      'roomId': roomId,
      'status': status,
      'rejectionReason': rejectionReason,
    },
  );

  /// Owner/Admin: Toggle isAvailable for a room
  _i3.Future<bool> toggleRoomAvailability(int roomId) =>
      caller.callServerEndpoint<bool>(
        'room',
        'toggleRoomAvailability',
        {'roomId': roomId},
      );

  /// Owner: Request an update to an existing room.
  /// - If the room is already approved, changes are stored in `pendingData`.
  /// - If the room is pending/rejected, changes are applied directly.
  _i3.Future<bool> requestRoomUpdate(
    int roomId,
    _i12.Room updatedRoom,
  ) => caller.callServerEndpoint<bool>(
    'room',
    'requestRoomUpdate',
    {
      'roomId': roomId,
      'updatedRoom': updatedRoom,
    },
  );

  /// Owner/Admin: Delete a room (cascade-deletes all related records first)
  _i3.Future<bool> deleteRoom(int roomId) => caller.callServerEndpoint<bool>(
    'room',
    'deleteRoom',
    {'roomId': roomId},
  );
}

/// {@category Endpoint}
class EndpointSeed extends _i2.EndpointRef {
  EndpointSeed(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'seed';

  _i3.Future<bool> seedData() => caller.callServerEndpoint<bool>(
    'seed',
    'seedData',
    {},
  );
}

/// {@category Endpoint}
class EndpointUser extends _i2.EndpointRef {
  EndpointUser(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  /// Fetch all users in the system (Admin only)
  _i3.Future<List<_i5.User>> getAllUsers({
    String? searchTerm,
    _i15.UserRole? role,
  }) => caller.callServerEndpoint<List<_i5.User>>(
    'user',
    'getAllUsers',
    {
      'searchTerm': searchTerm,
      'role': role,
    },
  );

  /// Update a user's role (Admin only)
  _i3.Future<bool> updateUserRole(
    int targetUserId,
    _i15.UserRole newRole,
  ) => caller.callServerEndpoint<bool>(
    'user',
    'updateUserRole',
    {
      'targetUserId': targetUserId,
      'newRole': newRole,
    },
  );

  /// Get statistics about users (Admin only)
  _i3.Future<Map<String, int>> getUserStats() =>
      caller.callServerEndpoint<Map<String, int>>(
        'user',
        'getUserStats',
        {},
      );

  /// Register/Update FCM token for the current user
  _i3.Future<bool> registerFcmToken(String token) =>
      caller.callServerEndpoint<bool>(
        'user',
        'registerFcmToken',
        {'token': token},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i2.EndpointRef {
  EndpointGreeting(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i3.Future<_i16.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i16.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i17.Caller(client);
    serverpod_auth_idp = _i1.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
  }

  late final _i17.Caller auth;

  late final _i1.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i18.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    auth = EndpointAuth(this);
    booking = EndpointBooking(this);
    dev = EndpointDev(this);
    favorite = EndpointFavorite(this);
    notification = EndpointNotification(this);
    ownerRequest = EndpointOwnerRequest(this);
    payment = EndpointPayment(this);
    room = EndpointRoom(this);
    seed = EndpointSeed(this);
    user = EndpointUser(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAuth auth;

  late final EndpointBooking booking;

  late final EndpointDev dev;

  late final EndpointFavorite favorite;

  late final EndpointNotification notification;

  late final EndpointOwnerRequest ownerRequest;

  late final EndpointPayment payment;

  late final EndpointRoom room;

  late final EndpointSeed seed;

  late final EndpointUser user;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'auth': auth,
    'booking': booking,
    'dev': dev,
    'favorite': favorite,
    'notification': notification,
    'ownerRequest': ownerRequest,
    'payment': payment,
    'room': room,
    'seed': seed,
    'user': user,
    'greeting': greeting,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'auth': modules.auth,
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
