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
import 'room.dart' as _i2;
import 'user.dart' as _i3;
import 'package:room_rental_server/src/generated/protocol.dart' as _i4;

abstract class Review implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Review._({
    this.id,
    required this.roomId,
    this.room,
    required this.userId,
    this.user,
    required this.rating,
    required this.comment,
    required this.createdAt,
  }) : _roomReviewsRoomId = null,
       _userReviewsUserId = null;

  factory Review({
    int? id,
    required int roomId,
    _i2.Room? room,
    required int userId,
    _i3.User? user,
    required int rating,
    required String comment,
    required DateTime createdAt,
  }) = _ReviewImpl;

  factory Review.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReviewImplicit._(
      id: jsonSerialization['id'] as int?,
      roomId: jsonSerialization['roomId'] as int,
      room: jsonSerialization['room'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.Room>(jsonSerialization['room']),
      userId: jsonSerialization['userId'] as int,
      user: jsonSerialization['user'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.User>(jsonSerialization['user']),
      rating: jsonSerialization['rating'] as int,
      comment: jsonSerialization['comment'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      $_roomReviewsRoomId: jsonSerialization['_roomReviewsRoomId'] as int?,
      $_userReviewsUserId: jsonSerialization['_userReviewsUserId'] as int?,
    );
  }

  static final t = ReviewTable();

  static const db = ReviewRepository._();

  @override
  int? id;

  int roomId;

  _i2.Room? room;

  int userId;

  _i3.User? user;

  int rating;

  String comment;

  DateTime createdAt;

  final int? _roomReviewsRoomId;

  final int? _userReviewsUserId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Review]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Review copyWith({
    int? id,
    int? roomId,
    _i2.Room? room,
    int? userId,
    _i3.User? user,
    int? rating,
    String? comment,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Review',
      if (id != null) 'id': id,
      'roomId': roomId,
      if (room != null) 'room': room?.toJson(),
      'userId': userId,
      if (user != null) 'user': user?.toJson(),
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toJson(),
      if (_roomReviewsRoomId != null) '_roomReviewsRoomId': _roomReviewsRoomId,
      if (_userReviewsUserId != null) '_userReviewsUserId': _userReviewsUserId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Review',
      if (id != null) 'id': id,
      'roomId': roomId,
      if (room != null) 'room': room?.toJsonForProtocol(),
      'userId': userId,
      if (user != null) 'user': user?.toJsonForProtocol(),
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toJson(),
    };
  }

  static ReviewInclude include({
    _i2.RoomInclude? room,
    _i3.UserInclude? user,
  }) {
    return ReviewInclude._(
      room: room,
      user: user,
    );
  }

  static ReviewIncludeList includeList({
    _i1.WhereExpressionBuilder<ReviewTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReviewTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReviewTable>? orderByList,
    ReviewInclude? include,
  }) {
    return ReviewIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Review.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Review.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReviewImpl extends Review {
  _ReviewImpl({
    int? id,
    required int roomId,
    _i2.Room? room,
    required int userId,
    _i3.User? user,
    required int rating,
    required String comment,
    required DateTime createdAt,
  }) : super._(
         id: id,
         roomId: roomId,
         room: room,
         userId: userId,
         user: user,
         rating: rating,
         comment: comment,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Review]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Review copyWith({
    Object? id = _Undefined,
    int? roomId,
    Object? room = _Undefined,
    int? userId,
    Object? user = _Undefined,
    int? rating,
    String? comment,
    DateTime? createdAt,
  }) {
    return ReviewImplicit._(
      id: id is int? ? id : this.id,
      roomId: roomId ?? this.roomId,
      room: room is _i2.Room? ? room : this.room?.copyWith(),
      userId: userId ?? this.userId,
      user: user is _i3.User? ? user : this.user?.copyWith(),
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      $_roomReviewsRoomId: this._roomReviewsRoomId,
      $_userReviewsUserId: this._userReviewsUserId,
    );
  }
}

class ReviewImplicit extends _ReviewImpl {
  ReviewImplicit._({
    int? id,
    required int roomId,
    _i2.Room? room,
    required int userId,
    _i3.User? user,
    required int rating,
    required String comment,
    required DateTime createdAt,
    int? $_roomReviewsRoomId,
    int? $_userReviewsUserId,
  }) : _roomReviewsRoomId = $_roomReviewsRoomId,
       _userReviewsUserId = $_userReviewsUserId,
       super(
         id: id,
         roomId: roomId,
         room: room,
         userId: userId,
         user: user,
         rating: rating,
         comment: comment,
         createdAt: createdAt,
       );

  factory ReviewImplicit(
    Review review, {
    int? $_roomReviewsRoomId,
    int? $_userReviewsUserId,
  }) {
    return ReviewImplicit._(
      id: review.id,
      roomId: review.roomId,
      room: review.room,
      userId: review.userId,
      user: review.user,
      rating: review.rating,
      comment: review.comment,
      createdAt: review.createdAt,
      $_roomReviewsRoomId: $_roomReviewsRoomId,
      $_userReviewsUserId: $_userReviewsUserId,
    );
  }

  @override
  final int? _roomReviewsRoomId;

  @override
  final int? _userReviewsUserId;
}

class ReviewUpdateTable extends _i1.UpdateTable<ReviewTable> {
  ReviewUpdateTable(super.table);

  _i1.ColumnValue<int, int> roomId(int value) => _i1.ColumnValue(
    table.roomId,
    value,
  );

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> rating(int value) => _i1.ColumnValue(
    table.rating,
    value,
  );

  _i1.ColumnValue<String, String> comment(String value) => _i1.ColumnValue(
    table.comment,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<int, int> $_roomReviewsRoomId(int? value) => _i1.ColumnValue(
    table.$_roomReviewsRoomId,
    value,
  );

  _i1.ColumnValue<int, int> $_userReviewsUserId(int? value) => _i1.ColumnValue(
    table.$_userReviewsUserId,
    value,
  );
}

class ReviewTable extends _i1.Table<int?> {
  ReviewTable({super.tableRelation}) : super(tableName: 'review') {
    updateTable = ReviewUpdateTable(this);
    roomId = _i1.ColumnInt(
      'roomId',
      this,
    );
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    rating = _i1.ColumnInt(
      'rating',
      this,
    );
    comment = _i1.ColumnString(
      'comment',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    $_roomReviewsRoomId = _i1.ColumnInt(
      '_roomReviewsRoomId',
      this,
    );
    $_userReviewsUserId = _i1.ColumnInt(
      '_userReviewsUserId',
      this,
    );
  }

  late final ReviewUpdateTable updateTable;

  late final _i1.ColumnInt roomId;

  _i2.RoomTable? _room;

  late final _i1.ColumnInt userId;

  _i3.UserTable? _user;

  late final _i1.ColumnInt rating;

  late final _i1.ColumnString comment;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnInt $_roomReviewsRoomId;

  late final _i1.ColumnInt $_userReviewsUserId;

  _i2.RoomTable get room {
    if (_room != null) return _room!;
    _room = _i1.createRelationTable(
      relationFieldName: 'room',
      field: Review.t.roomId,
      foreignField: _i2.Room.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.RoomTable(tableRelation: foreignTableRelation),
    );
    return _room!;
  }

  _i3.UserTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: Review.t.userId,
      foreignField: _i3.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.UserTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    roomId,
    userId,
    rating,
    comment,
    createdAt,
    $_roomReviewsRoomId,
    $_userReviewsUserId,
  ];

  @override
  List<_i1.Column> get managedColumns => [
    id,
    roomId,
    userId,
    rating,
    comment,
    createdAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'room') {
      return room;
    }
    if (relationField == 'user') {
      return user;
    }
    return null;
  }
}

class ReviewInclude extends _i1.IncludeObject {
  ReviewInclude._({
    _i2.RoomInclude? room,
    _i3.UserInclude? user,
  }) {
    _room = room;
    _user = user;
  }

  _i2.RoomInclude? _room;

  _i3.UserInclude? _user;

  @override
  Map<String, _i1.Include?> get includes => {
    'room': _room,
    'user': _user,
  };

  @override
  _i1.Table<int?> get table => Review.t;
}

class ReviewIncludeList extends _i1.IncludeList {
  ReviewIncludeList._({
    _i1.WhereExpressionBuilder<ReviewTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Review.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Review.t;
}

class ReviewRepository {
  const ReviewRepository._();

  final attachRow = const ReviewAttachRowRepository._();

  /// Returns a list of [Review]s matching the given query parameters.
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
  Future<List<Review>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReviewTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReviewTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReviewTable>? orderByList,
    _i1.Transaction? transaction,
    ReviewInclude? include,
  }) async {
    return session.db.find<Review>(
      where: where?.call(Review.t),
      orderBy: orderBy?.call(Review.t),
      orderByList: orderByList?.call(Review.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Review] matching the given query parameters.
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
  Future<Review?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReviewTable>? where,
    int? offset,
    _i1.OrderByBuilder<ReviewTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReviewTable>? orderByList,
    _i1.Transaction? transaction,
    ReviewInclude? include,
  }) async {
    return session.db.findFirstRow<Review>(
      where: where?.call(Review.t),
      orderBy: orderBy?.call(Review.t),
      orderByList: orderByList?.call(Review.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Review] by its [id] or null if no such row exists.
  Future<Review?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ReviewInclude? include,
  }) async {
    return session.db.findById<Review>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Review]s in the list and returns the inserted rows.
  ///
  /// The returned [Review]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Review>> insert(
    _i1.Session session,
    List<Review> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Review>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Review] and returns the inserted row.
  ///
  /// The returned [Review] will have its `id` field set.
  Future<Review> insertRow(
    _i1.Session session,
    Review row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Review>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Review]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Review>> update(
    _i1.Session session,
    List<Review> rows, {
    _i1.ColumnSelections<ReviewTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Review>(
      rows,
      columns: columns?.call(Review.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Review]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Review> updateRow(
    _i1.Session session,
    Review row, {
    _i1.ColumnSelections<ReviewTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Review>(
      row,
      columns: columns?.call(Review.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Review] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Review?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ReviewUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Review>(
      id,
      columnValues: columnValues(Review.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Review]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Review>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ReviewUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ReviewTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReviewTable>? orderBy,
    _i1.OrderByListBuilder<ReviewTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Review>(
      columnValues: columnValues(Review.t.updateTable),
      where: where(Review.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Review.t),
      orderByList: orderByList?.call(Review.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Review]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Review>> delete(
    _i1.Session session,
    List<Review> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Review>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Review].
  Future<Review> deleteRow(
    _i1.Session session,
    Review row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Review>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Review>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ReviewTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Review>(
      where: where(Review.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReviewTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Review>(
      where: where?.call(Review.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ReviewAttachRowRepository {
  const ReviewAttachRowRepository._();

  /// Creates a relation between the given [Review] and [Room]
  /// by setting the [Review]'s foreign key `roomId` to refer to the [Room].
  Future<void> room(
    _i1.Session session,
    Review review,
    _i2.Room room, {
    _i1.Transaction? transaction,
  }) async {
    if (review.id == null) {
      throw ArgumentError.notNull('review.id');
    }
    if (room.id == null) {
      throw ArgumentError.notNull('room.id');
    }

    var $review = review.copyWith(roomId: room.id);
    await session.db.updateRow<Review>(
      $review,
      columns: [Review.t.roomId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Review] and [User]
  /// by setting the [Review]'s foreign key `userId` to refer to the [User].
  Future<void> user(
    _i1.Session session,
    Review review,
    _i3.User user, {
    _i1.Transaction? transaction,
  }) async {
    if (review.id == null) {
      throw ArgumentError.notNull('review.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $review = review.copyWith(userId: user.id);
    await session.db.updateRow<Review>(
      $review,
      columns: [Review.t.userId],
      transaction: transaction,
    );
  }
}
