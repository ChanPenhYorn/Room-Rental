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
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i2;
import 'user_role.dart' as _i3;
import 'room.dart' as _i4;
import 'booking.dart' as _i5;
import 'chat_message.dart' as _i6;
import 'favorite.dart' as _i7;
import 'review.dart' as _i8;
import 'package:dwellly_client/src/protocol/protocol.dart' as _i9;

abstract class User implements _i1.SerializableModel {
  User._({
    this.id,
    this.userInfoId,
    this.userInfo,
    this.authUserId,
    required this.fullName,
    this.phone,
    this.bio,
    required this.role,
    this.profileImage,
    required this.createdAt,
    this.rooms,
    this.bookings,
    this.sentMessages,
    this.receivedMessages,
    this.favorites,
    this.reviews,
  });

  factory User({
    int? id,
    int? userInfoId,
    _i2.UserInfo? userInfo,
    String? authUserId,
    required String fullName,
    String? phone,
    String? bio,
    required _i3.UserRole role,
    String? profileImage,
    required DateTime createdAt,
    List<_i4.Room>? rooms,
    List<_i5.Booking>? bookings,
    List<_i6.ChatMessage>? sentMessages,
    List<_i6.ChatMessage>? receivedMessages,
    List<_i7.Favorite>? favorites,
    List<_i8.Review>? reviews,
  }) = _UserImpl;

