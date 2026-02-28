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
import 'owner_request_status.dart' as _i3;
import 'package:room_rental_client/src/protocol/protocol.dart' as _i4;

abstract class BecomeOwnerRequest implements _i1.SerializableModel {
  BecomeOwnerRequest._({
    this.id,
    required this.userId,
    this.user,
    this.message,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BecomeOwnerRequest({
    int? id,
    required int userId,
    _i2.User? user,
    String? message,
    required _i3.OwnerRequestStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BecomeOwnerRequestImpl;

  factory BecomeOwnerRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return BecomeOwnerRequest(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      user: jsonSerialization['user'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
      message: jsonSerialization['message'] as String?,
      status: _i3.OwnerRequestStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  _i2.User? user;

  String? message;

  _i3.OwnerRequestStatus status;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [BecomeOwnerRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BecomeOwnerRequest copyWith({
    int? id,
    int? userId,
    _i2.User? user,
    String? message,
    _i3.OwnerRequestStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BecomeOwnerRequest',
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJson(),
      if (message != null) 'message': message,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BecomeOwnerRequestImpl extends BecomeOwnerRequest {
  _BecomeOwnerRequestImpl({
    int? id,
    required int userId,
    _i2.User? user,
    String? message,
    required _i3.OwnerRequestStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         message: message,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [BecomeOwnerRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BecomeOwnerRequest copyWith({
    Object? id = _Undefined,
    int? userId,
    Object? user = _Undefined,
    Object? message = _Undefined,
    _i3.OwnerRequestStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BecomeOwnerRequest(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      message: message is String? ? message : this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
