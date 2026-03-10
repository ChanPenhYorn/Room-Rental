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
import 'facility.dart' as _i3;
import 'package:dwellly_server/src/generated/protocol.dart' as _i4;

abstract class RoomFacility
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RoomFacility._({
    this.id,
    required this.roomId,
    this.room,
    required this.facilityId,
    this.facility,
  });

  factory RoomFacility({
    int? id,
    required int roomId,
    _i2.Room? room,
    required int facilityId,
    _i3.Facility? facility,
  }) = _RoomFacilityImpl;

  factory RoomFacility.fromJson(Map<String, dynamic> jsonSerialization) {
    return RoomFacility(
      id: jsonSerialization['id'] as int?,
      roomId: jsonSerialization['roomId'] as int,
      room: jsonSerialization['room'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.Room>(jsonSerialization['room']),
      facilityId: jsonSerialization['facilityId'] as int,
      facility: jsonSerialization['facility'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.Facility>(
              jsonSerialization['facility'],
            ),
    );
  }

  static final t = RoomFacilityTable();

  static const db = RoomFacilityRepository._();

  @override
  int? id;

  int roomId;

  _i2.Room? room;

  int facilityId;

  _i3.Facility? facility;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RoomFacility]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RoomFacility copyWith({
    int? id,
    int? roomId,
    _i2.Room? room,
    int? facilityId,
    _i3.Facility? facility,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RoomFacility',
      if (id != null) 'id': id,
      'roomId': roomId,
      if (room != null) 'room': room?.toJson(),
      'facilityId': facilityId,
      if (facility != null) 'facility': facility?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RoomFacility',
      if (id != null) 'id': id,
      'roomId': roomId,
      if (room != null) 'room': room?.toJsonForProtocol(),
      'facilityId': facilityId,
      if (facility != null) 'facility': facility?.toJsonForProtocol(),
    };
  }

  static RoomFacilityInclude include({
    _i2.RoomInclude? room,
    _i3.FacilityInclude? facility,
  }) {
    return RoomFacilityInclude._(
      room: room,
      facility: facility,
    );
  }

  static RoomFacilityIncludeList includeList({
    _i1.WhereExpressionBuilder<RoomFacilityTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RoomFacilityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RoomFacilityTable>? orderByList,
    RoomFacilityInclude? include,
  }) {
    return RoomFacilityIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RoomFacility.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RoomFacility.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RoomFacilityImpl extends RoomFacility {
  _RoomFacilityImpl({
    int? id,
    required int roomId,
    _i2.Room? room,
    required int facilityId,
    _i3.Facility? facility,
  }) : super._(
         id: id,
         roomId: roomId,
         room: room,
         facilityId: facilityId,
         facility: facility,
       );

  /// Returns a shallow copy of this [RoomFacility]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RoomFacility copyWith({
    Object? id = _Undefined,
    int? roomId,
    Object? room = _Undefined,
    int? facilityId,
    Object? facility = _Undefined,
  }) {
    return RoomFacility(
      id: id is int? ? id : this.id,
      roomId: roomId ?? this.roomId,
      room: room is _i2.Room? ? room : this.room?.copyWith(),
      facilityId: facilityId ?? this.facilityId,
      facility: facility is _i3.Facility?
          ? facility
          : this.facility?.copyWith(),
    );
  }
}

class RoomFacilityUpdateTable extends _i1.UpdateTable<RoomFacilityTable> {
  RoomFacilityUpdateTable(super.table);

  _i1.ColumnValue<int, int> roomId(int value) => _i1.ColumnValue(
    table.roomId,
    value,
  );

  _i1.ColumnValue<int, int> facilityId(int value) => _i1.ColumnValue(
    table.facilityId,
    value,
  );
}

class RoomFacilityTable extends _i1.Table<int?> {
  RoomFacilityTable({super.tableRelation}) : super(tableName: 'room_facility') {
    updateTable = RoomFacilityUpdateTable(this);
    roomId = _i1.ColumnInt(
      'roomId',
      this,
    );
    facilityId = _i1.ColumnInt(
      'facilityId',
      this,
    );
  }

  late final RoomFacilityUpdateTable updateTable;

  late final _i1.ColumnInt roomId;

  _i2.RoomTable? _room;

  late final _i1.ColumnInt facilityId;

  _i3.FacilityTable? _facility;

  _i2.RoomTable get room {
    if (_room != null) return _room!;
    _room = _i1.createRelationTable(
      relationFieldName: 'room',
      field: RoomFacility.t.roomId,
      foreignField: _i2.Room.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.RoomTable(tableRelation: foreignTableRelation),
    );
    return _room!;
  }

  _i3.FacilityTable get facility {
    if (_facility != null) return _facility!;
    _facility = _i1.createRelationTable(
      relationFieldName: 'facility',
      field: RoomFacility.t.facilityId,
      foreignField: _i3.Facility.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.FacilityTable(tableRelation: foreignTableRelation),
    );
    return _facility!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    roomId,
    facilityId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'room') {
      return room;
    }
    if (relationField == 'facility') {
      return facility;
    }
    return null;
  }
}

class RoomFacilityInclude extends _i1.IncludeObject {
  RoomFacilityInclude._({
    _i2.RoomInclude? room,
    _i3.FacilityInclude? facility,
  }) {
    _room = room;
    _facility = facility;
  }

