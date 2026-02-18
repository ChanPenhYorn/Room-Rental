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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'room.dart' as _i2;
import 'user.dart' as _i3;
import 'booking_status.dart' as _i4;
import 'contract.dart' as _i5;
import 'package:room_rental_client/src/protocol/protocol.dart' as _i6;

abstract class Booking implements _i1.SerializableModel {
  Booking._({
    this.id,
    required this.roomId,
    this.room,
    required this.userId,
    this.user,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.status,
    this.transactionId,
    required this.createdAt,
    this.contract,
  });

  factory Booking({
    int? id,
    required int roomId,
    _i2.Room? room,
    required int userId,
    _i3.User? user,
    required DateTime checkIn,
    required DateTime checkOut,
    required double totalPrice,
    required _i4.BookingStatus status,
    String? transactionId,
    required DateTime createdAt,
    _i5.Contract? contract,
  }) = _BookingImpl;

  factory Booking.fromJson(Map<String, dynamic> jsonSerialization) {
    return Booking(
      id: jsonSerialization['id'] as int?,
      roomId: jsonSerialization['roomId'] as int,
      room: jsonSerialization['room'] == null
          ? null
          : _i6.Protocol().deserialize<_i2.Room>(jsonSerialization['room']),
      userId: jsonSerialization['userId'] as int,
      user: jsonSerialization['user'] == null
          ? null
          : _i6.Protocol().deserialize<_i3.User>(jsonSerialization['user']),
      checkIn: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['checkIn']),
      checkOut: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['checkOut'],
      ),
      totalPrice: (jsonSerialization['totalPrice'] as num).toDouble(),
      status: _i4.BookingStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      transactionId: jsonSerialization['transactionId'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      contract: jsonSerialization['contract'] == null
          ? null
          : _i6.Protocol().deserialize<_i5.Contract>(
              jsonSerialization['contract'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int roomId;

  _i2.Room? room;

  int userId;

  _i3.User? user;

  DateTime checkIn;

  DateTime checkOut;

  double totalPrice;

  _i4.BookingStatus status;

  String? transactionId;

  DateTime createdAt;

  _i5.Contract? contract;

  /// Returns a shallow copy of this [Booking]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Booking copyWith({
    int? id,
    int? roomId,
    _i2.Room? room,
    int? userId,
    _i3.User? user,
    DateTime? checkIn,
    DateTime? checkOut,
    double? totalPrice,
    _i4.BookingStatus? status,
    String? transactionId,
    DateTime? createdAt,
    _i5.Contract? contract,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Booking',
      if (id != null) 'id': id,
      'roomId': roomId,
      if (room != null) 'room': room?.toJson(),
      'userId': userId,
      if (user != null) 'user': user?.toJson(),
      'checkIn': checkIn.toJson(),
      'checkOut': checkOut.toJson(),
      'totalPrice': totalPrice,
      'status': status.toJson(),
      if (transactionId != null) 'transactionId': transactionId,
      'createdAt': createdAt.toJson(),
      if (contract != null) 'contract': contract?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BookingImpl extends Booking {
  _BookingImpl({
    int? id,
    required int roomId,
    _i2.Room? room,
    required int userId,
    _i3.User? user,
    required DateTime checkIn,
    required DateTime checkOut,
    required double totalPrice,
    required _i4.BookingStatus status,
    String? transactionId,
    required DateTime createdAt,
    _i5.Contract? contract,
  }) : super._(
         id: id,
         roomId: roomId,
         room: room,
         userId: userId,
         user: user,
         checkIn: checkIn,
         checkOut: checkOut,
         totalPrice: totalPrice,
         status: status,
         transactionId: transactionId,
         createdAt: createdAt,
         contract: contract,
       );

  /// Returns a shallow copy of this [Booking]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Booking copyWith({
    Object? id = _Undefined,
    int? roomId,
    Object? room = _Undefined,
    int? userId,
    Object? user = _Undefined,
    DateTime? checkIn,
    DateTime? checkOut,
    double? totalPrice,
    _i4.BookingStatus? status,
    Object? transactionId = _Undefined,
    DateTime? createdAt,
    Object? contract = _Undefined,
  }) {
    return Booking(
      id: id is int? ? id : this.id,
      roomId: roomId ?? this.roomId,
      room: room is _i2.Room? ? room : this.room?.copyWith(),
      userId: userId ?? this.userId,
      user: user is _i3.User? ? user : this.user?.copyWith(),
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      transactionId: transactionId is String?
          ? transactionId
          : this.transactionId,
      createdAt: createdAt ?? this.createdAt,
      contract: contract is _i5.Contract?
          ? contract
          : this.contract?.copyWith(),
    );
  }
}
