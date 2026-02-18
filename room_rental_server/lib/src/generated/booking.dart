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
import 'booking_status.dart' as _i4;
import 'contract.dart' as _i5;
import 'package:room_rental_server/src/generated/protocol.dart' as _i6;

abstract class Booking
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Booking._({
    this.id,
    required this.roomId,
    this.room,
    required this.userId,
    this.user,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.status,
    this.transactionId,
    required this.createdAt,
    this.contract,
  });

  factory Booking({
    int? id,
    required int roomId,
    _i2.Room? room,
    required int userId,
    _i3.User? user,
    required DateTime checkIn,
    required DateTime checkOut,
    required double totalPrice,
    required _i4.BookingStatus status,
    String? transactionId,
    required DateTime createdAt,
    _i5.Contract? contract,
  }) = _BookingImpl;

  factory Booking.fromJson(Map<String, dynamic> jsonSerialization) {
    return Booking(
      id: jsonSerialization['id'] as int?,
      roomId: jsonSerialization['roomId'] as int,
      room: jsonSerialization['room'] == null
          ? null
          : _i6.Protocol().deserialize<_i2.Room>(jsonSerialization['room']),
      userId: jsonSerialization['userId'] as int,
      user: jsonSerialization['user'] == null
          ? null
          : _i6.Protocol().deserialize<_i3.User>(jsonSerialization['user']),
      checkIn: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['checkIn']),
      checkOut: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['checkOut'],
      ),
      totalPrice: (jsonSerialization['totalPrice'] as num).toDouble(),
      status: _i4.BookingStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      transactionId: jsonSerialization['transactionId'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      contract: jsonSerialization['contract'] == null
          ? null
          : _i6.Protocol().deserialize<_i5.Contract>(
              jsonSerialization['contract'],
            ),
    );
  }

  static final t = BookingTable();

  static const db = BookingRepository._();

  @override
  int? id;

  int roomId;

  _i2.Room? room;

  int userId;

  _i3.User? user;

  DateTime checkIn;

  DateTime checkOut;

  double totalPrice;

  _i4.BookingStatus status;

  String? transactionId;

  DateTime createdAt;

  _i5.Contract? contract;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Booking]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Booking copyWith({
    int? id,
    int? roomId,
    _i2.Room? room,
    int? userId,
    _i3.User? user,
    DateTime? checkIn,
    DateTime? checkOut,
    double? totalPrice,
    _i4.BookingStatus? status,
    String? transactionId,
    DateTime? createdAt,
    _i5.Contract? contract,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Booking',
      if (id != null) 'id': id,
      'roomId': roomId,
      if (room != null) 'room': room?.toJson(),
      'userId': userId,
      if (user != null) 'user': user?.toJson(),
      'checkIn': checkIn.toJson(),
      'checkOut': checkOut.toJson(),
      'totalPrice': totalPrice,
      'status': status.toJson(),
      if (transactionId != null) 'transactionId': transactionId,
      'createdAt': createdAt.toJson(),
      if (contract != null) 'contract': contract?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Booking',
      if (id != null) 'id': id,
      'roomId': roomId,
      if (room != null) 'room': room?.toJsonForProtocol(),
      'userId': userId,
      if (user != null) 'user': user?.toJsonForProtocol(),
      'checkIn': checkIn.toJson(),
      'checkOut': checkOut.toJson(),
      'totalPrice': totalPrice,
      'status': status.toJson(),
      if (transactionId != null) 'transactionId': transactionId,
      'createdAt': createdAt.toJson(),
      if (contract != null) 'contract': contract?.toJsonForProtocol(),
    };
  }

  static BookingInclude include({
    _i2.RoomInclude? room,
    _i3.UserInclude? user,
    _i5.ContractInclude? contract,
  }) {
    return BookingInclude._(
      room: room,
      user: user,
      contract: contract,
    );
  }

  static BookingIncludeList includeList({
    _i1.WhereExpressionBuilder<BookingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BookingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BookingTable>? orderByList,
    BookingInclude? include,
  }) {
    return BookingIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Booking.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Booking.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BookingImpl extends Booking {
  _BookingImpl({
    int? id,
    required int roomId,
    _i2.Room? room,
    required int userId,
    _i3.User? user,
    required DateTime checkIn,
    required DateTime checkOut,
    required double totalPrice,
    required _i4.BookingStatus status,
    String? transactionId,
    required DateTime createdAt,
    _i5.Contract? contract,
  }) : super._(
         id: id,
         roomId: roomId,
         room: room,
         userId: userId,
         user: user,
         checkIn: checkIn,
         checkOut: checkOut,
         totalPrice: totalPrice,
         status: status,
         transactionId: transactionId,
         createdAt: createdAt,
         contract: contract,
       );

  /// Returns a shallow copy of this [Booking]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Booking copyWith({
    Object? id = _Undefined,
    int? roomId,
    Object? room = _Undefined,
    int? userId,
    Object? user = _Undefined,
    DateTime? checkIn,
    DateTime? checkOut,
    double? totalPrice,
    _i4.BookingStatus? status,
    Object? transactionId = _Undefined,
    DateTime? createdAt,
    Object? contract = _Undefined,
  }) {
    return Booking(
      id: id is int? ? id : this.id,
      roomId: roomId ?? this.roomId,
      room: room is _i2.Room? ? room : this.room?.copyWith(),
      userId: userId ?? this.userId,
      user: user is _i3.User? ? user : this.user?.copyWith(),
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      transactionId: transactionId is String?
          ? transactionId
          : this.transactionId,
      createdAt: createdAt ?? this.createdAt,
      contract: contract is _i5.Contract?
          ? contract
          : this.contract?.copyWith(),
    );
  }
}