  _i2.RoomInclude? _room;

  _i3.FacilityInclude? _facility;

  @override
  Map<String, _i1.Include?> get includes => {
    'room': _room,
    'facility': _facility,
  };

  @override
  _i1.Table<int?> get table => RoomFacility.t;
}

class RoomFacilityIncludeList extends _i1.IncludeList {
  RoomFacilityIncludeList._({
    _i1.WhereExpressionBuilder<RoomFacilityTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RoomFacility.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RoomFacility.t;
}

class RoomFacilityRepository {
  const RoomFacilityRepository._();

  final attachRow = const RoomFacilityAttachRowRepository._();

  /// Returns a list of [RoomFacility]s matching the given query parameters.
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
  Future<List<RoomFacility>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RoomFacilityTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RoomFacilityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RoomFacilityTable>? orderByList,
    _i1.Transaction? transaction,
    RoomFacilityInclude? include,
  }) async {
    return session.db.find<RoomFacility>(
      where: where?.call(RoomFacility.t),
      orderBy: orderBy?.call(RoomFacility.t),
      orderByList: orderByList?.call(RoomFacility.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [RoomFacility] matching the given query parameters.
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
  Future<RoomFacility?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RoomFacilityTable>? where,
    int? offset,
    _i1.OrderByBuilder<RoomFacilityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RoomFacilityTable>? orderByList,
    _i1.Transaction? transaction,
    RoomFacilityInclude? include,
  }) async {
    return session.db.findFirstRow<RoomFacility>(
      where: where?.call(RoomFacility.t),
      orderBy: orderBy?.call(RoomFacility.t),
      orderByList: orderByList?.call(RoomFacility.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [RoomFacility] by its [id] or null if no such row exists.
  Future<RoomFacility?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    RoomFacilityInclude? include,
  }) async {
    return session.db.findById<RoomFacility>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [RoomFacility]s in the list and returns the inserted rows.
  ///
  /// The returned [RoomFacility]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<RoomFacility>> insert(
    _i1.Session session,
    List<RoomFacility> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<RoomFacility>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [RoomFacility] and returns the inserted row.
  ///
  /// The returned [RoomFacility] will have its `id` field set.
  Future<RoomFacility> insertRow(
    _i1.Session session,
    RoomFacility row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RoomFacility>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RoomFacility]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RoomFacility>> update(
    _i1.Session session,
    List<RoomFacility> rows, {
    _i1.ColumnSelections<RoomFacilityTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RoomFacility>(
      rows,
      columns: columns?.call(RoomFacility.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RoomFacility]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RoomFacility> updateRow(
    _i1.Session session,
    RoomFacility row, {
    _i1.ColumnSelections<RoomFacilityTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RoomFacility>(
      row,
      columns: columns?.call(RoomFacility.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RoomFacility] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RoomFacility?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<RoomFacilityUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RoomFacility>(
      id,
      columnValues: columnValues(RoomFacility.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RoomFacility]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RoomFacility>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<RoomFacilityUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RoomFacilityTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RoomFacilityTable>? orderBy,
    _i1.OrderByListBuilder<RoomFacilityTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RoomFacility>(
      columnValues: columnValues(RoomFacility.t.updateTable),
      where: where(RoomFacility.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RoomFacility.t),
      orderByList: orderByList?.call(RoomFacility.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RoomFacility]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RoomFacility>> delete(
    _i1.Session session,
    List<RoomFacility> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RoomFacility>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RoomFacility].
  Future<RoomFacility> deleteRow(
    _i1.Session session,
    RoomFacility row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RoomFacility>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RoomFacility>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RoomFacilityTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RoomFacility>(
      where: where(RoomFacility.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RoomFacilityTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RoomFacility>(
      where: where?.call(RoomFacility.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class RoomFacilityAttachRowRepository {
  const RoomFacilityAttachRowRepository._();

  /// Creates a relation between the given [RoomFacility] and [Room]
  /// by setting the [RoomFacility]'s foreign key `roomId` to refer to the [Room].
  Future<void> room(
    _i1.Session session,
    RoomFacility roomFacility,
    _i2.Room room, {
    _i1.Transaction? transaction,
  }) async {
    if (roomFacility.id == null) {
      throw ArgumentError.notNull('roomFacility.id');
    }
    if (room.id == null) {
      throw ArgumentError.notNull('room.id');
    }

    var $roomFacility = roomFacility.copyWith(roomId: room.id);
    await session.db.updateRow<RoomFacility>(
      $roomFacility,
      columns: [RoomFacility.t.roomId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [RoomFacility] and [Facility]
  /// by setting the [RoomFacility]'s foreign key `facilityId` to refer to the [Facility].
  Future<void> facility(
    _i1.Session session,
    RoomFacility roomFacility,
    _i3.Facility facility, {
    _i1.Transaction? transaction,
  }) async {
    if (roomFacility.id == null) {
      throw ArgumentError.notNull('roomFacility.id');
    }
    if (facility.id == null) {
      throw ArgumentError.notNull('facility.id');
    }

    var $roomFacility = roomFacility.copyWith(facilityId: facility.id);
    await session.db.updateRow<RoomFacility>(
      $roomFacility,
      columns: [RoomFacility.t.facilityId],
      transaction: transaction,
    );
  }
}
