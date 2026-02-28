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
import 'room.dart' as _i3;
import 'package:dwellly_server/src/generated/protocol.dart' as _i4;

abstract class Favorite
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Favorite._({
    this.id,
    required this.userId,
    this.user,
    required this.roomId,
    this.room,
    required this.createdAt,
  }) : _roomFavoritesRoomId = null,
       _userFavoritesUserId = null;

  factory Favorite({
    int? id,
    required int userId,
    _i2.User? user,
    required int roomId,
    _i3.Room? room,
    required DateTime createdAt,
  }) = _FavoriteImpl;

  factory Favorite.fromJson(Map<String, dynamic> jsonSerialization) {
    return FavoriteImplicit._(
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
      $_roomFavoritesRoomId: jsonSerialization['_roomFavoritesRoomId'] as int?,
      $_userFavoritesUserId: jsonSerialization['_userFavoritesUserId'] as int?,
    );
  }

  static final t = FavoriteTable();

  static const db = FavoriteRepository._();

  @override
  int? id;

  int userId;

  _i2.User? user;

  int roomId;

  _i3.Room? room;

  DateTime createdAt;

  final int? _roomFavoritesRoomId;

  final int? _userFavoritesUserId;

  @override
  _i1.Table<int?> get table => t;

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
      if (_roomFavoritesRoomId != null)
        '_roomFavoritesRoomId': _roomFavoritesRoomId,
      if (_userFavoritesUserId != null)
        '_userFavoritesUserId': _userFavoritesUserId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Favorite',
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJsonForProtocol(),
      'roomId': roomId,
      if (room != null) 'room': room?.toJsonForProtocol(),
      'createdAt': createdAt.toJson(),
    };
  }

  static FavoriteInclude include({
    _i2.UserInclude? user,
    _i3.RoomInclude? room,
  }) {
    return FavoriteInclude._(
      user: user,
      room: room,
    );
  }

  static FavoriteIncludeList includeList({
    _i1.WhereExpressionBuilder<FavoriteTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FavoriteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FavoriteTable>? orderByList,
    FavoriteInclude? include,
  }) {
    return FavoriteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Favorite.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Favorite.t),
      include: include,
    );
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
    return FavoriteImplicit._(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      roomId: roomId ?? this.roomId,
      room: room is _i3.Room? ? room : this.room?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      $_roomFavoritesRoomId: this._roomFavoritesRoomId,
      $_userFavoritesUserId: this._userFavoritesUserId,
    );
  }
}

class FavoriteImplicit extends _FavoriteImpl {
  FavoriteImplicit._({
    int? id,
    required int userId,
    _i2.User? user,
    required int roomId,
    _i3.Room? room,
    required DateTime createdAt,
    int? $_roomFavoritesRoomId,
    int? $_userFavoritesUserId,
  }) : _roomFavoritesRoomId = $_roomFavoritesRoomId,
       _userFavoritesUserId = $_userFavoritesUserId,
       super(
         id: id,
         userId: userId,
         user: user,
         roomId: roomId,
         room: room,
         createdAt: createdAt,
       );

  factory FavoriteImplicit(
    Favorite favorite, {
    int? $_roomFavoritesRoomId,
    int? $_userFavoritesUserId,
  }) {
    return FavoriteImplicit._(
      id: favorite.id,
      userId: favorite.userId,
      user: favorite.user,
      roomId: favorite.roomId,
      room: favorite.room,
      createdAt: favorite.createdAt,
      $_roomFavoritesRoomId: $_roomFavoritesRoomId,
      $_userFavoritesUserId: $_userFavoritesUserId,
    );
  }

  @override
  final int? _roomFavoritesRoomId;

  @override
  final int? _userFavoritesUserId;
}

class FavoriteUpdateTable extends _i1.UpdateTable<FavoriteTable> {
  FavoriteUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> roomId(int value) => _i1.ColumnValue(
    table.roomId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<int, int> $_roomFavoritesRoomId(int? value) =>
      _i1.ColumnValue(
        table.$_roomFavoritesRoomId,
        value,
      );

  _i1.ColumnValue<int, int> $_userFavoritesUserId(int? value) =>
      _i1.ColumnValue(
        table.$_userFavoritesUserId,
        value,
      );
}

class FavoriteTable extends _i1.Table<int?> {
  FavoriteTable({super.tableRelation}) : super(tableName: 'favorite') {
    updateTable = FavoriteUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    roomId = _i1.ColumnInt(
      'roomId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    $_roomFavoritesRoomId = _i1.ColumnInt(
      '_roomFavoritesRoomId',
      this,
    );
    $_userFavoritesUserId = _i1.ColumnInt(
      '_userFavoritesUserId',
      this,
    );
  }

  late final FavoriteUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  _i2.UserTable? _user;

  late final _i1.ColumnInt roomId;

  _i3.RoomTable? _room;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnInt $_roomFavoritesRoomId;

  late final _i1.ColumnInt $_userFavoritesUserId;

  _i2.UserTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: Favorite.t.userId,
      foreignField: _i2.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  _i3.RoomTable get room {
    if (_room != null) return _room!;
    _room = _i1.createRelationTable(
      relationFieldName: 'room',
      field: Favorite.t.roomId,
      foreignField: _i3.Room.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.RoomTable(tableRelation: foreignTableRelation),
    );
    return _room!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    roomId,
    createdAt,
    $_roomFavoritesRoomId,
    $_userFavoritesUserId,
  ];

