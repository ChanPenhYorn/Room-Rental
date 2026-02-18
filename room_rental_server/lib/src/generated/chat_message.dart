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
import 'user.dart' as _i2;
import 'package:room_rental_server/src/generated/protocol.dart' as _i3;

abstract class ChatMessage
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ChatMessage._({
    this.id,
    required this.senderId,
    this.sender,
    required this.receiverId,
    this.receiver,
    required this.message,
    required this.sentAt,
    required this.isRead,
  });

  factory ChatMessage({
    int? id,
    required int senderId,
    _i2.User? sender,
    required int receiverId,
    _i2.User? receiver,
    required String message,
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
      sentAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
      isRead: jsonSerialization['isRead'] as bool,
    );
  }

  static final t = ChatMessageTable();

  static const db = ChatMessageRepository._();

  @override
  int? id;

  int senderId;

  _i2.User? sender;

  int receiverId;

  _i2.User? receiver;

  String message;

  DateTime sentAt;

  bool isRead;

  @override
  _i1.Table<int?> get table => t;

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
      'sentAt': sentAt.toJson(),
      'isRead': isRead,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChatMessage',
      if (id != null) 'id': id,
      'senderId': senderId,
      if (sender != null) 'sender': sender?.toJsonForProtocol(),
      'receiverId': receiverId,
      if (receiver != null) 'receiver': receiver?.toJsonForProtocol(),
      'message': message,
      'sentAt': sentAt.toJson(),
      'isRead': isRead,
    };
  }

  static ChatMessageInclude include({
    _i2.UserInclude? sender,
    _i2.UserInclude? receiver,
  }) {
    return ChatMessageInclude._(
      sender: sender,
      receiver: receiver,
    );
  }

  static ChatMessageIncludeList includeList({
    _i1.WhereExpressionBuilder<ChatMessageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChatMessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChatMessageTable>? orderByList,
    ChatMessageInclude? include,
  }) {
    return ChatMessageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChatMessage.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ChatMessage.t),
      include: include,
    );
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
    required DateTime sentAt,
    required bool isRead,
  }) : super._(
         id: id,
         senderId: senderId,
         sender: sender,
         receiverId: receiverId,
         receiver: receiver,
         message: message,
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
      sentAt: sentAt ?? this.sentAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

class ChatMessageUpdateTable extends _i1.UpdateTable<ChatMessageTable> {
  ChatMessageUpdateTable(super.table);

  _i1.ColumnValue<int, int> senderId(int value) => _i1.ColumnValue(
    table.senderId,
    value,
  );

  _i1.ColumnValue<int, int> receiverId(int value) => _i1.ColumnValue(
    table.receiverId,
    value,
  );

  _i1.ColumnValue<String, String> message(String value) => _i1.ColumnValue(
    table.message,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> sentAt(DateTime value) => _i1.ColumnValue(
    table.sentAt,
    value,
  );

  _i1.ColumnValue<bool, bool> isRead(bool value) => _i1.ColumnValue(
    table.isRead,
    value,
  );
}

class ChatMessageTable extends _i1.Table<int?> {
  ChatMessageTable({super.tableRelation}) : super(tableName: 'chat_message') {
    updateTable = ChatMessageUpdateTable(this);
    senderId = _i1.ColumnInt(
      'senderId',
      this,
    );
    receiverId = _i1.ColumnInt(
      'receiverId',
      this,
    );
    message = _i1.ColumnString(
      'message',
      this,
    );
    sentAt = _i1.ColumnDateTime(
      'sentAt',
      this,
    );
    isRead = _i1.ColumnBool(
      'isRead',
      this,
    );
  }

  late final ChatMessageUpdateTable updateTable;

  late final _i1.ColumnInt senderId;

  _i2.UserTable? _sender;

  late final _i1.ColumnInt receiverId;

  _i2.UserTable? _receiver;

  late final _i1.ColumnString message;

  late final _i1.ColumnDateTime sentAt;

  late final _i1.ColumnBool isRead;

  _i2.UserTable get sender {
    if (_sender != null) return _sender!;
    _sender = _i1.createRelationTable(
      relationFieldName: 'sender',
      field: ChatMessage.t.senderId,
      foreignField: _i2.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserTable(tableRelation: foreignTableRelation),
    );
    return _sender!;
  }

  _i2.UserTable get receiver {
    if (_receiver != null) return _receiver!;
    _receiver = _i1.createRelationTable(
      relationFieldName: 'receiver',
      field: ChatMessage.t.receiverId,
      foreignField: _i2.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserTable(tableRelation: foreignTableRelation),
    );
    return _receiver!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    senderId,
    receiverId,
    message,
    sentAt,
    isRead,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'sender') {
      return sender;
    }
    if (relationField == 'receiver') {
      return receiver;
    }
    return null;
  }
}

class ChatMessageInclude extends _i1.IncludeObject {
  ChatMessageInclude._({
    _i2.UserInclude? sender,
    _i2.UserInclude? receiver,
  }) {
    _sender = sender;
    _receiver = receiver;
  }

  _i2.UserInclude? _sender;

  _i2.UserInclude? _receiver;

  @override
  Map<String, _i1.Include?> get includes => {
    'sender': _sender,
    'receiver': _receiver,
  };

  @override
  _i1.Table<int?> get table => ChatMessage.t;
}

class ChatMessageIncludeList extends _i1.IncludeList {
  ChatMessageIncludeList._({
    _i1.WhereExpressionBuilder<ChatMessageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ChatMessage.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ChatMessage.t;
}

class ChatMessageRepository {
  const ChatMessageRepository._();

  final attachRow = const ChatMessageAttachRowRepository._();

  /// Returns a list of [ChatMessage]s matching the given query parameters.
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
  Future<List<ChatMessage>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChatMessageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChatMessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChatMessageTable>? orderByList,
    _i1.Transaction? transaction,
    ChatMessageInclude? include,
  }) async {
    return session.db.find<ChatMessage>(
      where: where?.call(ChatMessage.t),
      orderBy: orderBy?.call(ChatMessage.t),
      orderByList: orderByList?.call(ChatMessage.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ChatMessage] matching the given query parameters.
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
  Future<ChatMessage?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChatMessageTable>? where,
    int? offset,
    _i1.OrderByBuilder<ChatMessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChatMessageTable>? orderByList,
    _i1.Transaction? transaction,
    ChatMessageInclude? include,
  }) async {
    return session.db.findFirstRow<ChatMessage>(
      where: where?.call(ChatMessage.t),
      orderBy: orderBy?.call(ChatMessage.t),
      orderByList: orderByList?.call(ChatMessage.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ChatMessage] by its [id] or null if no such row exists.
  Future<ChatMessage?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ChatMessageInclude? include,
  }) async {
    return session.db.findById<ChatMessage>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ChatMessage]s in the list and returns the inserted rows.
  ///
  /// The returned [ChatMessage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ChatMessage>> insert(
    _i1.Session session,
    List<ChatMessage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ChatMessage>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ChatMessage] and returns the inserted row.
  ///
  /// The returned [ChatMessage] will have its `id` field set.
  Future<ChatMessage> insertRow(
    _i1.Session session,
    ChatMessage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChatMessage>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ChatMessage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ChatMessage>> update(
    _i1.Session session,
    List<ChatMessage> rows, {
    _i1.ColumnSelections<ChatMessageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ChatMessage>(
      rows,
      columns: columns?.call(ChatMessage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChatMessage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ChatMessage> updateRow(
    _i1.Session session,
    ChatMessage row, {
    _i1.ColumnSelections<ChatMessageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChatMessage>(
      row,
      columns: columns?.call(ChatMessage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChatMessage] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ChatMessage?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ChatMessageUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ChatMessage>(
      id,
      columnValues: columnValues(ChatMessage.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ChatMessage]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ChatMessage>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ChatMessageUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ChatMessageTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChatMessageTable>? orderBy,
    _i1.OrderByListBuilder<ChatMessageTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ChatMessage>(
      columnValues: columnValues(ChatMessage.t.updateTable),
      where: where(ChatMessage.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChatMessage.t),
      orderByList: orderByList?.call(ChatMessage.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ChatMessage]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ChatMessage>> delete(
    _i1.Session session,
    List<ChatMessage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ChatMessage>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ChatMessage].
  Future<ChatMessage> deleteRow(
    _i1.Session session,
    ChatMessage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChatMessage>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ChatMessage>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ChatMessageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ChatMessage>(
      where: where(ChatMessage.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChatMessageTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ChatMessage>(
      where: where?.call(ChatMessage.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ChatMessageAttachRowRepository {
  const ChatMessageAttachRowRepository._();

  /// Creates a relation between the given [ChatMessage] and [User]
  /// by setting the [ChatMessage]'s foreign key `senderId` to refer to the [User].
  Future<void> sender(
    _i1.Session session,
    ChatMessage chatMessage,
    _i2.User sender, {
    _i1.Transaction? transaction,
  }) async {
    if (chatMessage.id == null) {
      throw ArgumentError.notNull('chatMessage.id');
    }
    if (sender.id == null) {
      throw ArgumentError.notNull('sender.id');
    }

    var $chatMessage = chatMessage.copyWith(senderId: sender.id);
    await session.db.updateRow<ChatMessage>(
      $chatMessage,
      columns: [ChatMessage.t.senderId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [ChatMessage] and [User]
  /// by setting the [ChatMessage]'s foreign key `receiverId` to refer to the [User].
  Future<void> receiver(
    _i1.Session session,
    ChatMessage chatMessage,
    _i2.User receiver, {
    _i1.Transaction? transaction,
  }) async {
    if (chatMessage.id == null) {
      throw ArgumentError.notNull('chatMessage.id');
    }
    if (receiver.id == null) {
      throw ArgumentError.notNull('receiver.id');
    }

    var $chatMessage = chatMessage.copyWith(receiverId: receiver.id);
    await session.db.updateRow<ChatMessage>(
      $chatMessage,
      columns: [ChatMessage.t.receiverId],
      transaction: transaction,
    );
  }
}
