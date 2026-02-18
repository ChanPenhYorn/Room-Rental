/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'contract.dart' as _i2;
import 'bill_status.dart' as _i3;
import 'package:room_rental_client/src/protocol/protocol.dart' as _i4;

abstract class Bill implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int contractId;

  _i2.Contract? contract;

  double amount;

  DateTime dueDate;

  _i3.BillStatus status;

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
