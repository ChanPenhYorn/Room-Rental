/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'user.dart' as _i2;
import 'room_type.dart' as _i3;
import 'room_status.dart' as _i4;
import 'room_facility.dart' as _i5;
import 'booking.dart' as _i6;
import 'favorite.dart' as _i7;
import 'review.dart' as _i8;
import 'package:room_rental_server/src/generated/protocol.dart' as _i9;

abstract class Room implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = RoomTable();

  static const db = RoomRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Room',
      if (id != null) 'id': id,
      'ownerId': ownerId,
      if (owner != null) 'owner': owner?.toJsonForProtocol(),
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
        'facilities': facilities?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (bookings != null)
        'bookings': bookings?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (favorites != null)
        'favorites': favorites?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (reviews != null)
        'reviews': reviews?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static RoomInclude include({
    _i2.UserInclude? owner,
    _i5.RoomFacilityIncludeList? facilities,
    _i6.BookingIncludeList? bookings,
    _i7.FavoriteIncludeList? favorites,
    _i8.ReviewIncludeList? reviews,
  }) {
    return RoomInclude._(
      owner: owner,
      facilities: facilities,
      bookings: bookings,
      favorites: favorites,
      reviews: reviews,
    );
  }

  static RoomIncludeList includeList({
    _i1.WhereExpressionBuilder<RoomTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RoomTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RoomTable>? orderByList,
    RoomInclude? include,
  }) {
    return RoomIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Room.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Room.t),
      include: include,
    );
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

class RoomUpdateTable extends _i1.UpdateTable<RoomTable> {
  RoomUpdateTable(super.table);

