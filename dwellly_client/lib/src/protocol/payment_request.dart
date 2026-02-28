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

abstract class PaymentRequest implements _i1.SerializableModel {
  PaymentRequest._({
    required this.merchantId,
    required this.tranId,
    required this.amount,
    required this.hash,
    required this.reqTime,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.type,
    this.paymentOption,
    this.items,
    this.currency,
    this.shipping,
    this.continueSuccessUrl,
    this.returnUrl,
    required this.checkoutUrl,
  });

  factory PaymentRequest({
    required String merchantId,
    required String tranId,
    required String amount,
    required String hash,
    required String reqTime,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? type,
    String? paymentOption,
    String? items,
    String? currency,
    String? shipping,
    String? continueSuccessUrl,
    String? returnUrl,
    required String checkoutUrl,
  }) = _PaymentRequestImpl;

  factory PaymentRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentRequest(
      merchantId: jsonSerialization['merchantId'] as String,
      tranId: jsonSerialization['tranId'] as String,
      amount: jsonSerialization['amount'] as String,
      hash: jsonSerialization['hash'] as String,
      reqTime: jsonSerialization['reqTime'] as String,
      firstName: jsonSerialization['firstName'] as String?,
      lastName: jsonSerialization['lastName'] as String?,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
      type: jsonSerialization['type'] as String?,
      paymentOption: jsonSerialization['paymentOption'] as String?,
      items: jsonSerialization['items'] as String?,
      currency: jsonSerialization['currency'] as String?,
      shipping: jsonSerialization['shipping'] as String?,
      continueSuccessUrl: jsonSerialization['continueSuccessUrl'] as String?,
      returnUrl: jsonSerialization['returnUrl'] as String?,
      checkoutUrl: jsonSerialization['checkoutUrl'] as String,
    );
  }

  String merchantId;

  String tranId;

  String amount;

  String hash;

  String reqTime;

  String? firstName;

  String? lastName;

  String? email;

  String? phone;

  String? type;

  String? paymentOption;

  String? items;

  String? currency;

  String? shipping;

  String? continueSuccessUrl;

  String? returnUrl;

  String checkoutUrl;

  /// Returns a shallow copy of this [PaymentRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaymentRequest copyWith({
    String? merchantId,
    String? tranId,
    String? amount,
    String? hash,
    String? reqTime,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? type,
    String? paymentOption,
    String? items,
    String? currency,
    String? shipping,
    String? continueSuccessUrl,
    String? returnUrl,
    String? checkoutUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentRequest',
      'merchantId': merchantId,
      'tranId': tranId,
      'amount': amount,
      'hash': hash,
      'reqTime': reqTime,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (type != null) 'type': type,
      if (paymentOption != null) 'paymentOption': paymentOption,
      if (items != null) 'items': items,
      if (currency != null) 'currency': currency,
      if (shipping != null) 'shipping': shipping,
      if (continueSuccessUrl != null) 'continueSuccessUrl': continueSuccessUrl,
      if (returnUrl != null) 'returnUrl': returnUrl,
      'checkoutUrl': checkoutUrl,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaymentRequestImpl extends PaymentRequest {
  _PaymentRequestImpl({
    required String merchantId,
    required String tranId,
    required String amount,
    required String hash,
    required String reqTime,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? type,
    String? paymentOption,
    String? items,
    String? currency,
    String? shipping,
    String? continueSuccessUrl,
    String? returnUrl,
    required String checkoutUrl,
  }) : super._(
         merchantId: merchantId,
         tranId: tranId,
         amount: amount,
         hash: hash,
         reqTime: reqTime,
         firstName: firstName,
         lastName: lastName,
         email: email,
         phone: phone,
         type: type,
         paymentOption: paymentOption,
         items: items,
         currency: currency,
         shipping: shipping,
         continueSuccessUrl: continueSuccessUrl,
         returnUrl: returnUrl,
         checkoutUrl: checkoutUrl,
       );

  /// Returns a shallow copy of this [PaymentRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaymentRequest copyWith({
    String? merchantId,
    String? tranId,
    String? amount,
    String? hash,
    String? reqTime,
    Object? firstName = _Undefined,
    Object? lastName = _Undefined,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    Object? type = _Undefined,
    Object? paymentOption = _Undefined,
    Object? items = _Undefined,
    Object? currency = _Undefined,
    Object? shipping = _Undefined,
    Object? continueSuccessUrl = _Undefined,
    Object? returnUrl = _Undefined,
    String? checkoutUrl,
  }) {
    return PaymentRequest(
      merchantId: merchantId ?? this.merchantId,
      tranId: tranId ?? this.tranId,
      amount: amount ?? this.amount,
      hash: hash ?? this.hash,
      reqTime: reqTime ?? this.reqTime,
      firstName: firstName is String? ? firstName : this.firstName,
      lastName: lastName is String? ? lastName : this.lastName,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
      type: type is String? ? type : this.type,
      paymentOption: paymentOption is String?
          ? paymentOption
          : this.paymentOption,
      items: items is String? ? items : this.items,
      currency: currency is String? ? currency : this.currency,
      shipping: shipping is String? ? shipping : this.shipping,
      continueSuccessUrl: continueSuccessUrl is String?
          ? continueSuccessUrl
          : this.continueSuccessUrl,
      returnUrl: returnUrl is String? ? returnUrl : this.returnUrl,
      checkoutUrl: checkoutUrl ?? this.checkoutUrl,
    );
  }
}
