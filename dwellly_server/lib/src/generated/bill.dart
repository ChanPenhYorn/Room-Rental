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
import 'contract.dart' as _i2;
import 'bill_status.dart' as _i3;
import 'package:dwellly_server/src/generated/protocol.dart' as _i4;

abstract class Bill implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Bill._({
    this.id,
    required this.contractId,
    this.contract,
    required this.amount,
    required this.dueDate,
    required this.status,
  });

  factory Bill({
    int? id,
    required int contractId,
    _i2.Contract? contract,
    required double amount,
    required DateTime dueDate,
    required _i3.BillStatus status,
  }) = _BillImpl;

  factory Bill.fromJson(Map<String, dynamic> jsonSerialization) {
    return Bill(
      id: jsonSerialization['id'] as int?,
      contractId: jsonSerialization['contractId'] as int,
      contract: jsonSerialization['contract'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.Contract>(
              jsonSerialization['contract'],
            ),
      amount: (jsonSerialization['amount'] as num).toDouble(),
      dueDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dueDate']),
      status: _i3.BillStatus.fromJson((jsonSerialization['status'] as String)),
    );
  }

  static final t = BillTable();

  static const db = BillRepository._();

  @override
  int? id;

  int contractId;

  _i2.Contract? contract;

  double amount;

  DateTime dueDate;

  _i3.BillStatus status;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Bill]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Bill copyWith({
    int? id,
    int? contractId,
    _i2.Contract? contract,
    double? amount,
    DateTime? dueDate,
    _i3.BillStatus? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Bill',
      if (id != null) 'id': id,
      'contractId': contractId,
      if (contract != null) 'contract': contract?.toJson(),
      'amount': amount,
      'dueDate': dueDate.toJson(),
      'status': status.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Bill',
      if (id != null) 'id': id,
      'contractId': contractId,
      if (contract != null) 'contract': contract?.toJsonForProtocol(),
      'amount': amount,
      'dueDate': dueDate.toJson(),
      'status': status.toJson(),
    };
  }

  static BillInclude include({_i2.ContractInclude? contract}) {
    return BillInclude._(contract: contract);
  }

  static BillIncludeList includeList({
    _i1.WhereExpressionBuilder<BillTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BillTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BillTable>? orderByList,
    BillInclude? include,
  }) {
    return BillIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Bill.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Bill.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BillImpl extends Bill {
  _BillImpl({
    int? id,
    required int contractId,
    _i2.Contract? contract,
    required double amount,
    required DateTime dueDate,
    required _i3.BillStatus status,
  }) : super._(
         id: id,
         contractId: contractId,
         contract: contract,
         amount: amount,
         dueDate: dueDate,
         status: status,
       );

  /// Returns a shallow copy of this [Bill]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Bill copyWith({
    Object? id = _Undefined,
    int? contractId,
    Object? contract = _Undefined,
    double? amount,
    DateTime? dueDate,
    _i3.BillStatus? status,
  }) {
    return Bill(
      id: id is int? ? id : this.id,
      contractId: contractId ?? this.contractId,
      contract: contract is _i2.Contract?
          ? contract
          : this.contract?.copyWith(),
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
    );
  }
}

class BillUpdateTable extends _i1.UpdateTable<BillTable> {
  BillUpdateTable(super.table);

  _i1.ColumnValue<int, int> contractId(int value) => _i1.ColumnValue(
    table.contractId,
    value,
  );

  _i1.ColumnValue<double, double> amount(double value) => _i1.ColumnValue(
    table.amount,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> dueDate(DateTime value) =>
      _i1.ColumnValue(
        table.dueDate,
        value,
      );

  _i1.ColumnValue<_i3.BillStatus, _i3.BillStatus> status(
    _i3.BillStatus value,
  ) => _i1.ColumnValue(
    table.status,
    value,
  );
}

class BillTable extends _i1.Table<int?> {
  BillTable({super.tableRelation}) : super(tableName: 'bill') {
    updateTable = BillUpdateTable(this);
    contractId = _i1.ColumnInt(
      'contractId',
      this,
    );
    amount = _i1.ColumnDouble(
      'amount',
      this,
    );
    dueDate = _i1.ColumnDateTime(
      'dueDate',
      this,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
    );
  }

  late final BillUpdateTable updateTable;

  late final _i1.ColumnInt contractId;

  _i2.ContractTable? _contract;

