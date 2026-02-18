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
import 'user.dart' as _i2;
import 'room.dart' as _i3;
import 'package:room_rental_client/src/protocol/protocol.dart' as _i4;

abstract class Favorite implements _i1.SerializableModel {
  Favorite._({
    this.id,
    required this.userId,
    this.user,
    required this.roomId,
    this.room,
    required this.createdAt,
  });

  factory Favorite({
    int? id,
    required int userId,
    _i2.User? user,
    required int roomId,
    _i3.Room? room,
    required DateTime createdAt,
  }) = _FavoriteImpl;

  factory Favorite.fromJson(Map<String, dynamic> jsonSerialization) {
    return Favorite(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      user: jsonSerialization['user'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
      roomId: jsonSerialization['roomId'] as int,
      room: jsonSerialization['room'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.Room>(jsonSerialization['room']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  _i2.User? user;

  int roomId;

  _i3.Room? room;

  DateTime createdAt;

  /// Returns a shallow copy of this [Favorite]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Favorite copyWith({
    int? id,
    int? userId,
    _i2.User? user,
    int? roomId,
    _i3.Room? room,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Favorite',
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJson(),
      'roomId': roomId,
      if (room != null) 'room': room?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FavoriteImpl extends Favorite {
  _FavoriteImpl({
    int? id,
    required int userId,
    _i2.User? user,
    required int roomId,
    _i3.Room? room,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         roomId: roomId,
         room: room,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Favorite]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Favorite copyWith({
    Object? id = _Undefined,
    int? userId,
    Object? user = _Undefined,
    int? roomId,
    Object? room = _Undefined,
    DateTime? createdAt,
  }) {
    return Favorite(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      roomId: roomId ?? this.roomId,
      room: room is _i3.Room? ? room : this.room?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
