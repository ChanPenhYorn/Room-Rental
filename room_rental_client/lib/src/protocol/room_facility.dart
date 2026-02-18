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
import 'facility.dart' as _i3;
import 'package:room_rental_client/src/protocol/protocol.dart' as _i4;

abstract class RoomFacility implements _i1.SerializableModel {
  RoomFacility._({
    this.id,
    required this.roomId,
    this.room,
    required this.facilityId,
    this.facility,
  });

  factory RoomFacility({
    int? id,
    required int roomId,
    _i2.Room? room,
    required int facilityId,
    _i3.Facility? facility,
  }) = _RoomFacilityImpl;

  factory RoomFacility.fromJson(Map<String, dynamic> jsonSerialization) {
    return RoomFacility(
      id: jsonSerialization['id'] as int?,
      roomId: jsonSerialization['roomId'] as int,
      room: jsonSerialization['room'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.Room>(jsonSerialization['room']),
      facilityId: jsonSerialization['facilityId'] as int,
      facility: jsonSerialization['facility'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.Facility>(
              jsonSerialization['facility'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int roomId;

  _i2.Room? room;

  int facilityId;

  _i3.Facility? facility;

  /// Returns a shallow copy of this [RoomFacility]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RoomFacility copyWith({
    int? id,
    int? roomId,
    _i2.Room? room,
    int? facilityId,
    _i3.Facility? facility,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RoomFacility',
      if (id != null) 'id': id,
      'roomId': roomId,
      if (room != null) 'room': room?.toJson(),
      'facilityId': facilityId,
      if (facility != null) 'facility': facility?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RoomFacilityImpl extends RoomFacility {
  _RoomFacilityImpl({
    int? id,
    required int roomId,
    _i2.Room? room,
    required int facilityId,
    _i3.Facility? facility,
  }) : super._(
         id: id,
         roomId: roomId,
         room: room,
         facilityId: facilityId,
         facility: facility,
       );

  /// Returns a shallow copy of this [RoomFacility]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RoomFacility copyWith({
    Object? id = _Undefined,
    int? roomId,
    Object? room = _Undefined,
    int? facilityId,
    Object? facility = _Undefined,
  }) {
    return RoomFacility(
      id: id is int? ? id : this.id,
      roomId: roomId ?? this.roomId,
      room: room is _i2.Room? ? room : this.room?.copyWith(),
      facilityId: facilityId ?? this.facilityId,
      facility: facility is _i3.Facility?
          ? facility
          : this.facility?.copyWith(),
    );
  }
}
