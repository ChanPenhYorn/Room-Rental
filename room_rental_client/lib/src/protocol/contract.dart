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
import 'booking.dart' as _i2;
import 'contract_status.dart' as _i3;
import 'bill.dart' as _i4;
import 'package:room_rental_client/src/protocol/protocol.dart' as _i5;

abstract class Contract implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int bookingId;

  _i2.Booking? booking;

  DateTime? signedAt;

  String contractText;

  _i3.ContractStatus status;

  List<_i4.Bill>? bills;

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
