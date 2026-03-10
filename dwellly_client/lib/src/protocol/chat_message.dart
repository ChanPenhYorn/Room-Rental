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
import 'user.dart' as _i2;
import 'package:dwellly_client/src/protocol/protocol.dart' as _i3;

abstract class ChatMessage implements _i1.SerializableModel {
  ChatMessage._({
    this.id,
    required this.senderId,
    this.sender,
    required this.receiverId,
    this.receiver,
    required this.message,
    String? messageType,
    this.attachmentUrl,
    this.attachmentDuration,
    this.attachmentName,
    this.attachmentSize,
    required this.sentAt,
    required this.isRead,
  }) : messageType = messageType ?? 'text';

  factory ChatMessage({
    int? id,
    required int senderId,
    _i2.User? sender,
    required int receiverId,
    _i2.User? receiver,
    required String message,
    String? messageType,
    String? attachmentUrl,
    int? attachmentDuration,
    String? attachmentName,
    int? attachmentSize,
    required DateTime sentAt,
    required bool isRead,
  }) = _ChatMessageImpl;

  factory ChatMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatMessage(
      id: jsonSerialization['id'] as int?,
      senderId: jsonSerialization['senderId'] as int,
      sender: jsonSerialization['sender'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.User>(jsonSerialization['sender']),
      receiverId: jsonSerialization['receiverId'] as int,
      receiver: jsonSerialization['receiver'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.User>(jsonSerialization['receiver']),
      message: jsonSerialization['message'] as String,
      messageType: jsonSerialization['messageType'] as String?,
      attachmentUrl: jsonSerialization['attachmentUrl'] as String?,
      attachmentDuration: jsonSerialization['attachmentDuration'] as int?,
      attachmentName: jsonSerialization['attachmentName'] as String?,
      attachmentSize: jsonSerialization['attachmentSize'] as int?,
      sentAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
      isRead: _i1.BoolJsonExtension.fromJson(jsonSerialization['isRead']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int senderId;

  _i2.User? sender;

  int receiverId;

  _i2.User? receiver;

  String message;

  String messageType;

  String? attachmentUrl;

  int? attachmentDuration;

  String? attachmentName;

  int? attachmentSize;

  DateTime sentAt;

  bool isRead;

  /// Returns a shallow copy of this [ChatMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatMessage copyWith({
    int? id,
    int? senderId,
    _i2.User? sender,
    int? receiverId,
    _i2.User? receiver,
    String? message,
    String? messageType,
    String? attachmentUrl,
    int? attachmentDuration,
    String? attachmentName,
    int? attachmentSize,
    DateTime? sentAt,
    bool? isRead,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChatMessage',
      if (id != null) 'id': id,
      'senderId': senderId,
      if (sender != null) 'sender': sender?.toJson(),
      'receiverId': receiverId,
      if (receiver != null) 'receiver': receiver?.toJson(),
      'message': message,
      'messageType': messageType,
      if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
      if (attachmentDuration != null) 'attachmentDuration': attachmentDuration,
      if (attachmentName != null) 'attachmentName': attachmentName,
      if (attachmentSize != null) 'attachmentSize': attachmentSize,
      'sentAt': sentAt.toJson(),
      'isRead': isRead,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChatMessageImpl extends ChatMessage {
  _ChatMessageImpl({
    int? id,
    required int senderId,
    _i2.User? sender,
    required int receiverId,
    _i2.User? receiver,
    required String message,
    String? messageType,
    String? attachmentUrl,
    int? attachmentDuration,
    String? attachmentName,
    int? attachmentSize,
    required DateTime sentAt,
    required bool isRead,
  }) : super._(
         id: id,
         senderId: senderId,
         sender: sender,
         receiverId: receiverId,
         receiver: receiver,
         message: message,
         messageType: messageType,
         attachmentUrl: attachmentUrl,
         attachmentDuration: attachmentDuration,
         attachmentName: attachmentName,
         attachmentSize: attachmentSize,
         sentAt: sentAt,
         isRead: isRead,
       );

  /// Returns a shallow copy of this [ChatMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatMessage copyWith({
    Object? id = _Undefined,
    int? senderId,
    Object? sender = _Undefined,
    int? receiverId,
    Object? receiver = _Undefined,
    String? message,
    String? messageType,
    Object? attachmentUrl = _Undefined,
    Object? attachmentDuration = _Undefined,
    Object? attachmentName = _Undefined,
    Object? attachmentSize = _Undefined,
    DateTime? sentAt,
    bool? isRead,
  }) {
    return ChatMessage(
      id: id is int? ? id : this.id,
      senderId: senderId ?? this.senderId,
      sender: sender is _i2.User? ? sender : this.sender?.copyWith(),
      receiverId: receiverId ?? this.receiverId,
      receiver: receiver is _i2.User? ? receiver : this.receiver?.copyWith(),
      message: message ?? this.message,
      messageType: messageType ?? this.messageType,
      attachmentUrl: attachmentUrl is String?
          ? attachmentUrl
          : this.attachmentUrl,
      attachmentDuration: attachmentDuration is int?
          ? attachmentDuration
          : this.attachmentDuration,
      attachmentName: attachmentName is String?
          ? attachmentName
          : this.attachmentName,
      attachmentSize: attachmentSize is int?
          ? attachmentSize
          : this.attachmentSize,
      sentAt: sentAt ?? this.sentAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