  late final _i1.ColumnDouble amount;

  late final _i1.ColumnDateTime dueDate;

  late final _i1.ColumnEnum<_i3.BillStatus> status;

  _i2.ContractTable get contract {
    if (_contract != null) return _contract!;
    _contract = _i1.createRelationTable(
      relationFieldName: 'contract',
      field: Bill.t.contractId,
      foreignField: _i2.Contract.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ContractTable(tableRelation: foreignTableRelation),
    );
    return _contract!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    contractId,
    amount,
    dueDate,
    status,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'contract') {
      return contract;
    }
    return null;
  }
}

class BillInclude extends _i1.IncludeObject {
  BillInclude._({_i2.ContractInclude? contract}) {
    _contract = contract;
  }

  _i2.ContractInclude? _contract;

  @override
  Map<String, _i1.Include?> get includes => {'contract': _contract};

  @override
  _i1.Table<int?> get table => Bill.t;
}

class BillIncludeList extends _i1.IncludeList {
  BillIncludeList._({
    _i1.WhereExpressionBuilder<BillTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Bill.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Bill.t;
}

class BillRepository {
  const BillRepository._();

  final attachRow = const BillAttachRowRepository._();

  /// Returns a list of [Bill]s matching the given query parameters.
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
  Future<List<Bill>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BillTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BillTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BillTable>? orderByList,
    _i1.Transaction? transaction,
    BillInclude? include,
  }) async {
    return session.db.find<Bill>(
      where: where?.call(Bill.t),
      orderBy: orderBy?.call(Bill.t),
      orderByList: orderByList?.call(Bill.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Bill] matching the given query parameters.
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
  Future<Bill?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BillTable>? where,
    int? offset,
    _i1.OrderByBuilder<BillTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BillTable>? orderByList,
    _i1.Transaction? transaction,
    BillInclude? include,
  }) async {
    return session.db.findFirstRow<Bill>(
      where: where?.call(Bill.t),
      orderBy: orderBy?.call(Bill.t),
      orderByList: orderByList?.call(Bill.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Bill] by its [id] or null if no such row exists.
  Future<Bill?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    BillInclude? include,
  }) async {
    return session.db.findById<Bill>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Bill]s in the list and returns the inserted rows.
  ///
  /// The returned [Bill]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Bill>> insert(
    _i1.Session session,
    List<Bill> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Bill>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Bill] and returns the inserted row.
  ///
  /// The returned [Bill] will have its `id` field set.
  Future<Bill> insertRow(
    _i1.Session session,
    Bill row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Bill>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Bill]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Bill>> update(
    _i1.Session session,
    List<Bill> rows, {
    _i1.ColumnSelections<BillTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Bill>(
      rows,
      columns: columns?.call(Bill.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Bill]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Bill> updateRow(
    _i1.Session session,
    Bill row, {
    _i1.ColumnSelections<BillTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Bill>(
      row,
      columns: columns?.call(Bill.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Bill] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Bill?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<BillUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Bill>(
      id,
      columnValues: columnValues(Bill.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Bill]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Bill>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<BillUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<BillTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BillTable>? orderBy,
    _i1.OrderByListBuilder<BillTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Bill>(
      columnValues: columnValues(Bill.t.updateTable),
      where: where(Bill.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Bill.t),
      orderByList: orderByList?.call(Bill.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Bill]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Bill>> delete(
    _i1.Session session,
    List<Bill> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Bill>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Bill].
  Future<Bill> deleteRow(
    _i1.Session session,
    Bill row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Bill>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Bill>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BillTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Bill>(
      where: where(Bill.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BillTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Bill>(
      where: where?.call(Bill.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class BillAttachRowRepository {
  const BillAttachRowRepository._();

  /// Creates a relation between the given [Bill] and [Contract]
  /// by setting the [Bill]'s foreign key `contractId` to refer to the [Contract].
  Future<void> contract(
    _i1.Session session,
    Bill bill,
    _i2.Contract contract, {
    _i1.Transaction? transaction,
  }) async {
    if (bill.id == null) {
      throw ArgumentError.notNull('bill.id');
    }
    if (contract.id == null) {
      throw ArgumentError.notNull('contract.id');
    }

    var $bill = bill.copyWith(contractId: contract.id);
    await session.db.updateRow<Bill>(
      $bill,
      columns: [Bill.t.contractId],
      transaction: transaction,
    );
  }
}