  _i1.ColumnValue<int, int> ownerId(int value) => _i1.ColumnValue(
    table.ownerId,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<double, double> price(double value) => _i1.ColumnValue(
    table.price,
    value,
  );

  _i1.ColumnValue<String, String> location(String value) => _i1.ColumnValue(
    table.location,
    value,
  );

  _i1.ColumnValue<double, double> latitude(double value) => _i1.ColumnValue(
    table.latitude,
    value,
  );

  _i1.ColumnValue<double, double> longitude(double value) => _i1.ColumnValue(
    table.longitude,
    value,
  );

  _i1.ColumnValue<double, double> rating(double value) => _i1.ColumnValue(
    table.rating,
    value,
  );

  _i1.ColumnValue<_i3.RoomType, _i3.RoomType> type(_i3.RoomType value) =>
      _i1.ColumnValue(
        table.type,
        value,
      );

  _i1.ColumnValue<String, String> imageUrl(String? value) => _i1.ColumnValue(
    table.imageUrl,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> images(List<String>? value) =>
      _i1.ColumnValue(
        table.images,
        value,
      );

  _i1.ColumnValue<bool, bool> isAvailable(bool value) => _i1.ColumnValue(
    table.isAvailable,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<_i4.RoomStatus, _i4.RoomStatus> status(
    _i4.RoomStatus value,
  ) => _i1.ColumnValue(
    table.status,
    value,
  );
}

class RoomTable extends _i1.Table<int?> {
  RoomTable({super.tableRelation}) : super(tableName: 'room') {
    updateTable = RoomUpdateTable(this);
    ownerId = _i1.ColumnInt(
      'ownerId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    price = _i1.ColumnDouble(
      'price',
      this,
    );
    location = _i1.ColumnString(
      'location',
      this,
    );
    latitude = _i1.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _i1.ColumnDouble(
      'longitude',
      this,
    );
    rating = _i1.ColumnDouble(
      'rating',
      this,
    );
    type = _i1.ColumnEnum(
      'type',
      this,
      _i1.EnumSerialization.byName,
    );
    imageUrl = _i1.ColumnString(
      'imageUrl',
      this,
    );
    images = _i1.ColumnSerializable<List<String>>(
      'images',
      this,
    );
    isAvailable = _i1.ColumnBool(
      'isAvailable',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
    );
  }

  late final RoomUpdateTable updateTable;

  late final _i1.ColumnInt ownerId;

  _i2.UserTable? _owner;

  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  late final _i1.ColumnDouble price;

  late final _i1.ColumnString location;

  late final _i1.ColumnDouble latitude;

  late final _i1.ColumnDouble longitude;

  late final _i1.ColumnDouble rating;

  late final _i1.ColumnEnum<_i3.RoomType> type;

  late final _i1.ColumnString imageUrl;

  late final _i1.ColumnSerializable<List<String>> images;

  late final _i1.ColumnBool isAvailable;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnEnum<_i4.RoomStatus> status;

  _i5.RoomFacilityTable? ___facilities;

  _i1.ManyRelation<_i5.RoomFacilityTable>? _facilities;

  _i6.BookingTable? ___bookings;

  _i1.ManyRelation<_i6.BookingTable>? _bookings;

  _i7.FavoriteTable? ___favorites;

  _i1.ManyRelation<_i7.FavoriteTable>? _favorites;

  _i8.ReviewTable? ___reviews;

  _i1.ManyRelation<_i8.ReviewTable>? _reviews;

  _i2.UserTable get owner {
    if (_owner != null) return _owner!;
    _owner = _i1.createRelationTable(
      relationFieldName: 'owner',
      field: Room.t.ownerId,
      foreignField: _i2.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserTable(tableRelation: foreignTableRelation),
    );
    return _owner!;
  }

  _i5.RoomFacilityTable get __facilities {
    if (___facilities != null) return ___facilities!;
    ___facilities = _i1.createRelationTable(
      relationFieldName: '__facilities',
      field: Room.t.id,
      foreignField: _i5.RoomFacility.t.roomId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5.RoomFacilityTable(tableRelation: foreignTableRelation),
    );
    return ___facilities!;
  }

  _i6.BookingTable get __bookings {
    if (___bookings != null) return ___bookings!;
    ___bookings = _i1.createRelationTable(
      relationFieldName: '__bookings',
      field: Room.t.id,
      foreignField: _i6.Booking.t.roomId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i6.BookingTable(tableRelation: foreignTableRelation),
    );
    return ___bookings!;
  }

  _i7.FavoriteTable get __favorites {
    if (___favorites != null) return ___favorites!;
    ___favorites = _i1.createRelationTable(
      relationFieldName: '__favorites',
      field: Room.t.id,
      foreignField: _i7.Favorite.t.$_roomFavoritesRoomId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7.FavoriteTable(tableRelation: foreignTableRelation),
    );
    return ___favorites!;
  }

  _i8.ReviewTable get __reviews {
    if (___reviews != null) return ___reviews!;
    ___reviews = _i1.createRelationTable(
      relationFieldName: '__reviews',
      field: Room.t.id,
      foreignField: _i8.Review.t.$_roomReviewsRoomId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i8.ReviewTable(tableRelation: foreignTableRelation),
    );
    return ___reviews!;
  }

  _i1.ManyRelation<_i5.RoomFacilityTable> get facilities {
    if (_facilities != null) return _facilities!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'facilities',
      field: Room.t.id,
      foreignField: _i5.RoomFacility.t.roomId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5.RoomFacilityTable(tableRelation: foreignTableRelation),
    );
    _facilities = _i1.ManyRelation<_i5.RoomFacilityTable>(
      tableWithRelations: relationTable,
      table: _i5.RoomFacilityTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _facilities!;
  }

  _i1.ManyRelation<_i6.BookingTable> get bookings {
    if (_bookings != null) return _bookings!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'bookings',
      field: Room.t.id,
      foreignField: _i6.Booking.t.roomId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i6.BookingTable(tableRelation: foreignTableRelation),
    );
    _bookings = _i1.ManyRelation<_i6.BookingTable>(
      tableWithRelations: relationTable,
      table: _i6.BookingTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _bookings!;
  }

  _i1.ManyRelation<_i7.FavoriteTable> get favorites {
    if (_favorites != null) return _favorites!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'favorites',
      field: Room.t.id,
      foreignField: _i7.Favorite.t.$_roomFavoritesRoomId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7.FavoriteTable(tableRelation: foreignTableRelation),
    );
    _favorites = _i1.ManyRelation<_i7.FavoriteTable>(
      tableWithRelations: relationTable,
      table: _i7.FavoriteTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _favorites!;
  }

  _i1.ManyRelation<_i8.ReviewTable> get reviews {
    if (_reviews != null) return _reviews!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'reviews',
      field: Room.t.id,
      foreignField: _i8.Review.t.$_roomReviewsRoomId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i8.ReviewTable(tableRelation: foreignTableRelation),
    );
    _reviews = _i1.ManyRelation<_i8.ReviewTable>(
      tableWithRelations: relationTable,
      table: _i8.ReviewTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _reviews!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    ownerId,
    title,
    description,
    price,
    location,
    latitude,
    longitude,
    rating,
    type,
    imageUrl,
    images,
    isAvailable,
    createdAt,
    status,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'owner') {
      return owner;
    }
    if (relationField == 'facilities') {
      return __facilities;
    }
    if (relationField == 'bookings') {
      return __bookings;
    }
    if (relationField == 'favorites') {
      return __favorites;
    }
    if (relationField == 'reviews') {
      return __reviews;
    }
    return null;
  }
}

class RoomInclude extends _i1.IncludeObject {
  RoomInclude._({
    _i2.UserInclude? owner,
    _i5.RoomFacilityIncludeList? facilities,
    _i6.BookingIncludeList? bookings,
    _i7.FavoriteIncludeList? favorites,
    _i8.ReviewIncludeList? reviews,
  }) {
    _owner = owner;
    _facilities = facilities;
    _bookings = bookings;
    _favorites = favorites;
    _reviews = reviews;
  }

  _i2.UserInclude? _owner;

  _i5.RoomFacilityIncludeList? _facilities;

  _i6.BookingIncludeList? _bookings;

  _i7.FavoriteIncludeList? _favorites;

  _i8.ReviewIncludeList? _reviews;

  @override
  Map<String, _i1.Include?> get includes => {
    'owner': _owner,
    'facilities': _facilities,
    'bookings': _bookings,
    'favorites': _favorites,
    'reviews': _reviews,
  };

  @override
  _i1.Table<int?> get table => Room.t;
}

class RoomIncludeList extends _i1.IncludeList {
  RoomIncludeList._({
    _i1.WhereExpressionBuilder<RoomTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Room.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Room.t;
}

class RoomRepository {
  const RoomRepository._();

  final attach = const RoomAttachRepository._();

  final attachRow = const RoomAttachRowRepository._();

  final detach = const RoomDetachRepository._();

  final detachRow = const RoomDetachRowRepository._();

  /// Returns a list of [Room]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Room>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RoomTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RoomTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RoomTable>? orderByList,
    _i1.Transaction? transaction,
    RoomInclude? include,
  }) async {
    return session.db.find<Room>(
      where: where?.call(Room.t),
      orderBy: orderBy?.call(Room.t),
      orderByList: orderByList?.call(Room.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Room] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Room?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RoomTable>? where,
    int? offset,
    _i1.OrderByBuilder<RoomTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RoomTable>? orderByList,
    _i1.Transaction? transaction,
    RoomInclude? include,
  }) async {
    return session.db.findFirstRow<Room>(
      where: where?.call(Room.t),
      orderBy: orderBy?.call(Room.t),
      orderByList: orderByList?.call(Room.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Room] by its [id] or null if no such row exists.
  Future<Room?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    RoomInclude? include,
  }) async {
    return session.db.findById<Room>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Room]s in the list and returns the inserted rows.
  ///
  /// The returned [Room]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Room>> insert(
    _i1.Session session,
    List<Room> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Room>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Room] and returns the inserted row.
  ///
  /// The returned [Room] will have its `id` field set.
  Future<Room> insertRow(
    _i1.Session session,
    Room row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Room>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Room]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Room>> update(
    _i1.Session session,
    List<Room> rows, {
    _i1.ColumnSelections<RoomTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Room>(
      rows,
      columns: columns?.call(Room.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Room]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Room> updateRow(
    _i1.Session session,
    Room row, {
    _i1.ColumnSelections<RoomTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Room>(
      row,
      columns: columns?.call(Room.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Room] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Room?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<RoomUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Room>(
      id,
      columnValues: columnValues(Room.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Room]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Room>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<RoomUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RoomTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RoomTable>? orderBy,
    _i1.OrderByListBuilder<RoomTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Room>(
      columnValues: columnValues(Room.t.updateTable),
      where: where(Room.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Room.t),
      orderByList: orderByList?.call(Room.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Room]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Room>> delete(
    _i1.Session session,
    List<Room> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Room>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Room].
  Future<Room> deleteRow(
    _i1.Session session,
    Room row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Room>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Room>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RoomTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Room>(
      where: where(Room.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RoomTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Room>(
      where: where?.call(Room.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class RoomAttachRepository {
  const RoomAttachRepository._();

  /// Creates a relation between this [Room] and the given [RoomFacility]s
  /// by setting each [RoomFacility]'s foreign key `roomId` to refer to this [Room].
  Future<void> facilities(
    _i1.Session session,
    Room room,
    List<_i5.RoomFacility> roomFacility, {
    _i1.Transaction? transaction,
  }) async {
    if (roomFacility.any((e) => e.id == null)) {
      throw ArgumentError.notNull('roomFacility.id');
    }
    if (room.id == null) {
      throw ArgumentError.notNull('room.id');
    }

    var $roomFacility = roomFacility
        .map((e) => e.copyWith(roomId: room.id))
        .toList();
    await session.db.update<_i5.RoomFacility>(
      $roomFacility,
      columns: [_i5.RoomFacility.t.roomId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Room] and the given [Booking]s
  /// by setting each [Booking]'s foreign key `roomId` to refer to this [Room].
  Future<void> bookings(
    _i1.Session session,
    Room room,
    List<_i6.Booking> booking, {
    _i1.Transaction? transaction,
  }) async {
    if (booking.any((e) => e.id == null)) {
      throw ArgumentError.notNull('booking.id');
    }
    if (room.id == null) {
      throw ArgumentError.notNull('room.id');
    }

    var $booking = booking.map((e) => e.copyWith(roomId: room.id)).toList();
    await session.db.update<_i6.Booking>(
      $booking,
      columns: [_i6.Booking.t.roomId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Room] and the given [Favorite]s
  /// by setting each [Favorite]'s foreign key `_roomFavoritesRoomId` to refer to this [Room].
  Future<void> favorites(
    _i1.Session session,
    Room room,
    List<_i7.Favorite> favorite, {
    _i1.Transaction? transaction,
  }) async {
    if (favorite.any((e) => e.id == null)) {
      throw ArgumentError.notNull('favorite.id');
    }
    if (room.id == null) {
      throw ArgumentError.notNull('room.id');
    }

    var $favorite = favorite
        .map(
          (e) => _i7.FavoriteImplicit(
            e,
            $_roomFavoritesRoomId: room.id,
          ),
        )
        .toList();
    await session.db.update<_i7.Favorite>(
      $favorite,
      columns: [_i7.Favorite.t.$_roomFavoritesRoomId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Room] and the given [Review]s
  /// by setting each [Review]'s foreign key `_roomReviewsRoomId` to refer to this [Room].
  Future<void> reviews(
    _i1.Session session,
    Room room,
    List<_i8.Review> review, {
    _i1.Transaction? transaction,
  }) async {
    if (review.any((e) => e.id == null)) {
      throw ArgumentError.notNull('review.id');
    }
    if (room.id == null) {
      throw ArgumentError.notNull('room.id');
    }

    var $review = review
        .map(
          (e) => _i8.ReviewImplicit(
            e,
            $_roomReviewsRoomId: room.id,
          ),
        )
        .toList();
    await session.db.update<_i8.Review>(
      $review,
      columns: [_i8.Review.t.$_roomReviewsRoomId],
      transaction: transaction,
    );
  }
}

class RoomAttachRowRepository {
  const RoomAttachRowRepository._();

  /// Creates a relation between the given [Room] and [User]
  /// by setting the [Room]'s foreign key `ownerId` to refer to the [User].
  Future<void> owner(
    _i1.Session session,
    Room room,
    _i2.User owner, {
    _i1.Transaction? transaction,
  }) async {
    if (room.id == null) {
      throw ArgumentError.notNull('room.id');
    }
    if (owner.id == null) {
      throw ArgumentError.notNull('owner.id');
    }

    var $room = room.copyWith(ownerId: owner.id);
    await session.db.updateRow<Room>(
      $room,
      columns: [Room.t.ownerId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Room] and the given [RoomFacility]
  /// by setting the [RoomFacility]'s foreign key `roomId` to refer to this [Room].
  Future<void> facilities(
    _i1.Session session,
    Room room,
    _i5.RoomFacility roomFacility, {
    _i1.Transaction? transaction,
  }) async {
    if (roomFacility.id == null) {
      throw ArgumentError.notNull('roomFacility.id');
    }
    if (room.id == null) {
      throw ArgumentError.notNull('room.id');
    }

    var $roomFacility = roomFacility.copyWith(roomId: room.id);
    await session.db.updateRow<_i5.RoomFacility>(
      $roomFacility,
      columns: [_i5.RoomFacility.t.roomId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Room] and the given [Booking]
  /// by setting the [Booking]'s foreign key `roomId` to refer to this [Room].
  Future<void> bookings(
    _i1.Session session,
    Room room,
    _i6.Booking booking, {
    _i1.Transaction? transaction,
  }) async {
    if (booking.id == null) {
      throw ArgumentError.notNull('booking.id');
    }
    if (room.id == null) {
      throw ArgumentError.notNull('room.id');
    }

    var $booking = booking.copyWith(roomId: room.id);
    await session.db.updateRow<_i6.Booking>(
      $booking,
      columns: [_i6.Booking.t.roomId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Room] and the given [Favorite]
  /// by setting the [Favorite]'s foreign key `_roomFavoritesRoomId` to refer to this [Room].
  Future<void> favorites(
    _i1.Session session,
    Room room,
    _i7.Favorite favorite, {
    _i1.Transaction? transaction,
  }) async {
    if (favorite.id == null) {
      throw ArgumentError.notNull('favorite.id');
    }
    if (room.id == null) {
      throw ArgumentError.notNull('room.id');
    }

    var $favorite = _i7.FavoriteImplicit(
      favorite,
      $_roomFavoritesRoomId: room.id,
    );
    await session.db.updateRow<_i7.Favorite>(
      $favorite,
      columns: [_i7.Favorite.t.$_roomFavoritesRoomId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Room] and the given [Review]
  /// by setting the [Review]'s foreign key `_roomReviewsRoomId` to refer to this [Room].
  Future<void> reviews(
    _i1.Session session,
    Room room,
    _i8.Review review, {
    _i1.Transaction? transaction,
  }) async {
    if (review.id == null) {
      throw ArgumentError.notNull('review.id');
    }
    if (room.id == null) {
      throw ArgumentError.notNull('room.id');
    }

    var $review = _i8.ReviewImplicit(
      review,
      $_roomReviewsRoomId: room.id,
    );
    await session.db.updateRow<_i8.Review>(
      $review,
      columns: [_i8.Review.t.$_roomReviewsRoomId],
      transaction: transaction,
    );
  }
}

class RoomDetachRepository {
  const RoomDetachRepository._();

  /// Detaches the relation between this [Room] and the given [RoomFacility]
  /// by setting the [RoomFacility]'s foreign key `roomId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> facilities(
    _i1.Session session,
    List<_i5.RoomFacility> roomFacility, {
    _i1.Transaction? transaction,
  }) async {
    if (roomFacility.any((e) => e.id == null)) {
      throw ArgumentError.notNull('roomFacility.id');
    }

    var $roomFacility = roomFacility
        .map((e) => e.copyWith(roomId: null))
        .toList();
    await session.db.update<_i5.RoomFacility>(
      $roomFacility,
      columns: [_i5.RoomFacility.t.roomId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Room] and the given [Favorite]
  /// by setting the [Favorite]'s foreign key `_roomFavoritesRoomId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> favorites(
    _i1.Session session,
    List<_i7.Favorite> favorite, {
    _i1.Transaction? transaction,
  }) async {
    if (favorite.any((e) => e.id == null)) {
      throw ArgumentError.notNull('favorite.id');
    }

    var $favorite = favorite
        .map(
          (e) => _i7.FavoriteImplicit(
            e,
            $_roomFavoritesRoomId: null,
          ),
        )
        .toList();
    await session.db.update<_i7.Favorite>(
      $favorite,
      columns: [_i7.Favorite.t.$_roomFavoritesRoomId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Room] and the given [Review]
  /// by setting the [Review]'s foreign key `_roomReviewsRoomId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> reviews(
    _i1.Session session,
    List<_i8.Review> review, {
    _i1.Transaction? transaction,
  }) async {
    if (review.any((e) => e.id == null)) {
      throw ArgumentError.notNull('review.id');
    }

    var $review = review
        .map(
          (e) => _i8.ReviewImplicit(
            e,
            $_roomReviewsRoomId: null,
          ),
        )
        .toList();
    await session.db.update<_i8.Review>(
      $review,
      columns: [_i8.Review.t.$_roomReviewsRoomId],
      transaction: transaction,
    );
  }
}

class RoomDetachRowRepository {
  const RoomDetachRowRepository._();

  /// Detaches the relation between this [Room] and the given [RoomFacility]
  /// by setting the [RoomFacility]'s foreign key `roomId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> facilities(
    _i1.Session session,
    _i5.RoomFacility roomFacility, {
    _i1.Transaction? transaction,
  }) async {
    if (roomFacility.id == null) {
      throw ArgumentError.notNull('roomFacility.id');
    }

    var $roomFacility = roomFacility.copyWith(roomId: null);
    await session.db.updateRow<_i5.RoomFacility>(
      $roomFacility,
      columns: [_i5.RoomFacility.t.roomId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Room] and the given [Favorite]
  /// by setting the [Favorite]'s foreign key `_roomFavoritesRoomId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> favorites(
    _i1.Session session,
    _i7.Favorite favorite, {
    _i1.Transaction? transaction,
  }) async {
    if (favorite.id == null) {
      throw ArgumentError.notNull('favorite.id');
    }

    var $favorite = _i7.FavoriteImplicit(
      favorite,
      $_roomFavoritesRoomId: null,
    );
    await session.db.updateRow<_i7.Favorite>(
      $favorite,
      columns: [_i7.Favorite.t.$_roomFavoritesRoomId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Room] and the given [Review]
  /// by setting the [Review]'s foreign key `_roomReviewsRoomId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> reviews(
    _i1.Session session,
    _i8.Review review, {
    _i1.Transaction? transaction,
  }) async {
    if (review.id == null) {
      throw ArgumentError.notNull('review.id');
    }

    var $review = _i8.ReviewImplicit(
      review,
      $_roomReviewsRoomId: null,
    );
    await session.db.updateRow<_i8.Review>(
      $review,
      columns: [_i8.Review.t.$_roomReviewsRoomId],
      transaction: transaction,
    );
  }
}
