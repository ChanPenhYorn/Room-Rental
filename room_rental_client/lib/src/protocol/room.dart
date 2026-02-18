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
import 'room_type.dart' as _i3;
import 'room_status.dart' as _i4;
import 'room_facility.dart' as _i5;
import 'booking.dart' as _i6;
import 'favorite.dart' as _i7;
import 'review.dart' as _i8;
import 'package:room_rental_client/src/protocol/protocol.dart' as _i9;

abstract class Room implements _i1.SerializableModel {
  Room._({
    this.id,
    required this.ownerId,
    this.owner,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.type,
    this.imageUrl,
    this.images,
    required this.isAvailable,
    required this.createdAt,
    required this.status,
    this.facilities,
    this.bookings,
    this.favorites,
    this.reviews,
  });

  factory Room({
    int? id,
    required int ownerId,
    _i2.User? owner,
    required String title,
    required String description,
    required double price,
    required String location,
    required double latitude,
    required double longitude,
    required double rating,
    required _i3.RoomType type,
    String? imageUrl,
    List<String>? images,
    required bool isAvailable,
    required DateTime createdAt,
    required _i4.RoomStatus status,
    List<_i5.RoomFacility>? facilities,
    List<_i6.Booking>? bookings,
    List<_i7.Favorite>? favorites,
    List<_i8.Review>? reviews,
  }) = _RoomImpl;

  factory Room.fromJson(Map<String, dynamic> jsonSerialization) {
    return Room(
      id: jsonSerialization['id'] as int?,
      ownerId: jsonSerialization['ownerId'] as int,
      owner: jsonSerialization['owner'] == null
          ? null
          : _i9.Protocol().deserialize<_i2.User>(jsonSerialization['owner']),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      price: (jsonSerialization['price'] as num).toDouble(),
      location: jsonSerialization['location'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      rating: (jsonSerialization['rating'] as num).toDouble(),
      type: _i3.RoomType.fromJson((jsonSerialization['type'] as String)),
      imageUrl: jsonSerialization['imageUrl'] as String?,
      images: jsonSerialization['images'] == null
          ? null
          : _i9.Protocol().deserialize<List<String>>(
              jsonSerialization['images'],
            ),
      isAvailable: jsonSerialization['isAvailable'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      status: _i4.RoomStatus.fromJson((jsonSerialization['status'] as String)),
      facilities: jsonSerialization['facilities'] == null
          ? null
          : _i9.Protocol().deserialize<List<_i5.RoomFacility>>(
              jsonSerialization['facilities'],
            ),
      bookings: jsonSerialization['bookings'] == null
          ? null
          : _i9.Protocol().deserialize<List<_i6.Booking>>(
              jsonSerialization['bookings'],
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

  int ownerId;

  _i2.User? owner;

  String title;

  String description;

  double price;

  String location;

  double latitude;

  double longitude;

  double rating;

  _i3.RoomType type;

  String? imageUrl;

  List<String>? images;

  bool isAvailable;

  DateTime createdAt;

  _i4.RoomStatus status;

  List<_i5.RoomFacility>? facilities;

  List<_i6.Booking>? bookings;

  List<_i7.Favorite>? favorites;

  List<_i8.Review>? reviews;

  /// Returns a shallow copy of this [Room]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Room copyWith({
    int? id,
    int? ownerId,
    _i2.User? owner,
    String? title,
    String? description,
    double? price,
    String? location,
    double? latitude,
    double? longitude,
    double? rating,
    _i3.RoomType? type,
    String? imageUrl,
    List<String>? images,
    bool? isAvailable,
    DateTime? createdAt,
    _i4.RoomStatus? status,
    List<_i5.RoomFacility>? facilities,
    List<_i6.Booking>? bookings,
    List<_i7.Favorite>? favorites,
    List<_i8.Review>? reviews,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Room',
      if (id != null) 'id': id,
      'ownerId': ownerId,
      if (owner != null) 'owner': owner?.toJson(),
      'title': title,
      'description': description,
      'price': price,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'type': type.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (images != null) 'images': images?.toJson(),
      'isAvailable': isAvailable,
      'createdAt': createdAt.toJson(),
      'status': status.toJson(),
      if (facilities != null)
        'facilities': facilities?.toJson(valueToJson: (v) => v.toJson()),
      if (bookings != null)
        'bookings': bookings?.toJson(valueToJson: (v) => v.toJson()),
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

class _RoomImpl extends Room {
  _RoomImpl({
    int? id,
    required int ownerId,
    _i2.User? owner,
    required String title,
    required String description,
    required double price,
    required String location,
    required double latitude,
    required double longitude,
    required double rating,
    required _i3.RoomType type,
    String? imageUrl,
    List<String>? images,
    required bool isAvailable,
    required DateTime createdAt,
    required _i4.RoomStatus status,
    List<_i5.RoomFacility>? facilities,
    List<_i6.Booking>? bookings,
    List<_i7.Favorite>? favorites,
    List<_i8.Review>? reviews,
  }) : super._(
         id: id,
         ownerId: ownerId,
         owner: owner,
         title: title,
         description: description,
         price: price,
         location: location,
         latitude: latitude,
         longitude: longitude,
         rating: rating,
         type: type,
         imageUrl: imageUrl,
         images: images,
         isAvailable: isAvailable,
         createdAt: createdAt,
         status: status,
         facilities: facilities,
         bookings: bookings,
         favorites: favorites,
         reviews: reviews,
       );

  /// Returns a shallow copy of this [Room]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Room copyWith({
    Object? id = _Undefined,
    int? ownerId,
    Object? owner = _Undefined,
    String? title,
    String? description,
    double? price,
    String? location,
    double? latitude,
    double? longitude,
    double? rating,
    _i3.RoomType? type,
    Object? imageUrl = _Undefined,
    Object? images = _Undefined,
    bool? isAvailable,
    DateTime? createdAt,
    _i4.RoomStatus? status,
    Object? facilities = _Undefined,
    Object? bookings = _Undefined,
    Object? favorites = _Undefined,
    Object? reviews = _Undefined,
  }) {
    return Room(
      id: id is int? ? id : this.id,
      ownerId: ownerId ?? this.ownerId,
      owner: owner is _i2.User? ? owner : this.owner?.copyWith(),
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      type: type ?? this.type,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      images: images is List<String>?
          ? images
          : this.images?.map((e0) => e0).toList(),
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      facilities: facilities is List<_i5.RoomFacility>?
          ? facilities
          : this.facilities?.map((e0) => e0.copyWith()).toList(),
      bookings: bookings is List<_i6.Booking>?
          ? bookings
          : this.bookings?.map((e0) => e0.copyWith()).toList(),
      favorites: favorites is List<_i7.Favorite>?
          ? favorites
          : this.favorites?.map((e0) => e0.copyWith()).toList(),
      reviews: reviews is List<_i8.Review>?
          ? reviews
          : this.reviews?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
