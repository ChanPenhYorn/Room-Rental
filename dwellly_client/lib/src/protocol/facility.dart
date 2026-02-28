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
import 'room_facility.dart' as _i2;
import 'package:dwellly_client/src/protocol/protocol.dart' as _i3;

abstract class Facility implements _i1.SerializableModel {
  Facility._({
    this.id,
    required this.name,
    required this.icon,
    this.rooms,
  });

  factory Facility({
    int? id,
    required String name,
    required String icon,
    List<_i2.RoomFacility>? rooms,
  }) = _FacilityImpl;

  factory Facility.fromJson(Map<String, dynamic> jsonSerialization) {
    return Facility(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      icon: jsonSerialization['icon'] as String,
      rooms: jsonSerialization['rooms'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.RoomFacility>>(
              jsonSerialization['rooms'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String icon;

  List<_i2.RoomFacility>? rooms;

  /// Returns a shallow copy of this [Facility]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Facility copyWith({
    int? id,
    String? name,
    String? icon,
    List<_i2.RoomFacility>? rooms,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Facility',
      if (id != null) 'id': id,
      'name': name,
      'icon': icon,
      if (rooms != null) 'rooms': rooms?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FacilityImpl extends Facility {
  _FacilityImpl({
    int? id,
    required String name,
    required String icon,
    List<_i2.RoomFacility>? rooms,
  }) : super._(
         id: id,
         name: name,
         icon: icon,
         rooms: rooms,
       );

  /// Returns a shallow copy of this [Facility]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Facility copyWith({
    Object? id = _Undefined,
    String? name,
    String? icon,
    Object? rooms = _Undefined,
  }) {
    return Facility(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      rooms: rooms is List<_i2.RoomFacility>?
          ? rooms
          : this.rooms?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