class BookingUpdateTable extends _i1.UpdateTable<BookingTable> {
  BookingUpdateTable(super.table);

  _i1.ColumnValue<int, int> roomId(int value) => _i1.ColumnValue(
    table.roomId,
    value,
  );

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> checkIn(DateTime value) =>
      _i1.ColumnValue(
        table.checkIn,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> checkOut(DateTime value) =>
      _i1.ColumnValue(
        table.checkOut,
        value,
      );

  _i1.ColumnValue<double, double> totalPrice(double value) => _i1.ColumnValue(
    table.totalPrice,
    value,
  );

  _i1.ColumnValue<_i4.BookingStatus, _i4.BookingStatus> status(
    _i4.BookingStatus value,
  ) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> transactionId(String? value) =>
      _i1.ColumnValue(
        table.transactionId,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class BookingTable extends _i1.Table<int?> {
  BookingTable({super.tableRelation}) : super(tableName: 'booking') {
    updateTable = BookingUpdateTable(this);
    roomId = _i1.ColumnInt(
      'roomId',
      this,
    );
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    checkIn = _i1.ColumnDateTime(
      'checkIn',
      this,
    );
    checkOut = _i1.ColumnDateTime(
      'checkOut',
      this,
    );
    totalPrice = _i1.ColumnDouble(
      'totalPrice',
      this,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
    );
    transactionId = _i1.ColumnString(
      'transactionId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final BookingUpdateTable updateTable;

  late final _i1.ColumnInt roomId;

  _i2.RoomTable? _room;

  late final _i1.ColumnInt userId;

  _i3.UserTable? _user;

  late final _i1.ColumnDateTime checkIn;

  late final _i1.ColumnDateTime checkOut;

  late final _i1.ColumnDouble totalPrice;

  late final _i1.ColumnEnum<_i4.BookingStatus> status;

  late final _i1.ColumnString transactionId;

  late final _i1.ColumnDateTime createdAt;

  _i5.ContractTable? _contract;

  _i2.RoomTable get room {
    if (_room != null) return _room!;
    _room = _i1.createRelationTable(
      relationFieldName: 'room',
      field: Booking.t.roomId,
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
      field: Booking.t.userId,
      foreignField: _i3.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.UserTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  _i5.ContractTable get contract {
    if (_contract != null) return _contract!;
    _contract = _i1.createRelationTable(
      relationFieldName: 'contract',
      field: Booking.t.id,
      foreignField: _i5.Contract.t.bookingId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5.ContractTable(tableRelation: foreignTableRelation),
    );
    return _contract!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    roomId,
    userId,
    checkIn,
    checkOut,
    totalPrice,
    status,
    transactionId,
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
    if (relationField == 'contract') {
      return contract;
    }
    return null;
  }
}

class BookingInclude extends _i1.IncludeObject {
  BookingInclude._({
    _i2.RoomInclude? room,
    _i3.UserInclude? user,
    _i5.ContractInclude? contract,
  }) {
    _room = room;
    _user = user;
    _contract = contract;
  }

  _i2.RoomInclude? _room;

  _i3.UserInclude? _user;

  _i5.ContractInclude? _contract;

  @override
  Map<String, _i1.Include?> get includes => {
    'room': _room,
    'user': _user,
    'contract': _contract,
  };

  @override
  _i1.Table<int?> get table => Booking.t;
}

class BookingIncludeList extends _i1.IncludeList {
  BookingIncludeList._({
    _i1.WhereExpressionBuilder<BookingTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Booking.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Booking.t;
}

class BookingRepository {
  const BookingRepository._();

  final attachRow = const BookingAttachRowRepository._();

  final detachRow = const BookingDetachRowRepository._();

  /// Returns a list of [Booking]s matching the given query parameters.
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
  Future<List<Booking>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BookingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BookingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BookingTable>? orderByList,
    _i1.Transaction? transaction,
    BookingInclude? include,
  }) async {
    return session.db.find<Booking>(
      where: where?.call(Booking.t),
      orderBy: orderBy?.call(Booking.t),
      orderByList: orderByList?.call(Booking.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Booking] matching the given query parameters.
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
  Future<Booking?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BookingTable>? where,
    int? offset,
    _i1.OrderByBuilder<BookingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BookingTable>? orderByList,
    _i1.Transaction? transaction,
    BookingInclude? include,
  }) async {
    return session.db.findFirstRow<Booking>(
      where: where?.call(Booking.t),
      orderBy: orderBy?.call(Booking.t),
      orderByList: orderByList?.call(Booking.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Booking] by its [id] or null if no such row exists.
  Future<Booking?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    BookingInclude? include,
  }) async {
    return session.db.findById<Booking>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Booking]s in the list and returns the inserted rows.
  ///
  /// The returned [Booking]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Booking>> insert(
    _i1.Session session,
    List<Booking> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Booking>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Booking] and returns the inserted row.
  ///
  /// The returned [Booking] will have its `id` field set.
  Future<Booking> insertRow(
    _i1.Session session,
    Booking row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Booking>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Booking]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Booking>> update(
    _i1.Session session,
    List<Booking> rows, {
    _i1.ColumnSelections<BookingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Booking>(
      rows,
      columns: columns?.call(Booking.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Booking]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Booking> updateRow(
    _i1.Session session,
    Booking row, {
    _i1.ColumnSelections<BookingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Booking>(
      row,
      columns: columns?.call(Booking.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Booking] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Booking?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<BookingUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Booking>(
      id,
      columnValues: columnValues(Booking.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Booking]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Booking>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<BookingUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<BookingTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BookingTable>? orderBy,
    _i1.OrderByListBuilder<BookingTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Booking>(
      columnValues: columnValues(Booking.t.updateTable),
      where: where(Booking.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Booking.t),
      orderByList: orderByList?.call(Booking.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Booking]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Booking>> delete(
    _i1.Session session,
    List<Booking> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Booking>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Booking].
  Future<Booking> deleteRow(
    _i1.Session session,
    Booking row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Booking>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Booking>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BookingTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Booking>(
      where: where(Booking.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BookingTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Booking>(
      where: where?.call(Booking.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class BookingAttachRowRepository {
  const BookingAttachRowRepository._();

  /// Creates a relation between the given [Booking] and [Room]
  /// by setting the [Booking]'s foreign key `roomId` to refer to the [Room].
  Future<void> room(
    _i1.Session session,
    Booking booking,
    _i2.Room room, {
    _i1.Transaction? transaction,
  }) async {
    if (booking.id == null) {
      throw ArgumentError.notNull('booking.id');
    }
    if (room.id == null) {
      throw ArgumentError.notNull('room.id');
    }

    var $booking = booking.copyWith(roomId: room.id);
    await session.db.updateRow<Booking>(
      $booking,
      columns: [Booking.t.roomId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Booking] and [User]
  /// by setting the [Booking]'s foreign key `userId` to refer to the [User].
  Future<void> user(
    _i1.Session session,
    Booking booking,
    _i3.User user, {
    _i1.Transaction? transaction,
  }) async {
    if (booking.id == null) {
      throw ArgumentError.notNull('booking.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $booking = booking.copyWith(userId: user.id);
    await session.db.updateRow<Booking>(
      $booking,
      columns: [Booking.t.userId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Booking] and [Contract]
  /// by setting the [Booking]'s foreign key `id` to refer to the [Contract].
  Future<void> contract(
    _i1.Session session,
    Booking booking,
    _i5.Contract contract, {
    _i1.Transaction? transaction,
  }) async {
    if (contract.id == null) {
      throw ArgumentError.notNull('contract.id');
    }
    if (booking.id == null) {
      throw ArgumentError.notNull('booking.id');
    }

    var $contract = contract.copyWith(bookingId: booking.id);
    await session.db.updateRow<_i5.Contract>(
      $contract,
      columns: [_i5.Contract.t.bookingId],
      transaction: transaction,
    );
  }
}

class BookingDetachRowRepository {
  const BookingDetachRowRepository._();

  /// Detaches the relation between this [Booking] and the [Contract] set in `contract`
  /// by setting the [Booking]'s foreign key `id` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> contract(
    _i1.Session session,
    Booking booking, {
    _i1.Transaction? transaction,
  }) async {
    var $contract = booking.contract;

    if ($contract == null) {
      throw ArgumentError.notNull('booking.contract');
    }
    if ($contract.id == null) {
      throw ArgumentError.notNull('booking.contract.id');
    }
    if (booking.id == null) {
      throw ArgumentError.notNull('booking.id');
    }

    var $$contract = $contract.copyWith(bookingId: null);
    await session.db.updateRow<_i5.Contract>(
      $$contract,
      columns: [_i5.Contract.t.bookingId],
      transaction: transaction,
    );
  }
}
