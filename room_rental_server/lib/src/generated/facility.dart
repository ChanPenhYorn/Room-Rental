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
import 'room_facility.dart' as _i2;
import 'package:room_rental_server/src/generated/protocol.dart' as _i3;

abstract class Facility
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Facility._({
    this.id,
    required this.name,
    required this.icon,
    this.rooms,
  });

  factory Facility({
    int? id,
    required String name,
    required String icon,
    List<_i2.RoomFacility>? rooms,
  }) = _FacilityImpl;

  factory Facility.fromJson(Map<String, dynamic> jsonSerialization) {
    return Facility(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      icon: jsonSerialization['icon'] as String,
      rooms: jsonSerialization['rooms'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.RoomFacility>>(
              jsonSerialization['rooms'],
            ),
    );
  }

  static final t = FacilityTable();

  static const db = FacilityRepository._();

  @override
  int? id;

  String name;

  String icon;

  List<_i2.RoomFacility>? rooms;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Facility]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Facility copyWith({
    int? id,
    String? name,
    String? icon,
    List<_i2.RoomFacility>? rooms,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Facility',
      if (id != null) 'id': id,
      'name': name,
      'icon': icon,
      if (rooms != null) 'rooms': rooms?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Facility',
      if (id != null) 'id': id,
      'name': name,
      'icon': icon,
      if (rooms != null)
        'rooms': rooms?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static FacilityInclude include({_i2.RoomFacilityIncludeList? rooms}) {
    return FacilityInclude._(rooms: rooms);
  }

  static FacilityIncludeList includeList({
    _i1.WhereExpressionBuilder<FacilityTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FacilityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FacilityTable>? orderByList,
    FacilityInclude? include,
  }) {
    return FacilityIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Facility.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Facility.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FacilityImpl extends Facility {
  _FacilityImpl({
    int? id,
    required String name,
    required String icon,
    List<_i2.RoomFacility>? rooms,
  }) : super._(
         id: id,
         name: name,
         icon: icon,
         rooms: rooms,
       );

  /// Returns a shallow copy of this [Facility]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Facility copyWith({
    Object? id = _Undefined,
    String? name,
    String? icon,
    Object? rooms = _Undefined,
  }) {
    return Facility(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      rooms: rooms is List<_i2.RoomFacility>?
          ? rooms
          : this.rooms?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class FacilityUpdateTable extends _i1.UpdateTable<FacilityTable> {
  FacilityUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> icon(String value) => _i1.ColumnValue(
    table.icon,
    value,
  );
}

class FacilityTable extends _i1.Table<int?> {
  FacilityTable({super.tableRelation}) : super(tableName: 'facility') {
    updateTable = FacilityUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    icon = _i1.ColumnString(
      'icon',
      this,
    );
  }

  late final FacilityUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString icon;

  _i2.RoomFacilityTable? ___rooms;

  _i1.ManyRelation<_i2.RoomFacilityTable>? _rooms;

  _i2.RoomFacilityTable get __rooms {
    if (___rooms != null) return ___rooms!;
    ___rooms = _i1.createRelationTable(
      relationFieldName: '__rooms',
      field: Facility.t.id,
      foreignField: _i2.RoomFacility.t.facilityId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.RoomFacilityTable(tableRelation: foreignTableRelation),
    );
    return ___rooms!;
  }

  _i1.ManyRelation<_i2.RoomFacilityTable> get rooms {
    if (_rooms != null) return _rooms!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'rooms',
      field: Facility.t.id,
      foreignField: _i2.RoomFacility.t.facilityId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.RoomFacilityTable(tableRelation: foreignTableRelation),
    );
    _rooms = _i1.ManyRelation<_i2.RoomFacilityTable>(
      tableWithRelations: relationTable,
      table: _i2.RoomFacilityTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _rooms!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    icon,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'rooms') {
      return __rooms;
    }
    return null;
  }
}

class FacilityInclude extends _i1.IncludeObject {
  FacilityInclude._({_i2.RoomFacilityIncludeList? rooms}) {
    _rooms = rooms;
  }

  _i2.RoomFacilityIncludeList? _rooms;

  @override
  Map<String, _i1.Include?> get includes => {'rooms': _rooms};

  @override
  _i1.Table<int?> get table => Facility.t;
}

class FacilityIncludeList extends _i1.IncludeList {
  FacilityIncludeList._({
    _i1.WhereExpressionBuilder<FacilityTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Facility.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Facility.t;
}

class FacilityRepository {
  const FacilityRepository._();

  final attach = const FacilityAttachRepository._();

  final attachRow = const FacilityAttachRowRepository._();

  final detach = const FacilityDetachRepository._();

  final detachRow = const FacilityDetachRowRepository._();

  /// Returns a list of [Facility]s matching the given query parameters.
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
  Future<List<Facility>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FacilityTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FacilityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FacilityTable>? orderByList,
    _i1.Transaction? transaction,
    FacilityInclude? include,
  }) async {
    return session.db.find<Facility>(
      where: where?.call(Facility.t),
      orderBy: orderBy?.call(Facility.t),
      orderByList: orderByList?.call(Facility.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Facility] matching the given query parameters.
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
  Future<Facility?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FacilityTable>? where,
    int? offset,
    _i1.OrderByBuilder<FacilityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FacilityTable>? orderByList,
    _i1.Transaction? transaction,
    FacilityInclude? include,
  }) async {
    return session.db.findFirstRow<Facility>(
      where: where?.call(Facility.t),
      orderBy: orderBy?.call(Facility.t),
      orderByList: orderByList?.call(Facility.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Facility] by its [id] or null if no such row exists.
  Future<Facility?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    FacilityInclude? include,
  }) async {
    return session.db.findById<Facility>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Facility]s in the list and returns the inserted rows.
  ///
  /// The returned [Facility]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Facility>> insert(
    _i1.Session session,
    List<Facility> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Facility>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Facility] and returns the inserted row.
  ///
  /// The returned [Facility] will have its `id` field set.
  Future<Facility> insertRow(
    _i1.Session session,
    Facility row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Facility>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Facility]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Facility>> update(
    _i1.Session session,
    List<Facility> rows, {
    _i1.ColumnSelections<FacilityTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Facility>(
      rows,
      columns: columns?.call(Facility.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Facility]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Facility> updateRow(
    _i1.Session session,
    Facility row, {
    _i1.ColumnSelections<FacilityTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Facility>(
      row,
      columns: columns?.call(Facility.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Facility] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Facility?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<FacilityUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Facility>(
      id,
      columnValues: columnValues(Facility.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Facility]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Facility>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<FacilityUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<FacilityTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FacilityTable>? orderBy,
    _i1.OrderByListBuilder<FacilityTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Facility>(
      columnValues: columnValues(Facility.t.updateTable),
      where: where(Facility.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Facility.t),
      orderByList: orderByList?.call(Facility.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Facility]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Facility>> delete(
    _i1.Session session,
    List<Facility> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Facility>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Facility].
  Future<Facility> deleteRow(
    _i1.Session session,
    Facility row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Facility>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Facility>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<FacilityTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Facility>(
      where: where(Facility.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FacilityTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Facility>(
      where: where?.call(Facility.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class FacilityAttachRepository {
  const FacilityAttachRepository._();

  /// Creates a relation between this [Facility] and the given [RoomFacility]s
  /// by setting each [RoomFacility]'s foreign key `facilityId` to refer to this [Facility].
  Future<void> rooms(
    _i1.Session session,
    Facility facility,
    List<_i2.RoomFacility> roomFacility, {
    _i1.Transaction? transaction,
  }) async {
    if (roomFacility.any((e) => e.id == null)) {
      throw ArgumentError.notNull('roomFacility.id');
    }
    if (facility.id == null) {
      throw ArgumentError.notNull('facility.id');
    }

    var $roomFacility = roomFacility
        .map((e) => e.copyWith(facilityId: facility.id))
        .toList();
    await session.db.update<_i2.RoomFacility>(
      $roomFacility,
      columns: [_i2.RoomFacility.t.facilityId],
      transaction: transaction,
    );
  }
}

class FacilityAttachRowRepository {
  const FacilityAttachRowRepository._();

  /// Creates a relation between this [Facility] and the given [RoomFacility]
  /// by setting the [RoomFacility]'s foreign key `facilityId` to refer to this [Facility].
  Future<void> rooms(
    _i1.Session session,
    Facility facility,
    _i2.RoomFacility roomFacility, {
    _i1.Transaction? transaction,
  }) async {
    if (roomFacility.id == null) {
      throw ArgumentError.notNull('roomFacility.id');
    }
    if (facility.id == null) {
      throw ArgumentError.notNull('facility.id');
    }

    var $roomFacility = roomFacility.copyWith(facilityId: facility.id);
    await session.db.updateRow<_i2.RoomFacility>(
      $roomFacility,
      columns: [_i2.RoomFacility.t.facilityId],
      transaction: transaction,
    );
  }
}

class FacilityDetachRepository {
  const FacilityDetachRepository._();

  /// Detaches the relation between this [Facility] and the given [RoomFacility]
  /// by setting the [RoomFacility]'s foreign key `facilityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> rooms(
    _i1.Session session,
    List<_i2.RoomFacility> roomFacility, {
    _i1.Transaction? transaction,
  }) async {
    if (roomFacility.any((e) => e.id == null)) {
      throw ArgumentError.notNull('roomFacility.id');
    }

    var $roomFacility = roomFacility
        .map((e) => e.copyWith(facilityId: null))
        .toList();
    await session.db.update<_i2.RoomFacility>(
      $roomFacility,
      columns: [_i2.RoomFacility.t.facilityId],
      transaction: transaction,
    );
  }
}

class FacilityDetachRowRepository {
  const FacilityDetachRowRepository._();

  /// Detaches the relation between this [Facility] and the given [RoomFacility]
  /// by setting the [RoomFacility]'s foreign key `facilityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> rooms(
    _i1.Session session,
    _i2.RoomFacility roomFacility, {
    _i1.Transaction? transaction,
  }) async {
    if (roomFacility.id == null) {
      throw ArgumentError.notNull('roomFacility.id');
    }

    var $roomFacility = roomFacility.copyWith(facilityId: null);
    await session.db.updateRow<_i2.RoomFacility>(
      $roomFacility,
      columns: [_i2.RoomFacility.t.facilityId],
      transaction: transaction,
    );
  }
}
