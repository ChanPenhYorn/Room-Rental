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
import 'owner_request_status.dart' as _i3;
import 'package:room_rental_server/src/generated/protocol.dart' as _i4;

abstract class BecomeOwnerRequest
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = BecomeOwnerRequestTable();

  static const db = BecomeOwnerRequestRepository._();

  @override
  int? id;

  int userId;

  _i2.User? user;

  String? message;

  _i3.OwnerRequestStatus status;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BecomeOwnerRequest',
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJsonForProtocol(),
      if (message != null) 'message': message,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static BecomeOwnerRequestInclude include({_i2.UserInclude? user}) {
    return BecomeOwnerRequestInclude._(user: user);
  }

  static BecomeOwnerRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<BecomeOwnerRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BecomeOwnerRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BecomeOwnerRequestTable>? orderByList,
    BecomeOwnerRequestInclude? include,
  }) {
    return BecomeOwnerRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BecomeOwnerRequest.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BecomeOwnerRequest.t),
      include: include,
    );
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

class BecomeOwnerRequestUpdateTable
    extends _i1.UpdateTable<BecomeOwnerRequestTable> {
  BecomeOwnerRequestUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> message(String? value) => _i1.ColumnValue(
    table.message,
    value,
  );

  _i1.ColumnValue<_i3.OwnerRequestStatus, _i3.OwnerRequestStatus> status(
    _i3.OwnerRequestStatus value,
  ) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class BecomeOwnerRequestTable extends _i1.Table<int?> {
  BecomeOwnerRequestTable({super.tableRelation})
    : super(tableName: 'become_owner_request') {
    updateTable = BecomeOwnerRequestUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    message = _i1.ColumnString(
      'message',
      this,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final BecomeOwnerRequestUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  _i2.UserTable? _user;

  late final _i1.ColumnString message;

  late final _i1.ColumnEnum<_i3.OwnerRequestStatus> status;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  _i2.UserTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: BecomeOwnerRequest.t.userId,
      foreignField: _i2.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    message,
    status,
    createdAt,
    updatedAt,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'user') {
      return user;
    }
    return null;
  }
}

class BecomeOwnerRequestInclude extends _i1.IncludeObject {
  BecomeOwnerRequestInclude._({_i2.UserInclude? user}) {
    _user = user;
  }

  _i2.UserInclude? _user;

  @override
  Map<String, _i1.Include?> get includes => {'user': _user};

  @override
  _i1.Table<int?> get table => BecomeOwnerRequest.t;
}

class BecomeOwnerRequestIncludeList extends _i1.IncludeList {
  BecomeOwnerRequestIncludeList._({
    _i1.WhereExpressionBuilder<BecomeOwnerRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BecomeOwnerRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BecomeOwnerRequest.t;
}

class BecomeOwnerRequestRepository {
  const BecomeOwnerRequestRepository._();

  final attachRow = const BecomeOwnerRequestAttachRowRepository._();

  /// Returns a list of [BecomeOwnerRequest]s matching the given query parameters.
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
  Future<List<BecomeOwnerRequest>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BecomeOwnerRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BecomeOwnerRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BecomeOwnerRequestTable>? orderByList,
    _i1.Transaction? transaction,
    BecomeOwnerRequestInclude? include,
  }) async {
    return session.db.find<BecomeOwnerRequest>(
      where: where?.call(BecomeOwnerRequest.t),
      orderBy: orderBy?.call(BecomeOwnerRequest.t),
      orderByList: orderByList?.call(BecomeOwnerRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [BecomeOwnerRequest] matching the given query parameters.
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
  Future<BecomeOwnerRequest?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BecomeOwnerRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<BecomeOwnerRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BecomeOwnerRequestTable>? orderByList,
    _i1.Transaction? transaction,
    BecomeOwnerRequestInclude? include,
  }) async {
    return session.db.findFirstRow<BecomeOwnerRequest>(
      where: where?.call(BecomeOwnerRequest.t),
      orderBy: orderBy?.call(BecomeOwnerRequest.t),
      orderByList: orderByList?.call(BecomeOwnerRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [BecomeOwnerRequest] by its [id] or null if no such row exists.
  Future<BecomeOwnerRequest?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    BecomeOwnerRequestInclude? include,
  }) async {
    return session.db.findById<BecomeOwnerRequest>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [BecomeOwnerRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [BecomeOwnerRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BecomeOwnerRequest>> insert(
    _i1.Session session,
    List<BecomeOwnerRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BecomeOwnerRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BecomeOwnerRequest] and returns the inserted row.
  ///
  /// The returned [BecomeOwnerRequest] will have its `id` field set.
  Future<BecomeOwnerRequest> insertRow(
    _i1.Session session,
    BecomeOwnerRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BecomeOwnerRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BecomeOwnerRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BecomeOwnerRequest>> update(
    _i1.Session session,
    List<BecomeOwnerRequest> rows, {
    _i1.ColumnSelections<BecomeOwnerRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BecomeOwnerRequest>(
      rows,
      columns: columns?.call(BecomeOwnerRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BecomeOwnerRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BecomeOwnerRequest> updateRow(
    _i1.Session session,
    BecomeOwnerRequest row, {
    _i1.ColumnSelections<BecomeOwnerRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BecomeOwnerRequest>(
      row,
      columns: columns?.call(BecomeOwnerRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BecomeOwnerRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BecomeOwnerRequest?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<BecomeOwnerRequestUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<BecomeOwnerRequest>(
      id,
      columnValues: columnValues(BecomeOwnerRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BecomeOwnerRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<BecomeOwnerRequest>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<BecomeOwnerRequestUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<BecomeOwnerRequestTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BecomeOwnerRequestTable>? orderBy,
    _i1.OrderByListBuilder<BecomeOwnerRequestTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<BecomeOwnerRequest>(
      columnValues: columnValues(BecomeOwnerRequest.t.updateTable),
      where: where(BecomeOwnerRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BecomeOwnerRequest.t),
      orderByList: orderByList?.call(BecomeOwnerRequest.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [BecomeOwnerRequest]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BecomeOwnerRequest>> delete(
    _i1.Session session,
    List<BecomeOwnerRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BecomeOwnerRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BecomeOwnerRequest].
  Future<BecomeOwnerRequest> deleteRow(
    _i1.Session session,
    BecomeOwnerRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BecomeOwnerRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BecomeOwnerRequest>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BecomeOwnerRequestTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BecomeOwnerRequest>(
      where: where(BecomeOwnerRequest.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BecomeOwnerRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BecomeOwnerRequest>(
      where: where?.call(BecomeOwnerRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class BecomeOwnerRequestAttachRowRepository {
  const BecomeOwnerRequestAttachRowRepository._();

  /// Creates a relation between the given [BecomeOwnerRequest] and [User]
  /// by setting the [BecomeOwnerRequest]'s foreign key `userId` to refer to the [User].
  Future<void> user(
    _i1.Session session,
    BecomeOwnerRequest becomeOwnerRequest,
    _i2.User user, {
    _i1.Transaction? transaction,
  }) async {
    if (becomeOwnerRequest.id == null) {
      throw ArgumentError.notNull('becomeOwnerRequest.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $becomeOwnerRequest = becomeOwnerRequest.copyWith(userId: user.id);
    await session.db.updateRow<BecomeOwnerRequest>(
      $becomeOwnerRequest,
      columns: [BecomeOwnerRequest.t.userId],
      transaction: transaction,
    );
  }
}
