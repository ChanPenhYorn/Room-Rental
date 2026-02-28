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
import 'package:serverpod/serverpod.dart' as _i1;
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/jwt_refresh_endpoint.dart' as _i3;
import '../endpoints/auth_endpoint.dart' as _i4;
import '../endpoints/booking_endpoint.dart' as _i5;
import '../endpoints/dev_endpoint.dart' as _i6;
import '../endpoints/favorite_endpoint.dart' as _i7;
import '../endpoints/owner_request_endpoint.dart' as _i8;
import '../endpoints/payment_endpoint.dart' as _i9;
import '../endpoints/room_endpoint.dart' as _i10;
import '../endpoints/seed_endpoint.dart' as _i11;
import '../endpoints/user_endpoint.dart' as _i12;
import '../greetings/greeting_endpoint.dart' as _i13;
import 'package:dwellly_server/src/generated/user.dart' as _i14;
import 'package:dwellly_server/src/generated/booking.dart' as _i15;
import 'package:dwellly_server/src/generated/owner_request_status.dart' as _i16;
import 'package:dwellly_server/src/generated/room_type.dart' as _i17;
import 'package:dwellly_server/src/generated/room.dart' as _i18;
import 'package:dwellly_server/src/generated/room_status.dart' as _i19;
import 'package:dwellly_server/src/generated/user_role.dart' as _i20;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i21;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i22;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i23;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i3.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'auth': _i4.AuthEndpoint()
        ..initialize(
          server,
          'auth',
          null,
        ),
      'booking': _i5.BookingEndpoint()
        ..initialize(
          server,
          'booking',
          null,
        ),
      'dev': _i6.DevEndpoint()
        ..initialize(
          server,
          'dev',
          null,
        ),
      'favorite': _i7.FavoriteEndpoint()
        ..initialize(
          server,
          'favorite',
          null,
        ),
      'ownerRequest': _i8.OwnerRequestEndpoint()
        ..initialize(
          server,
          'ownerRequest',
          null,
        ),
      'payment': _i9.PaymentEndpoint()
        ..initialize(
          server,
          'payment',
          null,
        ),
      'room': _i10.RoomEndpoint()
        ..initialize(
          server,
          'room',
          null,
        ),
      'seed': _i11.SeedEndpoint()
        ..initialize(
          server,
          'seed',
          null,
        ),
      'user': _i12.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
      'greeting': _i13.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i3.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['auth'] = _i1.EndpointConnector(
      name: 'auth',
      endpoint: endpoints['auth']!,
      methodConnectors: {
        'getMyProfile': _i1.MethodConnector(
          name: 'getMyProfile',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['auth'] as _i4.AuthEndpoint).getMyProfile(session),
        ),
        'updateProfile': _i1.MethodConnector(
          name: 'updateProfile',
          params: {
            'user': _i1.ParameterDescription(
              name: 'user',
              type: _i1.getType<_i14.User>(),
              nullable: false,
            ),
            'imageBase64': _i1.ParameterDescription(
              name: 'imageBase64',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i4.AuthEndpoint).updateProfile(
                session,
                params['user'],
                imageBase64: params['imageBase64'],
              ),
        ),
      },
    );
    connectors['booking'] = _i1.EndpointConnector(
      name: 'booking',
      endpoint: endpoints['booking']!,
      methodConnectors: {
        'createBooking': _i1.MethodConnector(
          name: 'createBooking',
          params: {
            'booking': _i1.ParameterDescription(
              name: 'booking',
              type: _i1.getType<_i15.Booking>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['booking'] as _i5.BookingEndpoint).createBooking(
                    session,
                    params['booking'],
                  ),
        ),
        'getMyBookings': _i1.MethodConnector(
          name: 'getMyBookings',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['booking'] as _i5.BookingEndpoint)
                  .getMyBookings(session),
        ),
        'getBookingById': _i1.MethodConnector(
          name: 'getBookingById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['booking'] as _i5.BookingEndpoint).getBookingById(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['dev'] = _i1.EndpointConnector(
      name: 'dev',
      endpoint: endpoints['dev']!,
      methodConnectors: {
        'getRegistrationCode': _i1.MethodConnector(
          name: 'getRegistrationCode',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['dev'] as _i6.DevEndpoint).getRegistrationCode(
                    session,
                    params['email'],
                  ),
        ),
      },
    );
    connectors['favorite'] = _i1.EndpointConnector(
      name: 'favorite',
      endpoint: endpoints['favorite']!,
      methodConnectors: {
        'toggleFavorite': _i1.MethodConnector(
          name: 'toggleFavorite',
          params: {
            'roomId': _i1.ParameterDescription(
              name: 'roomId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['favorite'] as _i7.FavoriteEndpoint)
                  .toggleFavorite(
                    session,
                    params['roomId'],
                  ),
        ),
        'getFavoriteRoomIds': _i1.MethodConnector(
          name: 'getFavoriteRoomIds',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['favorite'] as _i7.FavoriteEndpoint)
                  .getFavoriteRoomIds(session),
        ),
        'getUserFavorites': _i1.MethodConnector(
          name: 'getUserFavorites',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['favorite'] as _i7.FavoriteEndpoint)
                  .getUserFavorites(session),
        ),
      },
    );
    connectors['ownerRequest'] = _i1.EndpointConnector(
      name: 'ownerRequest',
      endpoint: endpoints['ownerRequest']!,
      methodConnectors: {
        'submitRequest': _i1.MethodConnector(
          name: 'submitRequest',
          params: {
            'message': _i1.ParameterDescription(
              name: 'message',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ownerRequest'] as _i8.OwnerRequestEndpoint)
                  .submitRequest(
                    session,
                    message: params['message'],
                  ),
        ),
        'getMyRequest': _i1.MethodConnector(
          name: 'getMyRequest',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ownerRequest'] as _i8.OwnerRequestEndpoint)
                  .getMyRequest(session),
        ),
        'getAllRequests': _i1.MethodConnector(
          name: 'getAllRequests',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ownerRequest'] as _i8.OwnerRequestEndpoint)
                  .getAllRequests(session),
        ),
        'updateRequestStatus': _i1.MethodConnector(
          name: 'updateRequestStatus',
          params: {
            'requestId': _i1.ParameterDescription(
              name: 'requestId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<_i16.OwnerRequestStatus>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ownerRequest'] as _i8.OwnerRequestEndpoint)
                  .updateRequestStatus(
                    session,
                    params['requestId'],
                    params['status'],
                  ),
        ),
      },
    );
    connectors['payment'] = _i1.EndpointConnector(
      name: 'payment',
      endpoint: endpoints['payment']!,
      methodConnectors: {
        'createAbaPaymentRequest': _i1.MethodConnector(
          name: 'createAbaPaymentRequest',
          params: {
            'amount': _i1.ParameterDescription(
              name: 'amount',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'roomId': _i1.ParameterDescription(
              name: 'roomId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i9.PaymentEndpoint)
                  .createAbaPaymentRequest(
                    session,
                    amount: params['amount'],
                    roomId: params['roomId'],
                  ),
        ),
        'verifyAbaTransaction': _i1.MethodConnector(
          name: 'verifyAbaTransaction',
          params: {
            'tranId': _i1.ParameterDescription(
              name: 'tranId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i9.PaymentEndpoint)
                  .verifyAbaTransaction(
                    session,
                    params['tranId'],
                  ),
        ),
      },
    );
    connectors['room'] = _i1.EndpointConnector(
      name: 'room',
      endpoint: endpoints['room']!,
      methodConnectors: {
        'getRooms': _i1.MethodConnector(
          name: 'getRooms',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['room'] as _i10.RoomEndpoint).getRooms(session),
        ),
        'getRoomById': _i1.MethodConnector(
          name: 'getRoomById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['room'] as _i10.RoomEndpoint).getRoomById(
                session,
                params['id'],
              ),
        ),
        'searchRooms': _i1.MethodConnector(
          name: 'searchRooms',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['room'] as _i10.RoomEndpoint).searchRooms(
                session,
                params['query'],
              ),
        ),
        'filterRooms': _i1.MethodConnector(
          name: 'filterRooms',
          params: {
            'minPrice': _i1.ParameterDescription(
              name: 'minPrice',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'maxPrice': _i1.ParameterDescription(
              name: 'maxPrice',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<_i17.RoomType?>(),
              nullable: true,
            ),
            'minRating': _i1.ParameterDescription(
              name: 'minRating',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['room'] as _i10.RoomEndpoint).filterRooms(
                session,
                minPrice: params['minPrice'],
                maxPrice: params['maxPrice'],
                type: params['type'],
                minRating: params['minRating'],
              ),
        ),
        'createRoom': _i1.MethodConnector(
          name: 'createRoom',
          params: {
            'room': _i1.ParameterDescription(
              name: 'room',
              type: _i1.getType<_i18.Room>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['room'] as _i10.RoomEndpoint).createRoom(
                session,
                params['room'],
              ),
        ),
        'getMyRooms': _i1.MethodConnector(
          name: 'getMyRooms',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['room'] as _i10.RoomEndpoint).getMyRooms(session),
        ),
        'getAllRoomsAsAdmin': _i1.MethodConnector(
          name: 'getAllRoomsAsAdmin',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['room'] as _i10.RoomEndpoint)
                  .getAllRoomsAsAdmin(session),
        ),
        'getPendingRooms': _i1.MethodConnector(
          name: 'getPendingRooms',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['room'] as _i10.RoomEndpoint)
                  .getPendingRooms(session),
        ),
        'updateRoomStatus': _i1.MethodConnector(
          name: 'updateRoomStatus',
          params: {
            'roomId': _i1.ParameterDescription(
              name: 'roomId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<_i19.RoomStatus>(),
              nullable: false,
            ),
            'rejectionReason': _i1.ParameterDescription(
              name: 'rejectionReason',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['room'] as _i10.RoomEndpoint).updateRoomStatus(
                    session,
                    params['roomId'],
                    params['status'],
                    rejectionReason: params['rejectionReason'],
                  ),
        ),
        'toggleRoomAvailability': _i1.MethodConnector(
          name: 'toggleRoomAvailability',
          params: {
            'roomId': _i1.ParameterDescription(
              name: 'roomId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['room'] as _i10.RoomEndpoint)
                  .toggleRoomAvailability(
                    session,
                    params['roomId'],
                  ),
        ),
        'requestRoomUpdate': _i1.MethodConnector(
          name: 'requestRoomUpdate',
          params: {
            'roomId': _i1.ParameterDescription(
              name: 'roomId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'updatedRoom': _i1.ParameterDescription(
              name: 'updatedRoom',
              type: _i1.getType<_i18.Room>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['room'] as _i10.RoomEndpoint).requestRoomUpdate(
                    session,
                    params['roomId'],
                    params['updatedRoom'],
                  ),
        ),
        'deleteRoom': _i1.MethodConnector(
          name: 'deleteRoom',
          params: {
            'roomId': _i1.ParameterDescription(
              name: 'roomId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['room'] as _i10.RoomEndpoint).deleteRoom(
                session,
                params['roomId'],
              ),
        ),
      },
    );
    connectors['seed'] = _i1.EndpointConnector(
      name: 'seed',
      endpoint: endpoints['seed']!,
      methodConnectors: {
        'seedData': _i1.MethodConnector(
          name: 'seedData',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['seed'] as _i11.SeedEndpoint).seedData(session),
        ),
      },
    );
    connectors['user'] = _i1.EndpointConnector(
      name: 'user',
      endpoint: endpoints['user']!,
      methodConnectors: {
        'getAllUsers': _i1.MethodConnector(
          name: 'getAllUsers',
          params: {
            'searchTerm': _i1.ParameterDescription(
              name: 'searchTerm',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<_i20.UserRole?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i12.UserEndpoint).getAllUsers(
                session,
                searchTerm: params['searchTerm'],
                role: params['role'],
              ),
        ),
        'updateUserRole': _i1.MethodConnector(
          name: 'updateUserRole',
          params: {
            'targetUserId': _i1.ParameterDescription(
              name: 'targetUserId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'newRole': _i1.ParameterDescription(
              name: 'newRole',
              type: _i1.getType<_i20.UserRole>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _i12.UserEndpoint).updateUserRole(
                    session,
                    params['targetUserId'],
                    params['newRole'],
                  ),
        ),
        'getUserStats': _i1.MethodConnector(
          name: 'getUserStats',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i12.UserEndpoint).getUserStats(
                session,
              ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i13.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth'] = _i21.Endpoints()..initializeEndpoints(server);
    modules['serverpod_auth_idp'] = _i22.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i23.Endpoints()
      ..initializeEndpoints(server);
  }
}