  factory User.fromJson(Map<String, dynamic> jsonSerialization) {
    return User(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int?,
      userInfo: jsonSerialization['userInfo'] == null
          ? null
          : _i9.Protocol().deserialize<_i2.UserInfo>(
              jsonSerialization['userInfo'],
            ),
      authUserId: jsonSerialization['authUserId'] as String?,
      fullName: jsonSerialization['fullName'] as String,
      phone: jsonSerialization['phone'] as String?,
      bio: jsonSerialization['bio'] as String?,
      role: _i3.UserRole.fromJson((jsonSerialization['role'] as String)),
      profileImage: jsonSerialization['profileImage'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      rooms: jsonSerialization['rooms'] == null
          ? null
          : _i9.Protocol().deserialize<List<_i4.Room>>(
              jsonSerialization['rooms'],
            ),
      bookings: jsonSerialization['bookings'] == null
          ? null
          : _i9.Protocol().deserialize<List<_i5.Booking>>(
              jsonSerialization['bookings'],
            ),
      sentMessages: jsonSerialization['sentMessages'] == null
          ? null
          : _i9.Protocol().deserialize<List<_i6.ChatMessage>>(
              jsonSerialization['sentMessages'],
            ),
      receivedMessages: jsonSerialization['receivedMessages'] == null
          ? null
          : _i9.Protocol().deserialize<List<_i6.ChatMessage>>(
              jsonSerialization['receivedMessages'],
            ),
      favorites: jsonSerialization['favorites'] == null
          ? null
          : _i9.Protocol().deserialize<List<_i7.Favorite>>(
              jsonSerialization['favorites'],
            ),
      reviews: jsonSerialization['reviews'] == null
          ? null
          : _i9.Protocol().deserialize<List<_i8.Review>>(
              jsonSerialization['reviews'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? userInfoId;

  _i2.UserInfo? userInfo;

  String? authUserId;

  String fullName;

  String? phone;

  String? bio;

  _i3.UserRole role;

  String? profileImage;

  DateTime createdAt;

  List<_i4.Room>? rooms;

  List<_i5.Booking>? bookings;

  List<_i6.ChatMessage>? sentMessages;

  List<_i6.ChatMessage>? receivedMessages;

  List<_i7.Favorite>? favorites;

  List<_i8.Review>? reviews;

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  User copyWith({
    int? id,
    int? userInfoId,
    _i2.UserInfo? userInfo,
    String? authUserId,
    String? fullName,
    String? phone,
    String? bio,
    _i3.UserRole? role,
    String? profileImage,
    DateTime? createdAt,
    List<_i4.Room>? rooms,
    List<_i5.Booking>? bookings,
    List<_i6.ChatMessage>? sentMessages,
    List<_i6.ChatMessage>? receivedMessages,
    List<_i7.Favorite>? favorites,
    List<_i8.Review>? reviews,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'User',
      if (id != null) 'id': id,
      if (userInfoId != null) 'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJson(),
      if (authUserId != null) 'authUserId': authUserId,
      'fullName': fullName,
      if (phone != null) 'phone': phone,
      if (bio != null) 'bio': bio,
      'role': role.toJson(),
      if (profileImage != null) 'profileImage': profileImage,
      'createdAt': createdAt.toJson(),
      if (rooms != null) 'rooms': rooms?.toJson(valueToJson: (v) => v.toJson()),
      if (bookings != null)
        'bookings': bookings?.toJson(valueToJson: (v) => v.toJson()),
      if (sentMessages != null)
        'sentMessages': sentMessages?.toJson(valueToJson: (v) => v.toJson()),
      if (receivedMessages != null)
        'receivedMessages': receivedMessages?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      if (favorites != null)
        'favorites': favorites?.toJson(valueToJson: (v) => v.toJson()),
      if (reviews != null)
        'reviews': reviews?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserImpl extends User {
  _UserImpl({
    int? id,
    int? userInfoId,
    _i2.UserInfo? userInfo,
    String? authUserId,
    required String fullName,
    String? phone,
    String? bio,
    required _i3.UserRole role,
    String? profileImage,
    required DateTime createdAt,
    List<_i4.Room>? rooms,
    List<_i5.Booking>? bookings,
    List<_i6.ChatMessage>? sentMessages,
    List<_i6.ChatMessage>? receivedMessages,
    List<_i7.Favorite>? favorites,
    List<_i8.Review>? reviews,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
         userInfo: userInfo,
         authUserId: authUserId,
         fullName: fullName,
         phone: phone,
         bio: bio,
         role: role,
         profileImage: profileImage,
         createdAt: createdAt,
         rooms: rooms,
         bookings: bookings,
         sentMessages: sentMessages,
         receivedMessages: receivedMessages,
         favorites: favorites,
         reviews: reviews,
       );

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  User copyWith({
    Object? id = _Undefined,
    Object? userInfoId = _Undefined,
    Object? userInfo = _Undefined,
    Object? authUserId = _Undefined,
    String? fullName,
    Object? phone = _Undefined,
    Object? bio = _Undefined,
    _i3.UserRole? role,
    Object? profileImage = _Undefined,
    DateTime? createdAt,
    Object? rooms = _Undefined,
    Object? bookings = _Undefined,
    Object? sentMessages = _Undefined,
    Object? receivedMessages = _Undefined,
    Object? favorites = _Undefined,
    Object? reviews = _Undefined,
  }) {
    return User(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId is int? ? userInfoId : this.userInfoId,
      userInfo: userInfo is _i2.UserInfo?
          ? userInfo
          : this.userInfo?.copyWith(),
      authUserId: authUserId is String? ? authUserId : this.authUserId,
      fullName: fullName ?? this.fullName,
      phone: phone is String? ? phone : this.phone,
      bio: bio is String? ? bio : this.bio,
      role: role ?? this.role,
      profileImage: profileImage is String? ? profileImage : this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      rooms: rooms is List<_i4.Room>?
          ? rooms
          : this.rooms?.map((e0) => e0.copyWith()).toList(),
      bookings: bookings is List<_i5.Booking>?
          ? bookings
          : this.bookings?.map((e0) => e0.copyWith()).toList(),
      sentMessages: sentMessages is List<_i6.ChatMessage>?
          ? sentMessages
          : this.sentMessages?.map((e0) => e0.copyWith()).toList(),
      receivedMessages: receivedMessages is List<_i6.ChatMessage>?
          ? receivedMessages
          : this.receivedMessages?.map((e0) => e0.copyWith()).toList(),
      favorites: favorites is List<_i7.Favorite>?
          ? favorites
          : this.favorites?.map((e0) => e0.copyWith()).toList(),
      reviews: reviews is List<_i8.Review>?
          ? reviews
          : this.reviews?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
