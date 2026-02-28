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

enum RoomType implements _i1.SerializableModel {
  studio,
  apartment1br,
  apartment2br,
  dormitory,
  villa,
  house,
  condo;

  static RoomType fromJson(String name) {
    switch (name) {
      case 'studio':
        return RoomType.studio;
      case 'apartment1br':
        return RoomType.apartment1br;
      case 'apartment2br':
        return RoomType.apartment2br;
      case 'dormitory':
        return RoomType.dormitory;
      case 'villa':
        return RoomType.villa;
      case 'house':
        return RoomType.house;
      case 'condo':
        return RoomType.condo;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "RoomType"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
