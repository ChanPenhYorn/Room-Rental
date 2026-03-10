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
import 'booking.dart' as _i2;
import 'contract_status.dart' as _i3;
import 'bill.dart' as _i4;
import 'package:dwellly_server/src/generated/protocol.dart' as _i5;

abstract class Contract
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Contract._({
    this.id,
    required this.bookingId,
    this.booking,
    this.signedAt,
    required this.contractText,
    required this.status,
    this.bills,
  });

  factory Contract({
    int? id,
    required int bookingId,
    _i2.Booking? booking,
    DateTime? signedAt,
    required String contractText,
    required _i3.ContractStatus status,
    List<_i4.Bill>? bills,
  }) = _ContractImpl;

  factory Contract.fromJson(Map<String, dynamic> jsonSerialization) {
    return Contract(
      id: jsonSerialization['id'] as int?,
      bookingId: jsonSerialization['bookingId'] as int,
      booking: jsonSerialization['booking'] == null
          ? null
          : _i5.Protocol().deserialize<_i2.Booking>(
              jsonSerialization['booking'],
            ),
      signedAt: jsonSerialization['signedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['signedAt']),
      contractText: jsonSerialization['contractText'] as String,
      status: _i3.ContractStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      bills: jsonSerialization['bills'] == null
          ? null
          : _i5.Protocol().deserialize<List<_i4.Bill>>(
              jsonSerialization['bills'],
            ),
    );
  }

  static final t = ContractTable();

  static const db = ContractRepository._();

  @override
  int? id;

  int bookingId;

  _i2.Booking? booking;

  DateTime? signedAt;

  String contractText;

  _i3.ContractStatus status;

  List<_i4.Bill>? bills;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Contract]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Contract copyWith({
    int? id,
    int? bookingId,
    _i2.Booking? booking,
    DateTime? signedAt,
    String? contractText,
    _i3.ContractStatus? status,
    List<_i4.Bill>? bills,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Contract',
      if (id != null) 'id': id,
      'bookingId': bookingId,
      if (booking != null) 'booking': booking?.toJson(),
      if (signedAt != null) 'signedAt': signedAt?.toJson(),
      'contractText': contractText,
      'status': status.toJson(),
      if (bills != null) 'bills': bills?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Contract',
      if (id != null) 'id': id,
      'bookingId': bookingId,
      if (booking != null) 'booking': booking?.toJsonForProtocol(),
      if (signedAt != null) 'signedAt': signedAt?.toJson(),
      'contractText': contractText,
      'status': status.toJson(),
      if (bills != null)
        'bills': bills?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static ContractInclude include({
    _i2.BookingInclude? booking,
    _i4.BillIncludeList? bills,
  }) {
    return ContractInclude._(
      booking: booking,
      bills: bills,
    );
  }

  static ContractIncludeList includeList({
    _i1.WhereExpressionBuilder<ContractTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ContractTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ContractTable>? orderByList,
    ContractInclude? include,
  }) {
    return ContractIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Contract.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Contract.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ContractImpl extends Contract {
  _ContractImpl({
    int? id,
    required int bookingId,
    _i2.Booking? booking,
    DateTime? signedAt,
    required String contractText,
    required _i3.ContractStatus status,
    List<_i4.Bill>? bills,
  }) : super._(
         id: id,
         bookingId: bookingId,
         booking: booking,
         signedAt: signedAt,
         contractText: contractText,
         status: status,
         bills: bills,
       );

  /// Returns a shallow copy of this [Contract]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Contract copyWith({
    Object? id = _Undefined,
    int? bookingId,
    Object? booking = _Undefined,
    Object? signedAt = _Undefined,
    String? contractText,
    _i3.ContractStatus? status,
    Object? bills = _Undefined,
  }) {
    return Contract(
      id: id is int? ? id : this.id,
      bookingId: bookingId ?? this.bookingId,
      booking: booking is _i2.Booking? ? booking : this.booking?.copyWith(),
      signedAt: signedAt is DateTime? ? signedAt : this.signedAt,
      contractText: contractText ?? this.contractText,
      status: status ?? this.status,
      bills: bills is List<_i4.Bill>?
          ? bills
          : this.bills?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class ContractUpdateTable extends _i1.UpdateTable<ContractTable> {
  ContractUpdateTable(super.table);

  _i1.ColumnValue<int, int> bookingId(int value) => _i1.ColumnValue(
    table.bookingId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> signedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.signedAt,
        value,
      );

  _i1.ColumnValue<String, String> contractText(String value) => _i1.ColumnValue(
    table.contractText,
    value,
  );

  _i1.ColumnValue<_i3.ContractStatus, _i3.ContractStatus> status(
    _i3.ContractStatus value,
  ) => _i1.ColumnValue(
    table.status,
    value,
  );
}

class ContractTable extends _i1.Table<int?> {
  ContractTable({super.tableRelation}) : super(tableName: 'contract') {
    updateTable = ContractUpdateTable(this);
    bookingId = _i1.ColumnInt(
      'bookingId',
      this,
    );
    signedAt = _i1.ColumnDateTime(
      'signedAt',
      this,
    );
    contractText = _i1.ColumnString(
      'contractText',
      this,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
    );
  }

  late final ContractUpdateTable updateTable;

  late final _i1.ColumnInt bookingId;

  _i2.BookingTable? _booking;

  late final _i1.ColumnDateTime signedAt;

  late final _i1.ColumnString contractText;

  late final _i1.ColumnEnum<_i3.ContractStatus> status;

  _i4.BillTable? ___bills;

  _i1.ManyRelation<_i4.BillTable>? _bills;

  _i2.BookingTable get booking {
    if (_booking != null) return _booking!;
    _booking = _i1.createRelationTable(
      relationFieldName: 'booking',
      field: Contract.t.bookingId,
      foreignField: _i2.Booking.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.BookingTable(tableRelation: foreignTableRelation),
    );
    return _booking!;
  }

  _i4.BillTable get __bills {
    if (___bills != null) return ___bills!;
    ___bills = _i1.createRelationTable(
      relationFieldName: '__bills',
      field: Contract.t.id,
      foreignField: _i4.Bill.t.contractId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.BillTable(tableRelation: foreignTableRelation),
    );
    return ___bills!;
  }

  _i1.ManyRelation<_i4.BillTable> get bills {
    if (_bills != null) return _bills!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'bills',
      field: Contract.t.id,
      foreignField: _i4.Bill.t.contractId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.BillTable(tableRelation: foreignTableRelation),
    );
    _bills = _i1.ManyRelation<_i4.BillTable>(
      tableWithRelations: relationTable,
      table: _i4.BillTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _bills!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    bookingId,
    signedAt,
    contractText,
    status,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'booking') {
      return booking;
    }
    if (relationField == 'bills') {
      return __bills;
    }
    return null;
  }
}

class ContractInclude extends _i1.IncludeObject {
  ContractInclude._({
    _i2.BookingInclude? booking,
    _i4.BillIncludeList? bills,
  }) {
    _booking = booking;
    _bills = bills;
  }

  _i2.BookingInclude? _booking;

  _i4.BillIncludeList? _bills;

  @override
  Map<String, _i1.Include?> get includes => {
    'booking': _booking,
    'bills': _bills,
  };

  @override
  _i1.Table<int?> get table => Contract.t;
}

class ContractIncludeList extends _i1.IncludeList {
  ContractIncludeList._({
    _i1.WhereExpressionBuilder<ContractTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Contract.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Contract.t;
}

class ContractRepository {
  const ContractRepository._();

  final attach = const ContractAttachRepository._();

  final attachRow = const ContractAttachRowRepository._();

  /// Returns a list of [Contract]s matching the given query parameters.
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
  Future<List<Contract>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ContractTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ContractTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ContractTable>? orderByList,
    _i1.Transaction? transaction,
    ContractInclude? include,
  }) async {
    return session.db.find<Contract>(
      where: where?.call(Contract.t),
      orderBy: orderBy?.call(Contract.t),
      orderByList: orderByList?.call(Contract.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Contract] matching the given query parameters.
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
  Future<Contract?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ContractTable>? where,
    int? offset,
    _i1.OrderByBuilder<ContractTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ContractTable>? orderByList,
    _i1.Transaction? transaction,
    ContractInclude? include,
  }) async {
    return session.db.findFirstRow<Contract>(
      where: where?.call(Contract.t),
      orderBy: orderBy?.call(Contract.t),
      orderByList: orderByList?.call(Contract.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Contract] by its [id] or null if no such row exists.
  Future<Contract?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ContractInclude? include,
  }) async {
    return session.db.findById<Contract>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Contract]s in the list and returns the inserted rows.
  ///
  /// The returned [Contract]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Contract>> insert(
    _i1.Session session,
    List<Contract> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Contract>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Contract] and returns the inserted row.
  ///
  /// The returned [Contract] will have its `id` field set.
  Future<Contract> insertRow(
    _i1.Session session,
    Contract row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Contract>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Contract]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Contract>> update(
    _i1.Session session,
    List<Contract> rows, {
    _i1.ColumnSelections<ContractTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Contract>(
      rows,
      columns: columns?.call(Contract.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Contract]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Contract> updateRow(
    _i1.Session session,
    Contract row, {
    _i1.ColumnSelections<ContractTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Contract>(
      row,
      columns: columns?.call(Contract.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Contract] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Contract?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ContractUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Contract>(
      id,
      columnValues: columnValues(Contract.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Contract]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Contract>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ContractUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ContractTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ContractTable>? orderBy,
    _i1.OrderByListBuilder<ContractTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Contract>(
      columnValues: columnValues(Contract.t.updateTable),
      where: where(Contract.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Contract.t),
      orderByList: orderByList?.call(Contract.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Contract]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Contract>> delete(
    _i1.Session session,
    List<Contract> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Contract>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Contract].
  Future<Contract> deleteRow(
    _i1.Session session,
    Contract row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Contract>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Contract>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ContractTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Contract>(
      where: where(Contract.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ContractTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Contract>(
      where: where?.call(Contract.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ContractAttachRepository {
  const ContractAttachRepository._();

  /// Creates a relation between this [Contract] and the given [Bill]s
  /// by setting each [Bill]'s foreign key `contractId` to refer to this [Contract].
  Future<void> bills(
    _i1.Session session,
    Contract contract,
    List<_i4.Bill> bill, {
    _i1.Transaction? transaction,
  }) async {
    if (bill.any((e) => e.id == null)) {
      throw ArgumentError.notNull('bill.id');
    }
    if (contract.id == null) {
      throw ArgumentError.notNull('contract.id');
    }

    var $bill = bill.map((e) => e.copyWith(contractId: contract.id)).toList();
    await session.db.update<_i4.Bill>(
      $bill,
      columns: [_i4.Bill.t.contractId],
      transaction: transaction,
    );
  }
}

class ContractAttachRowRepository {
  const ContractAttachRowRepository._();

  /// Creates a relation between the given [Contract] and [Booking]
  /// by setting the [Contract]'s foreign key `bookingId` to refer to the [Booking].
  Future<void> booking(
    _i1.Session session,
    Contract contract,
    _i2.Booking booking, {
    _i1.Transaction? transaction,
  }) async {
    if (contract.id == null) {
      throw ArgumentError.notNull('contract.id');
    }
    if (booking.id == null) {
      throw ArgumentError.notNull('booking.id');
    }

    var $contract = contract.copyWith(bookingId: booking.id);
    await session.db.updateRow<Contract>(
      $contract,
      columns: [Contract.t.bookingId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Contract] and the given [Bill]
  /// by setting the [Bill]'s foreign key `contractId` to refer to this [Contract].
  Future<void> bills(
    _i1.Session session,
    Contract contract,
    _i4.Bill bill, {
    _i1.Transaction? transaction,
  }) async {
    if (bill.id == null) {
      throw ArgumentError.notNull('bill.id');
    }
    if (contract.id == null) {
      throw ArgumentError.notNull('contract.id');
    }

    var $bill = bill.copyWith(contractId: contract.id);
    await session.db.updateRow<_i4.Bill>(
      $bill,
      columns: [_i4.Bill.t.contractId],
      transaction: transaction,
    );
  }
}