  @override
  List<_i1.Column> get managedColumns => [
    id,
    userId,
    roomId,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'user') {
      return user;
    }
    if (relationField == 'room') {
      return room;
    }
    return null;
  }
}

class FavoriteInclude extends _i1.IncludeObject {
  FavoriteInclude._({
    _i2.UserInclude? user,
    _i3.RoomInclude? room,
  }) {
    _user = user;
    _room = room;
  }

  _i2.UserInclude? _user;

  _i3.RoomInclude? _room;

  @override
  Map<String, _i1.Include?> get includes => {
    'user': _user,
    'room': _room,
  };

  @override
  _i1.Table<int?> get table => Favorite.t;
}

class FavoriteIncludeList extends _i1.IncludeList {
  FavoriteIncludeList._({
    _i1.WhereExpressionBuilder<FavoriteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Favorite.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Favorite.t;
}

class FavoriteRepository {
  const FavoriteRepository._();

  final attachRow = const FavoriteAttachRowRepository._();

  /// Returns a list of [Favorite]s matching the given query parameters.
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
  Future<List<Favorite>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FavoriteTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FavoriteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FavoriteTable>? orderByList,
    _i1.Transaction? transaction,
    FavoriteInclude? include,
  }) async {
    return session.db.find<Favorite>(
      where: where?.call(Favorite.t),
      orderBy: orderBy?.call(Favorite.t),
      orderByList: orderByList?.call(Favorite.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Favorite] matching the given query parameters.
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
  Future<Favorite?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FavoriteTable>? where,
    int? offset,
    _i1.OrderByBuilder<FavoriteTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FavoriteTable>? orderByList,
    _i1.Transaction? transaction,
    FavoriteInclude? include,
  }) async {
    return session.db.findFirstRow<Favorite>(
      where: where?.call(Favorite.t),
      orderBy: orderBy?.call(Favorite.t),
      orderByList: orderByList?.call(Favorite.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Favorite] by its [id] or null if no such row exists.
  Future<Favorite?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    FavoriteInclude? include,
  }) async {
    return session.db.findById<Favorite>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Favorite]s in the list and returns the inserted rows.
  ///
  /// The returned [Favorite]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Favorite>> insert(
    _i1.Session session,
    List<Favorite> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Favorite>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Favorite] and returns the inserted row.
  ///
  /// The returned [Favorite] will have its `id` field set.
  Future<Favorite> insertRow(
    _i1.Session session,
    Favorite row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Favorite>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Favorite]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Favorite>> update(
    _i1.Session session,
    List<Favorite> rows, {
    _i1.ColumnSelections<FavoriteTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Favorite>(
      rows,
      columns: columns?.call(Favorite.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Favorite]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Favorite> updateRow(
    _i1.Session session,
    Favorite row, {
    _i1.ColumnSelections<FavoriteTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Favorite>(
      row,
      columns: columns?.call(Favorite.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Favorite] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Favorite?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<FavoriteUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Favorite>(
      id,
      columnValues: columnValues(Favorite.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Favorite]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Favorite>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<FavoriteUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<FavoriteTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FavoriteTable>? orderBy,
    _i1.OrderByListBuilder<FavoriteTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Favorite>(
      columnValues: columnValues(Favorite.t.updateTable),
      where: where(Favorite.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Favorite.t),
      orderByList: orderByList?.call(Favorite.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Favorite]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Favorite>> delete(
    _i1.Session session,
    List<Favorite> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Favorite>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Favorite].
  Future<Favorite> deleteRow(
    _i1.Session session,
    Favorite row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Favorite>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Favorite>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<FavoriteTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Favorite>(
      where: where(Favorite.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FavoriteTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Favorite>(
      where: where?.call(Favorite.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class FavoriteAttachRowRepository {
  const FavoriteAttachRowRepository._();

  /// Creates a relation between the given [Favorite] and [User]
  /// by setting the [Favorite]'s foreign key `userId` to refer to the [User].
  Future<void> user(
    _i1.Session session,
    Favorite favorite,
    _i2.User user, {
    _i1.Transaction? transaction,
  }) async {
    if (favorite.id == null) {
      throw ArgumentError.notNull('favorite.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $favorite = favorite.copyWith(userId: user.id);
    await session.db.updateRow<Favorite>(
      $favorite,
      columns: [Favorite.t.userId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Favorite] and [Room]
  /// by setting the [Favorite]'s foreign key `roomId` to refer to the [Room].
  Future<void> room(
    _i1.Session session,
    Favorite favorite,
    _i3.Room room, {
    _i1.Transaction? transaction,
  }) async {
    if (favorite.id == null) {
      throw ArgumentError.notNull('favorite.id');
    }
    if (room.id == null) {
      throw ArgumentError.notNull('room.id');
    }

    var $favorite = favorite.copyWith(roomId: room.id);
    await session.db.updateRow<Favorite>(
      $favorite,
      columns: [Favorite.t.roomId],
      transaction: transaction,
    );
  }
}
