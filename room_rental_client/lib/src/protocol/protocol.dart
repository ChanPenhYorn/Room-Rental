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
import 'become_owner_request.dart' as _i2;
import 'bill.dart' as _i3;
import 'bill_status.dart' as _i4;
import 'booking.dart' as _i5;
import 'booking_status.dart' as _i6;
import 'chat_message.dart' as _i7;
import 'contract.dart' as _i8;
import 'contract_status.dart' as _i9;
import 'facility.dart' as _i10;
import 'favorite.dart' as _i11;
import 'greetings/greeting.dart' as _i12;
import 'owner_request_status.dart' as _i13;
import 'payment_request.dart' as _i14;
import 'review.dart' as _i15;
import 'room.dart' as _i16;
import 'room_facility.dart' as _i17;
import 'room_status.dart' as _i18;
import 'room_type.dart' as _i19;
import 'user.dart' as _i20;
import 'user_role.dart' as _i21;
import 'package:room_rental_client/src/protocol/booking.dart' as _i22;
import 'package:room_rental_client/src/protocol/favorite.dart' as _i23;
import 'package:room_rental_client/src/protocol/become_owner_request.dart'
    as _i24;
import 'package:room_rental_client/src/protocol/room.dart' as _i25;
import 'package:room_rental_client/src/protocol/user.dart' as _i26;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i27;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i28;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i29;
export 'become_owner_request.dart';
export 'bill.dart';
export 'bill_status.dart';
export 'booking.dart';
export 'booking_status.dart';
export 'chat_message.dart';
export 'contract.dart';
export 'contract_status.dart';
export 'facility.dart';
export 'favorite.dart';
export 'greetings/greeting.dart';
export 'owner_request_status.dart';
export 'payment_request.dart';
export 'review.dart';
export 'room.dart';
export 'room_facility.dart';
export 'room_status.dart';
export 'room_type.dart';
export 'user.dart';
export 'user_role.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.BecomeOwnerRequest) {
      return _i2.BecomeOwnerRequest.fromJson(data) as T;
    }
    if (t == _i3.Bill) {
      return _i3.Bill.fromJson(data) as T;
    }
    if (t == _i4.BillStatus) {
      return _i4.BillStatus.fromJson(data) as T;
    }
    if (t == _i5.Booking) {
      return _i5.Booking.fromJson(data) as T;
    }
    if (t == _i6.BookingStatus) {
      return _i6.BookingStatus.fromJson(data) as T;
    }
    if (t == _i7.ChatMessage) {
      return _i7.ChatMessage.fromJson(data) as T;
    }
    if (t == _i8.Contract) {
      return _i8.Contract.fromJson(data) as T;
    }
    if (t == _i9.ContractStatus) {
      return _i9.ContractStatus.fromJson(data) as T;
    }
    if (t == _i10.Facility) {
      return _i10.Facility.fromJson(data) as T;
    }
    if (t == _i11.Favorite) {
      return _i11.Favorite.fromJson(data) as T;
    }
    if (t == _i12.Greeting) {
      return _i12.Greeting.fromJson(data) as T;
    }
    if (t == _i13.OwnerRequestStatus) {
      return _i13.OwnerRequestStatus.fromJson(data) as T;
    }
    if (t == _i14.PaymentRequest) {
      return _i14.PaymentRequest.fromJson(data) as T;
    }
    if (t == _i15.Review) {
      return _i15.Review.fromJson(data) as T;
    }
    if (t == _i16.Room) {
      return _i16.Room.fromJson(data) as T;
    }
    if (t == _i17.RoomFacility) {
      return _i17.RoomFacility.fromJson(data) as T;
    }
    if (t == _i18.RoomStatus) {
      return _i18.RoomStatus.fromJson(data) as T;
    }
    if (t == _i19.RoomType) {
      return _i19.RoomType.fromJson(data) as T;
    }
    if (t == _i20.User) {
      return _i20.User.fromJson(data) as T;
    }
    if (t == _i21.UserRole) {
      return _i21.UserRole.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.BecomeOwnerRequest?>()) {
      return (data != null ? _i2.BecomeOwnerRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Bill?>()) {
      return (data != null ? _i3.Bill.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.BillStatus?>()) {
      return (data != null ? _i4.BillStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Booking?>()) {
      return (data != null ? _i5.Booking.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.BookingStatus?>()) {
      return (data != null ? _i6.BookingStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ChatMessage?>()) {
      return (data != null ? _i7.ChatMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Contract?>()) {
      return (data != null ? _i8.Contract.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.ContractStatus?>()) {
      return (data != null ? _i9.ContractStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Facility?>()) {
      return (data != null ? _i10.Facility.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Favorite?>()) {
      return (data != null ? _i11.Favorite.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.Greeting?>()) {
      return (data != null ? _i12.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.OwnerRequestStatus?>()) {
      return (data != null ? _i13.OwnerRequestStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i14.PaymentRequest?>()) {
      return (data != null ? _i14.PaymentRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.Review?>()) {
      return (data != null ? _i15.Review.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.Room?>()) {
      return (data != null ? _i16.Room.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.RoomFacility?>()) {
      return (data != null ? _i17.RoomFacility.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.RoomStatus?>()) {
      return (data != null ? _i18.RoomStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.RoomType?>()) {
      return (data != null ? _i19.RoomType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.User?>()) {
      return (data != null ? _i20.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.UserRole?>()) {
      return (data != null ? _i21.UserRole.fromJson(data) : null) as T;
    }
    if (t == List<_i3.Bill>) {
      return (data as List).map((e) => deserialize<_i3.Bill>(e)).toList() as T;
    }
    if (t == _i1.getType<List<_i3.Bill>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i3.Bill>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i17.RoomFacility>) {
      return (data as List)
              .map((e) => deserialize<_i17.RoomFacility>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i17.RoomFacility>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i17.RoomFacility>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i5.Booking>) {
      return (data as List).map((e) => deserialize<_i5.Booking>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i5.Booking>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i5.Booking>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i11.Favorite>) {
      return (data as List).map((e) => deserialize<_i11.Favorite>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i11.Favorite>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i11.Favorite>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i15.Review>) {
      return (data as List).map((e) => deserialize<_i15.Review>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i15.Review>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i15.Review>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i16.Room>) {
      return (data as List).map((e) => deserialize<_i16.Room>(e)).toList() as T;
    }
    if (t == _i1.getType<List<_i16.Room>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i16.Room>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i7.ChatMessage>) {
      return (data as List).map((e) => deserialize<_i7.ChatMessage>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i7.ChatMessage>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i7.ChatMessage>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i22.Booking>) {
      return (data as List).map((e) => deserialize<_i22.Booking>(e)).toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i23.Favorite>) {
      return (data as List).map((e) => deserialize<_i23.Favorite>(e)).toList()
          as T;
    }
    if (t == List<_i24.BecomeOwnerRequest>) {
      return (data as List)
              .map((e) => deserialize<_i24.BecomeOwnerRequest>(e))
              .toList()
          as T;
    }
    if (t == List<_i25.Room>) {
      return (data as List).map((e) => deserialize<_i25.Room>(e)).toList() as T;
    }
    if (t == List<_i26.User>) {
      return (data as List).map((e) => deserialize<_i26.User>(e)).toList() as T;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)),
          )
          as T;
    }
    try {
      return _i27.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i28.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i29.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.BecomeOwnerRequest => 'BecomeOwnerRequest',
      _i3.Bill => 'Bill',
      _i4.BillStatus => 'BillStatus',
      _i5.Booking => 'Booking',
      _i6.BookingStatus => 'BookingStatus',
      _i7.ChatMessage => 'ChatMessage',
      _i8.Contract => 'Contract',
      _i9.ContractStatus => 'ContractStatus',
      _i10.Facility => 'Facility',
      _i11.Favorite => 'Favorite',
      _i12.Greeting => 'Greeting',
      _i13.OwnerRequestStatus => 'OwnerRequestStatus',
      _i14.PaymentRequest => 'PaymentRequest',
      _i15.Review => 'Review',
      _i16.Room => 'Room',
      _i17.RoomFacility => 'RoomFacility',
      _i18.RoomStatus => 'RoomStatus',
      _i19.RoomType => 'RoomType',
      _i20.User => 'User',
      _i21.UserRole => 'UserRole',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('room_rental.', '');
    }

    switch (data) {
      case _i2.BecomeOwnerRequest():
        return 'BecomeOwnerRequest';
      case _i3.Bill():
        return 'Bill';
      case _i4.BillStatus():
        return 'BillStatus';
      case _i5.Booking():
        return 'Booking';
      case _i6.BookingStatus():
        return 'BookingStatus';
      case _i7.ChatMessage():
        return 'ChatMessage';
      case _i8.Contract():
        return 'Contract';
      case _i9.ContractStatus():
        return 'ContractStatus';
      case _i10.Facility():
        return 'Facility';
      case _i11.Favorite():
        return 'Favorite';
      case _i12.Greeting():
        return 'Greeting';
      case _i13.OwnerRequestStatus():
        return 'OwnerRequestStatus';
      case _i14.PaymentRequest():
        return 'PaymentRequest';
      case _i15.Review():
        return 'Review';
      case _i16.Room():
        return 'Room';
      case _i17.RoomFacility():
        return 'RoomFacility';
      case _i18.RoomStatus():
        return 'RoomStatus';
      case _i19.RoomType():
        return 'RoomType';
      case _i20.User():
        return 'User';
      case _i21.UserRole():
        return 'UserRole';
    }
    className = _i27.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i28.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i29.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'BecomeOwnerRequest') {
      return deserialize<_i2.BecomeOwnerRequest>(data['data']);
    }
    if (dataClassName == 'Bill') {
      return deserialize<_i3.Bill>(data['data']);
    }
    if (dataClassName == 'BillStatus') {
      return deserialize<_i4.BillStatus>(data['data']);
    }
    if (dataClassName == 'Booking') {
      return deserialize<_i5.Booking>(data['data']);
    }
    if (dataClassName == 'BookingStatus') {
      return deserialize<_i6.BookingStatus>(data['data']);
    }
    if (dataClassName == 'ChatMessage') {
      return deserialize<_i7.ChatMessage>(data['data']);
    }
    if (dataClassName == 'Contract') {
      return deserialize<_i8.Contract>(data['data']);
    }
    if (dataClassName == 'ContractStatus') {
      return deserialize<_i9.ContractStatus>(data['data']);
    }
    if (dataClassName == 'Facility') {
      return deserialize<_i10.Facility>(data['data']);
    }
    if (dataClassName == 'Favorite') {
      return deserialize<_i11.Favorite>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i12.Greeting>(data['data']);
    }
    if (dataClassName == 'OwnerRequestStatus') {
      return deserialize<_i13.OwnerRequestStatus>(data['data']);
    }
    if (dataClassName == 'PaymentRequest') {
      return deserialize<_i14.PaymentRequest>(data['data']);
    }
    if (dataClassName == 'Review') {
      return deserialize<_i15.Review>(data['data']);
    }
    if (dataClassName == 'Room') {
      return deserialize<_i16.Room>(data['data']);
    }
    if (dataClassName == 'RoomFacility') {
      return deserialize<_i17.RoomFacility>(data['data']);
    }
    if (dataClassName == 'RoomStatus') {
      return deserialize<_i18.RoomStatus>(data['data']);
    }
    if (dataClassName == 'RoomType') {
      return deserialize<_i19.RoomType>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i20.User>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i21.UserRole>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i27.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i28.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i29.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i27.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i28.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i29.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
