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
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i2;
import 'user_role.dart' as _i3;
import 'room.dart' as _i4;
import 'booking.dart' as _i5;
import 'chat_message.dart' as _i6;
import 'favorite.dart' as _i7;
import 'review.dart' as _i8;
import 'package:dwellly_server/src/generated/protocol.dart' as _i9;

abstract class User implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = UserTable();

  static const db = UserRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'User',
      if (id != null) 'id': id,
      if (userInfoId != null) 'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJsonForProtocol(),
      if (authUserId != null) 'authUserId': authUserId,
      'fullName': fullName,
      if (phone != null) 'phone': phone,
      if (bio != null) 'bio': bio,
      'role': role.toJson(),
      if (profileImage != null) 'profileImage': profileImage,
      'createdAt': createdAt.toJson(),
      if (rooms != null)
        'rooms': rooms?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (bookings != null)
        'bookings': bookings?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (sentMessages != null)
        'sentMessages': sentMessages?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (receivedMessages != null)
        'receivedMessages': receivedMessages?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (favorites != null)
        'favorites': favorites?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (reviews != null)
        'reviews': reviews?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static UserInclude include({
    _i2.UserInfoInclude? userInfo,
    _i4.RoomIncludeList? rooms,
    _i5.BookingIncludeList? bookings,
    _i6.ChatMessageIncludeList? sentMessages,
    _i6.ChatMessageIncludeList? receivedMessages,
    _i7.FavoriteIncludeList? favorites,
    _i8.ReviewIncludeList? reviews,
  }) {
    return UserInclude._(
      userInfo: userInfo,
      rooms: rooms,
      bookings: bookings,
      sentMessages: sentMessages,
      receivedMessages: receivedMessages,
      favorites: favorites,
      reviews: reviews,
    );
  }

  static UserIncludeList includeList({
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    UserInclude? include,
  }) {
    return UserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(User.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(User.t),
      include: include,
    );
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

class UserUpdateTable extends _i1.UpdateTable<UserTable> {
  UserUpdateTable(super.table);

  _i1.ColumnValue<int, int> userInfoId(int? value) => _i1.ColumnValue(
    table.userInfoId,
    value,
  );

  _i1.ColumnValue<String, String> authUserId(String? value) => _i1.ColumnValue(
    table.authUserId,
    value,
  );

  _i1.ColumnValue<String, String> fullName(String value) => _i1.ColumnValue(
    table.fullName,
    value,
  );

  _i1.ColumnValue<String, String> phone(String? value) => _i1.ColumnValue(
    table.phone,
    value,
  );

  _i1.ColumnValue<String, String> bio(String? value) => _i1.ColumnValue(
    table.bio,
    value,
  );

  _i1.ColumnValue<_i3.UserRole, _i3.UserRole> role(_i3.UserRole value) =>
      _i1.ColumnValue(
        table.role,
        value,
      );

  _i1.ColumnValue<String, String> profileImage(String? value) =>
      _i1.ColumnValue(
        table.profileImage,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class UserTable extends _i1.Table<int?> {
  UserTable({super.tableRelation}) : super(tableName: 'user') {
    updateTable = UserUpdateTable(this);
    userInfoId = _i1.ColumnInt(
      'userInfoId',
      this,
    );
    authUserId = _i1.ColumnString(
      'authUserId',
      this,
    );
    fullName = _i1.ColumnString(
      'fullName',
      this,
    );
    phone = _i1.ColumnString(
      'phone',
      this,
    );
    bio = _i1.ColumnString(
      'bio',
      this,
    );
    role = _i1.ColumnEnum(
      'role',
      this,
      _i1.EnumSerialization.byName,
    );
    profileImage = _i1.ColumnString(
      'profileImage',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final UserUpdateTable updateTable;

  late final _i1.ColumnInt userInfoId;

  _i2.UserInfoTable? _userInfo;

  late final _i1.ColumnString authUserId;

  late final _i1.ColumnString fullName;

  late final _i1.ColumnString phone;

  late final _i1.ColumnString bio;

  late final _i1.ColumnEnum<_i3.UserRole> role;

  late final _i1.ColumnString profileImage;

  late final _i1.ColumnDateTime createdAt;

  _i4.RoomTable? ___rooms;

  _i1.ManyRelation<_i4.RoomTable>? _rooms;

  _i5.BookingTable? ___bookings;

  _i1.ManyRelation<_i5.BookingTable>? _bookings;

  _i6.ChatMessageTable? ___sentMessages;

  _i1.ManyRelation<_i6.ChatMessageTable>? _sentMessages;

  _i6.ChatMessageTable? ___receivedMessages;

  _i1.ManyRelation<_i6.ChatMessageTable>? _receivedMessages;

  _i7.FavoriteTable? ___favorites;

  _i1.ManyRelation<_i7.FavoriteTable>? _favorites;

  _i8.ReviewTable? ___reviews;

  _i1.ManyRelation<_i8.ReviewTable>? _reviews;

  _i2.UserInfoTable get userInfo {
    if (_userInfo != null) return _userInfo!;
    _userInfo = _i1.createRelationTable(
      relationFieldName: 'userInfo',
      field: User.t.userInfoId,
      foreignField: _i2.UserInfo.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserInfoTable(tableRelation: foreignTableRelation),
    );
    return _userInfo!;
  }

  _i4.RoomTable get __rooms {
    if (___rooms != null) return ___rooms!;
    ___rooms = _i1.createRelationTable(
      relationFieldName: '__rooms',
      field: User.t.id,
      foreignField: _i4.Room.t.ownerId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.RoomTable(tableRelation: foreignTableRelation),
    );
    return ___rooms!;
  }

  _i5.BookingTable get __bookings {
    if (___bookings != null) return ___bookings!;
    ___bookings = _i1.createRelationTable(
      relationFieldName: '__bookings',
      field: User.t.id,
      foreignField: _i5.Booking.t.userId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5.BookingTable(tableRelation: foreignTableRelation),
    );
    return ___bookings!;
  }

  _i6.ChatMessageTable get __sentMessages {
    if (___sentMessages != null) return ___sentMessages!;
    ___sentMessages = _i1.createRelationTable(
      relationFieldName: '__sentMessages',
      field: User.t.id,
      foreignField: _i6.ChatMessage.t.senderId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i6.ChatMessageTable(tableRelation: foreignTableRelation),
    );
    return ___sentMessages!;
  }

  _i6.ChatMessageTable get __receivedMessages {
    if (___receivedMessages != null) return ___receivedMessages!;
    ___receivedMessages = _i1.createRelationTable(
      relationFieldName: '__receivedMessages',
      field: User.t.id,
      foreignField: _i6.ChatMessage.t.receiverId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i6.ChatMessageTable(tableRelation: foreignTableRelation),
    );
    return ___receivedMessages!;
  }

  _i7.FavoriteTable get __favorites {
    if (___favorites != null) return ___favorites!;
    ___favorites = _i1.createRelationTable(
      relationFieldName: '__favorites',
      field: User.t.id,
      foreignField: _i7.Favorite.t.$_userFavoritesUserId,
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
      field: User.t.id,
      foreignField: _i8.Review.t.$_userReviewsUserId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i8.ReviewTable(tableRelation: foreignTableRelation),
    );
    return ___reviews!;
  }

  _i1.ManyRelation<_i4.RoomTable> get rooms {
    if (_rooms != null) return _rooms!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'rooms',
      field: User.t.id,
      foreignField: _i4.Room.t.ownerId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.RoomTable(tableRelation: foreignTableRelation),
    );
    _rooms = _i1.ManyRelation<_i4.RoomTable>(
      tableWithRelations: relationTable,
      table: _i4.RoomTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _rooms!;
  }

  _i1.ManyRelation<_i5.BookingTable> get bookings {
    if (_bookings != null) return _bookings!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'bookings',
      field: User.t.id,
      foreignField: _i5.Booking.t.userId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5.BookingTable(tableRelation: foreignTableRelation),
    );
    _bookings = _i1.ManyRelation<_i5.BookingTable>(
      tableWithRelations: relationTable,
      table: _i5.BookingTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _bookings!;
  }

  _i1.ManyRelation<_i6.ChatMessageTable> get sentMessages {
    if (_sentMessages != null) return _sentMessages!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'sentMessages',
      field: User.t.id,
      foreignField: _i6.ChatMessage.t.senderId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i6.ChatMessageTable(tableRelation: foreignTableRelation),
    );
    _sentMessages = _i1.ManyRelation<_i6.ChatMessageTable>(
      tableWithRelations: relationTable,
      table: _i6.ChatMessageTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _sentMessages!;
  }

  _i1.ManyRelation<_i6.ChatMessageTable> get receivedMessages {
    if (_receivedMessages != null) return _receivedMessages!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'receivedMessages',
      field: User.t.id,
      foreignField: _i6.ChatMessage.t.receiverId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i6.ChatMessageTable(tableRelation: foreignTableRelation),
    );
    _receivedMessages = _i1.ManyRelation<_i6.ChatMessageTable>(
      tableWithRelations: relationTable,
      table: _i6.ChatMessageTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _receivedMessages!;
  }

  _i1.ManyRelation<_i7.FavoriteTable> get favorites {
    if (_favorites != null) return _favorites!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'favorites',
      field: User.t.id,
      foreignField: _i7.Favorite.t.$_userFavoritesUserId,
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
      field: User.t.id,
      foreignField: _i8.Review.t.$_userReviewsUserId,
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
    userInfoId,
    authUserId,
    fullName,
    phone,
    bio,
    role,
    profileImage,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'userInfo') {
      return userInfo;
    }
    if (relationField == 'rooms') {
      return __rooms;
    }
    if (relationField == 'bookings') {
      return __bookings;
    }
    if (relationField == 'sentMessages') {
      return __sentMessages;
    }
    if (relationField == 'receivedMessages') {
      return __receivedMessages;
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

class UserInclude extends _i1.IncludeObject {
  UserInclude._({
    _i2.UserInfoInclude? userInfo,
    _i4.RoomIncludeList? rooms,
    _i5.BookingIncludeList? bookings,
    _i6.ChatMessageIncludeList? sentMessages,
    _i6.ChatMessageIncludeList? receivedMessages,
    _i7.FavoriteIncludeList? favorites,
    _i8.ReviewIncludeList? reviews,
  }) {
    _userInfo = userInfo;
    _rooms = rooms;
    _bookings = bookings;
    _sentMessages = sentMessages;
    _receivedMessages = receivedMessages;
    _favorites = favorites;
    _reviews = reviews;
  }

  _i2.UserInfoInclude? _userInfo;

  _i4.RoomIncludeList? _rooms;

  _i5.BookingIncludeList? _bookings;

  _i6.ChatMessageIncludeList? _sentMessages;

  _i6.ChatMessageIncludeList? _receivedMessages;

  _i7.FavoriteIncludeList? _favorites;

  _i8.ReviewIncludeList? _reviews;

  @override
  Map<String, _i1.Include?> get includes => {
    'userInfo': _userInfo,
    'rooms': _rooms,
    'bookings': _bookings,
    'sentMessages': _sentMessages,
    'receivedMessages': _receivedMessages,
    'favorites': _favorites,
    'reviews': _reviews,
  };

  @override
  _i1.Table<int?> get table => User.t;
}

class UserIncludeList extends _i1.IncludeList {
  UserIncludeList._({
    _i1.WhereExpressionBuilder<UserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(User.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => User.t;
}

class UserRepository {
  const UserRepository._();

  final attach = const UserAttachRepository._();

  final attachRow = const UserAttachRowRepository._();

  final detach = const UserDetachRepository._();

  final detachRow = const UserDetachRowRepository._();

  /// Returns a list of [User]s matching the given query parameters.
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
  Future<List<User>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    _i1.Transaction? transaction,
    UserInclude? include,
  }) async {
    return session.db.find<User>(
      where: where?.call(User.t),
      orderBy: orderBy?.call(User.t),
      orderByList: orderByList?.call(User.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [User] matching the given query parameters.
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
  Future<User?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    _i1.Transaction? transaction,
    UserInclude? include,
  }) async {
    return session.db.findFirstRow<User>(
      where: where?.call(User.t),
      orderBy: orderBy?.call(User.t),
      orderByList: orderByList?.call(User.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [User] by its [id] or null if no such row exists.
  Future<User?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    UserInclude? include,
  }) async {
    return session.db.findById<User>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [User]s in the list and returns the inserted rows.
  ///
  /// The returned [User]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<User>> insert(
    _i1.Session session,
    List<User> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<User>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [User] and returns the inserted row.
  ///
  /// The returned [User] will have its `id` field set.
  Future<User> insertRow(
    _i1.Session session,
    User row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<User>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [User]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<User>> update(
    _i1.Session session,
    List<User> rows, {
    _i1.ColumnSelections<UserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<User>(
      rows,
      columns: columns?.call(User.t),
      transaction: transaction,
    );
  }

  /// Updates a single [User]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<User> updateRow(
    _i1.Session session,
    User row, {
    _i1.ColumnSelections<UserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<User>(
      row,
      columns: columns?.call(User.t),
      transaction: transaction,
    );
  }

  /// Updates a single [User] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<User?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UserUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<User>(
      id,
      columnValues: columnValues(User.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [User]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<User>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UserTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<User>(
      columnValues: columnValues(User.t.updateTable),
      where: where(User.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(User.t),
      orderByList: orderByList?.call(User.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [User]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<User>> delete(
    _i1.Session session,
    List<User> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<User>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [User].
  Future<User> deleteRow(
    _i1.Session session,
    User row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<User>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<User>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<User>(
      where: where(User.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<User>(
      where: where?.call(User.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class UserAttachRepository {
  const UserAttachRepository._();

  /// Creates a relation between this [User] and the given [Room]s
  /// by setting each [Room]'s foreign key `ownerId` to refer to this [User].
  Future<void> rooms(
    _i1.Session session,
    User user,
    List<_i4.Room> room, {
    _i1.Transaction? transaction,
  }) async {
    if (room.any((e) => e.id == null)) {
      throw ArgumentError.notNull('room.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $room = room.map((e) => e.copyWith(ownerId: user.id)).toList();
    await session.db.update<_i4.Room>(
      $room,
      columns: [_i4.Room.t.ownerId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [User] and the given [Booking]s
  /// by setting each [Booking]'s foreign key `userId` to refer to this [User].
  Future<void> bookings(
    _i1.Session session,
    User user,
    List<_i5.Booking> booking, {
    _i1.Transaction? transaction,
  }) async {
    if (booking.any((e) => e.id == null)) {
      throw ArgumentError.notNull('booking.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $booking = booking.map((e) => e.copyWith(userId: user.id)).toList();
    await session.db.update<_i5.Booking>(
      $booking,
      columns: [_i5.Booking.t.userId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [User] and the given [ChatMessage]s
  /// by setting each [ChatMessage]'s foreign key `senderId` to refer to this [User].
  Future<void> sentMessages(
    _i1.Session session,
    User user,
    List<_i6.ChatMessage> chatMessage, {
    _i1.Transaction? transaction,
  }) async {
    if (chatMessage.any((e) => e.id == null)) {
      throw ArgumentError.notNull('chatMessage.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $chatMessage = chatMessage
        .map((e) => e.copyWith(senderId: user.id))
        .toList();
    await session.db.update<_i6.ChatMessage>(
      $chatMessage,
      columns: [_i6.ChatMessage.t.senderId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [User] and the given [ChatMessage]s
  /// by setting each [ChatMessage]'s foreign key `receiverId` to refer to this [User].
  Future<void> receivedMessages(
    _i1.Session session,
    User user,
    List<_i6.ChatMessage> chatMessage, {
    _i1.Transaction? transaction,
  }) async {
    if (chatMessage.any((e) => e.id == null)) {
      throw ArgumentError.notNull('chatMessage.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $chatMessage = chatMessage
        .map((e) => e.copyWith(receiverId: user.id))
        .toList();
    await session.db.update<_i6.ChatMessage>(
      $chatMessage,
      columns: [_i6.ChatMessage.t.receiverId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [User] and the given [Favorite]s
  /// by setting each [Favorite]'s foreign key `_userFavoritesUserId` to refer to this [User].
  Future<void> favorites(
    _i1.Session session,
    User user,
    List<_i7.Favorite> favorite, {
    _i1.Transaction? transaction,
  }) async {
    if (favorite.any((e) => e.id == null)) {
      throw ArgumentError.notNull('favorite.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $favorite = favorite
        .map(
          (e) => _i7.FavoriteImplicit(
            e,
            $_userFavoritesUserId: user.id,
          ),
        )
        .toList();
    await session.db.update<_i7.Favorite>(
      $favorite,
      columns: [_i7.Favorite.t.$_userFavoritesUserId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [User] and the given [Review]s
  /// by setting each [Review]'s foreign key `_userReviewsUserId` to refer to this [User].
  Future<void> reviews(
    _i1.Session session,
    User user,
    List<_i8.Review> review, {
    _i1.Transaction? transaction,
  }) async {
    if (review.any((e) => e.id == null)) {
      throw ArgumentError.notNull('review.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $review = review
        .map(
          (e) => _i8.ReviewImplicit(
            e,
            $_userReviewsUserId: user.id,
          ),
        )
        .toList();
    await session.db.update<_i8.Review>(
      $review,
      columns: [_i8.Review.t.$_userReviewsUserId],
      transaction: transaction,
    );
  }
}

class UserAttachRowRepository {
  const UserAttachRowRepository._();

  /// Creates a relation between the given [User] and [UserInfo]
  /// by setting the [User]'s foreign key `userInfoId` to refer to the [UserInfo].
  Future<void> userInfo(
    _i1.Session session,
    User user,
    _i2.UserInfo userInfo, {
    _i1.Transaction? transaction,
  }) async {
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }
    if (userInfo.id == null) {
      throw ArgumentError.notNull('userInfo.id');
    }

    var $user = user.copyWith(userInfoId: userInfo.id);
    await session.db.updateRow<User>(
      $user,
      columns: [User.t.userInfoId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [User] and the given [Room]
  /// by setting the [Room]'s foreign key `ownerId` to refer to this [User].
  Future<void> rooms(
    _i1.Session session,
    User user,
    _i4.Room room, {
    _i1.Transaction? transaction,
  }) async {
    if (room.id == null) {
      throw ArgumentError.notNull('room.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $room = room.copyWith(ownerId: user.id);
    await session.db.updateRow<_i4.Room>(
      $room,
      columns: [_i4.Room.t.ownerId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [User] and the given [Booking]
  /// by setting the [Booking]'s foreign key `userId` to refer to this [User].
  Future<void> bookings(
    _i1.Session session,
    User user,
    _i5.Booking booking, {
    _i1.Transaction? transaction,
  }) async {
    if (booking.id == null) {
      throw ArgumentError.notNull('booking.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $booking = booking.copyWith(userId: user.id);
    await session.db.updateRow<_i5.Booking>(
      $booking,
      columns: [_i5.Booking.t.userId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [User] and the given [ChatMessage]
  /// by setting the [ChatMessage]'s foreign key `senderId` to refer to this [User].
  Future<void> sentMessages(
    _i1.Session session,
    User user,
    _i6.ChatMessage chatMessage, {
    _i1.Transaction? transaction,
  }) async {
    if (chatMessage.id == null) {
      throw ArgumentError.notNull('chatMessage.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $chatMessage = chatMessage.copyWith(senderId: user.id);
    await session.db.updateRow<_i6.ChatMessage>(
      $chatMessage,
      columns: [_i6.ChatMessage.t.senderId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [User] and the given [ChatMessage]
  /// by setting the [ChatMessage]'s foreign key `receiverId` to refer to this [User].
  Future<void> receivedMessages(
    _i1.Session session,
    User user,
    _i6.ChatMessage chatMessage, {
    _i1.Transaction? transaction,
  }) async {
    if (chatMessage.id == null) {
      throw ArgumentError.notNull('chatMessage.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $chatMessage = chatMessage.copyWith(receiverId: user.id);
    await session.db.updateRow<_i6.ChatMessage>(
      $chatMessage,
      columns: [_i6.ChatMessage.t.receiverId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [User] and the given [Favorite]
  /// by setting the [Favorite]'s foreign key `_userFavoritesUserId` to refer to this [User].
  Future<void> favorites(
    _i1.Session session,
    User user,
    _i7.Favorite favorite, {
    _i1.Transaction? transaction,
  }) async {
    if (favorite.id == null) {
      throw ArgumentError.notNull('favorite.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $favorite = _i7.FavoriteImplicit(
      favorite,
      $_userFavoritesUserId: user.id,
    );
    await session.db.updateRow<_i7.Favorite>(
      $favorite,
      columns: [_i7.Favorite.t.$_userFavoritesUserId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [User] and the given [Review]
  /// by setting the [Review]'s foreign key `_userReviewsUserId` to refer to this [User].
  Future<void> reviews(
    _i1.Session session,
    User user,
    _i8.Review review, {
    _i1.Transaction? transaction,
  }) async {
    if (review.id == null) {
      throw ArgumentError.notNull('review.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $review = _i8.ReviewImplicit(
      review,
      $_userReviewsUserId: user.id,
    );
    await session.db.updateRow<_i8.Review>(
      $review,
      columns: [_i8.Review.t.$_userReviewsUserId],
      transaction: transaction,
    );
  }
}

class UserDetachRepository {
  const UserDetachRepository._();

  /// Detaches the relation between this [User] and the given [Favorite]
  /// by setting the [Favorite]'s foreign key `_userFavoritesUserId` to `null`.
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
            $_userFavoritesUserId: null,
          ),
        )
        .toList();
    await session.db.update<_i7.Favorite>(
      $favorite,
      columns: [_i7.Favorite.t.$_userFavoritesUserId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [User] and the given [Review]
  /// by setting the [Review]'s foreign key `_userReviewsUserId` to `null`.
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
            $_userReviewsUserId: null,
          ),
        )
        .toList();
    await session.db.update<_i8.Review>(
      $review,
      columns: [_i8.Review.t.$_userReviewsUserId],
      transaction: transaction,
    );
  }
}

class UserDetachRowRepository {
  const UserDetachRowRepository._();

  /// Detaches the relation between this [User] and the [UserInfo] set in `userInfo`
  /// by setting the [User]'s foreign key `userInfoId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> userInfo(
    _i1.Session session,
    User user, {
    _i1.Transaction? transaction,
  }) async {
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $user = user.copyWith(userInfoId: null);
    await session.db.updateRow<User>(
      $user,
      columns: [User.t.userInfoId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [User] and the given [Favorite]
  /// by setting the [Favorite]'s foreign key `_userFavoritesUserId` to `null`.
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
      $_userFavoritesUserId: null,
    );
    await session.db.updateRow<_i7.Favorite>(
      $favorite,
      columns: [_i7.Favorite.t.$_userFavoritesUserId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [User] and the given [Review]
  /// by setting the [Review]'s foreign key `_userReviewsUserId` to `null`.
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
      $_userReviewsUserId: null,
    );
    await session.db.updateRow<_i8.Review>(
      $review,
      columns: [_i8.Review.t.$_userReviewsUserId],
      transaction: transaction,
    );
  }
}
