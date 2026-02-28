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
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i3;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i4;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i5;
import 'become_owner_request.dart' as _i6;
import 'bill.dart' as _i7;
import 'bill_status.dart' as _i8;
import 'booking.dart' as _i9;
import 'booking_status.dart' as _i10;
import 'chat_message.dart' as _i11;
import 'contract.dart' as _i12;
import 'contract_status.dart' as _i13;
import 'facility.dart' as _i14;
import 'favorite.dart' as _i15;
import 'greetings/greeting.dart' as _i16;
import 'owner_request_status.dart' as _i17;
import 'payment_request.dart' as _i18;
import 'review.dart' as _i19;
import 'room.dart' as _i20;
import 'room_facility.dart' as _i21;
import 'room_status.dart' as _i22;
import 'room_type.dart' as _i23;
import 'user.dart' as _i24;
import 'user_role.dart' as _i25;
import 'package:room_rental_server/src/generated/booking.dart' as _i26;
import 'package:room_rental_server/src/generated/favorite.dart' as _i27;
import 'package:room_rental_server/src/generated/become_owner_request.dart'
    as _i28;
import 'package:room_rental_server/src/generated/room.dart' as _i29;
import 'package:room_rental_server/src/generated/user.dart' as _i30;
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

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'become_owner_request',
      dartName: 'BecomeOwnerRequest',
      schema: 'public',
      module: 'room_rental',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'become_owner_request_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'message',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:OwnerRequestStatus',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'become_owner_request_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'become_owner_request_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'bill',
      dartName: 'Bill',
      schema: 'public',
      module: 'room_rental',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'bill_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'contractId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'amount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'dueDate',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:BillStatus',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'bill_fk_0',
          columns: ['contractId'],
          referenceTable: 'contract',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'bill_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'booking',
      dartName: 'Booking',
      schema: 'public',
      module: 'room_rental',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'booking_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'roomId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'checkIn',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'checkOut',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'totalPrice',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:BookingStatus',
        ),
        _i2.ColumnDefinition(
          name: 'transactionId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'booking_fk_0',
          columns: ['roomId'],
          referenceTable: 'room',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'booking_fk_1',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'booking_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'chat_message',
      dartName: 'ChatMessage',
      schema: 'public',
      module: 'room_rental',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'chat_message_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'senderId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'receiverId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'message',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'sentAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'isRead',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'chat_message_fk_0',
          columns: ['senderId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'chat_message_fk_1',
          columns: ['receiverId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'chat_message_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'contract',
      dartName: 'Contract',
      schema: 'public',
      module: 'room_rental',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'contract_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'bookingId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'signedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'contractText',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ContractStatus',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'contract_fk_0',
          columns: ['bookingId'],
          referenceTable: 'booking',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'contract_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'contract_booking_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'bookingId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'facility',
      dartName: 'Facility',
      schema: 'public',
      module: 'room_rental',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'facility_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'icon',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'facility_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'favorite',
      dartName: 'Favorite',
      schema: 'public',
      module: 'room_rental',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'favorite_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'roomId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: '_roomFavoritesRoomId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: '_userFavoritesUserId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'favorite_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'favorite_fk_1',
          columns: ['roomId'],
          referenceTable: 'room',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'favorite_fk_2',
          columns: ['_roomFavoritesRoomId'],
          referenceTable: 'room',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'favorite_fk_3',
          columns: ['_userFavoritesUserId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'favorite_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'favorite_user_room_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'roomId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'review',
      dartName: 'Review',
      schema: 'public',
      module: 'room_rental',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'review_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'roomId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'rating',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'comment',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: '_roomReviewsRoomId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: '_userReviewsUserId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'review_fk_0',
          columns: ['roomId'],
          referenceTable: 'room',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'review_fk_1',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'review_fk_2',
          columns: ['_roomReviewsRoomId'],
          referenceTable: 'room',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'review_fk_3',
          columns: ['_userReviewsUserId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'review_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'room',
      dartName: 'Room',
      schema: 'public',
      module: 'room_rental',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'room_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'ownerId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'price',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'location',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'latitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'longitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'rating',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'type',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:RoomType',
        ),
        _i2.ColumnDefinition(
          name: 'imageUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'images',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'List<String>?',
        ),
        _i2.ColumnDefinition(
          name: 'isAvailable',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:RoomStatus',
        ),
        _i2.ColumnDefinition(
          name: 'rejectionReason',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'pendingData',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'hasPendingEdit',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'room_fk_0',
          columns: ['ownerId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'room_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'room_facility',
      dartName: 'RoomFacility',
      schema: 'public',
      module: 'room_rental',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'room_facility_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'roomId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'facilityId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'room_facility_fk_0',
          columns: ['roomId'],
          referenceTable: 'room',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'room_facility_fk_1',
          columns: ['facilityId'],
          referenceTable: 'facility',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'room_facility_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'user',
      dartName: 'User',
      schema: 'public',
      module: 'room_rental',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'user_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'fullName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'phone',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'bio',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'role',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:UserRole',
        ),
        _i2.ColumnDefinition(
          name: 'profileImage',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'user_fk_0',
          columns: ['userInfoId'],
          referenceTable: 'serverpod_user_info',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'user_user_info_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userInfoId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'user_auth_user_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i5.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

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

    if (t == _i6.BecomeOwnerRequest) {
      return _i6.BecomeOwnerRequest.fromJson(data) as T;
    }
    if (t == _i7.Bill) {
      return _i7.Bill.fromJson(data) as T;
    }
    if (t == _i8.BillStatus) {
      return _i8.BillStatus.fromJson(data) as T;
    }
    if (t == _i9.Booking) {
      return _i9.Booking.fromJson(data) as T;
    }
    if (t == _i10.BookingStatus) {
      return _i10.BookingStatus.fromJson(data) as T;
    }
    if (t == _i11.ChatMessage) {
      return _i11.ChatMessage.fromJson(data) as T;
    }
    if (t == _i12.Contract) {
      return _i12.Contract.fromJson(data) as T;
    }
    if (t == _i13.ContractStatus) {
      return _i13.ContractStatus.fromJson(data) as T;
    }
    if (t == _i14.Facility) {
      return _i14.Facility.fromJson(data) as T;
    }
    if (t == _i15.Favorite) {
      return _i15.Favorite.fromJson(data) as T;
    }
    if (t == _i16.Greeting) {
      return _i16.Greeting.fromJson(data) as T;
    }
    if (t == _i17.OwnerRequestStatus) {
      return _i17.OwnerRequestStatus.fromJson(data) as T;
    }
    if (t == _i18.PaymentRequest) {
      return _i18.PaymentRequest.fromJson(data) as T;
    }
    if (t == _i19.Review) {
      return _i19.Review.fromJson(data) as T;
    }
    if (t == _i20.Room) {
      return _i20.Room.fromJson(data) as T;
    }
    if (t == _i21.RoomFacility) {
      return _i21.RoomFacility.fromJson(data) as T;
    }
    if (t == _i22.RoomStatus) {
      return _i22.RoomStatus.fromJson(data) as T;
    }
    if (t == _i23.RoomType) {
      return _i23.RoomType.fromJson(data) as T;
    }
    if (t == _i24.User) {
      return _i24.User.fromJson(data) as T;
    }
    if (t == _i25.UserRole) {
      return _i25.UserRole.fromJson(data) as T;
    }
    if (t == _i1.getType<_i6.BecomeOwnerRequest?>()) {
      return (data != null ? _i6.BecomeOwnerRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Bill?>()) {
      return (data != null ? _i7.Bill.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.BillStatus?>()) {
      return (data != null ? _i8.BillStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Booking?>()) {
      return (data != null ? _i9.Booking.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.BookingStatus?>()) {
      return (data != null ? _i10.BookingStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.ChatMessage?>()) {
      return (data != null ? _i11.ChatMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.Contract?>()) {
      return (data != null ? _i12.Contract.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.ContractStatus?>()) {
      return (data != null ? _i13.ContractStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.Facility?>()) {
      return (data != null ? _i14.Facility.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.Favorite?>()) {
      return (data != null ? _i15.Favorite.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.Greeting?>()) {
      return (data != null ? _i16.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.OwnerRequestStatus?>()) {
      return (data != null ? _i17.OwnerRequestStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.PaymentRequest?>()) {
      return (data != null ? _i18.PaymentRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.Review?>()) {
      return (data != null ? _i19.Review.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.Room?>()) {
      return (data != null ? _i20.Room.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.RoomFacility?>()) {
      return (data != null ? _i21.RoomFacility.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.RoomStatus?>()) {
      return (data != null ? _i22.RoomStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.RoomType?>()) {
      return (data != null ? _i23.RoomType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.User?>()) {
      return (data != null ? _i24.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.UserRole?>()) {
      return (data != null ? _i25.UserRole.fromJson(data) : null) as T;
    }
    if (t == List<_i7.Bill>) {
      return (data as List).map((e) => deserialize<_i7.Bill>(e)).toList() as T;
    }
    if (t == _i1.getType<List<_i7.Bill>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i7.Bill>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i21.RoomFacility>) {
      return (data as List)
              .map((e) => deserialize<_i21.RoomFacility>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i21.RoomFacility>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i21.RoomFacility>(e))
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
    if (t == List<_i9.Booking>) {
      return (data as List).map((e) => deserialize<_i9.Booking>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i9.Booking>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i9.Booking>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i15.Favorite>) {
      return (data as List).map((e) => deserialize<_i15.Favorite>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i15.Favorite>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i15.Favorite>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i19.Review>) {
      return (data as List).map((e) => deserialize<_i19.Review>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i19.Review>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i19.Review>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i20.Room>) {
      return (data as List).map((e) => deserialize<_i20.Room>(e)).toList() as T;
    }
    if (t == _i1.getType<List<_i20.Room>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i20.Room>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i11.ChatMessage>) {
      return (data as List)
              .map((e) => deserialize<_i11.ChatMessage>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i11.ChatMessage>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i11.ChatMessage>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i26.Booking>) {
      return (data as List).map((e) => deserialize<_i26.Booking>(e)).toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i27.Favorite>) {
      return (data as List).map((e) => deserialize<_i27.Favorite>(e)).toList()
          as T;
    }
    if (t == List<_i28.BecomeOwnerRequest>) {
      return (data as List)
              .map((e) => deserialize<_i28.BecomeOwnerRequest>(e))
              .toList()
          as T;
    }
    if (t == List<_i29.Room>) {
      return (data as List).map((e) => deserialize<_i29.Room>(e)).toList() as T;
    }
    if (t == List<_i30.User>) {
      return (data as List).map((e) => deserialize<_i30.User>(e)).toList() as T;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)),
          )
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i5.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i6.BecomeOwnerRequest => 'BecomeOwnerRequest',
      _i7.Bill => 'Bill',
      _i8.BillStatus => 'BillStatus',
      _i9.Booking => 'Booking',
      _i10.BookingStatus => 'BookingStatus',
      _i11.ChatMessage => 'ChatMessage',
      _i12.Contract => 'Contract',
      _i13.ContractStatus => 'ContractStatus',
      _i14.Facility => 'Facility',
      _i15.Favorite => 'Favorite',
      _i16.Greeting => 'Greeting',
      _i17.OwnerRequestStatus => 'OwnerRequestStatus',
      _i18.PaymentRequest => 'PaymentRequest',
      _i19.Review => 'Review',
      _i20.Room => 'Room',
      _i21.RoomFacility => 'RoomFacility',
      _i22.RoomStatus => 'RoomStatus',
      _i23.RoomType => 'RoomType',
      _i24.User => 'User',
      _i25.UserRole => 'UserRole',
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
      case _i6.BecomeOwnerRequest():
        return 'BecomeOwnerRequest';
      case _i7.Bill():
        return 'Bill';
      case _i8.BillStatus():
        return 'BillStatus';
      case _i9.Booking():
        return 'Booking';
      case _i10.BookingStatus():
        return 'BookingStatus';
      case _i11.ChatMessage():
        return 'ChatMessage';
      case _i12.Contract():
        return 'Contract';
      case _i13.ContractStatus():
        return 'ContractStatus';
      case _i14.Facility():
        return 'Facility';
      case _i15.Favorite():
        return 'Favorite';
      case _i16.Greeting():
        return 'Greeting';
      case _i17.OwnerRequestStatus():
        return 'OwnerRequestStatus';
      case _i18.PaymentRequest():
        return 'PaymentRequest';
      case _i19.Review():
        return 'Review';
      case _i20.Room():
        return 'Room';
      case _i21.RoomFacility():
        return 'RoomFacility';
      case _i22.RoomStatus():
        return 'RoomStatus';
      case _i23.RoomType():
        return 'RoomType';
      case _i24.User():
        return 'User';
      case _i25.UserRole():
        return 'UserRole';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i5.Protocol().getClassNameForObject(data);
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
      return deserialize<_i6.BecomeOwnerRequest>(data['data']);
    }
    if (dataClassName == 'Bill') {
      return deserialize<_i7.Bill>(data['data']);
    }
    if (dataClassName == 'BillStatus') {
      return deserialize<_i8.BillStatus>(data['data']);
    }
    if (dataClassName == 'Booking') {
      return deserialize<_i9.Booking>(data['data']);
    }
    if (dataClassName == 'BookingStatus') {
      return deserialize<_i10.BookingStatus>(data['data']);
    }
    if (dataClassName == 'ChatMessage') {
      return deserialize<_i11.ChatMessage>(data['data']);
    }
    if (dataClassName == 'Contract') {
      return deserialize<_i12.Contract>(data['data']);
    }
    if (dataClassName == 'ContractStatus') {
      return deserialize<_i13.ContractStatus>(data['data']);
    }
    if (dataClassName == 'Facility') {
      return deserialize<_i14.Facility>(data['data']);
    }
    if (dataClassName == 'Favorite') {
      return deserialize<_i15.Favorite>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i16.Greeting>(data['data']);
    }
    if (dataClassName == 'OwnerRequestStatus') {
      return deserialize<_i17.OwnerRequestStatus>(data['data']);
    }
    if (dataClassName == 'PaymentRequest') {
      return deserialize<_i18.PaymentRequest>(data['data']);
    }
    if (dataClassName == 'Review') {
      return deserialize<_i19.Review>(data['data']);
    }
    if (dataClassName == 'Room') {
      return deserialize<_i20.Room>(data['data']);
    }
    if (dataClassName == 'RoomFacility') {
      return deserialize<_i21.RoomFacility>(data['data']);
    }
    if (dataClassName == 'RoomStatus') {
      return deserialize<_i22.RoomStatus>(data['data']);
    }
    if (dataClassName == 'RoomType') {
      return deserialize<_i23.RoomType>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i24.User>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i25.UserRole>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i4.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i5.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i5.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i6.BecomeOwnerRequest:
        return _i6.BecomeOwnerRequest.t;
      case _i7.Bill:
        return _i7.Bill.t;
      case _i9.Booking:
        return _i9.Booking.t;
      case _i11.ChatMessage:
        return _i11.ChatMessage.t;
      case _i12.Contract:
        return _i12.Contract.t;
      case _i14.Facility:
        return _i14.Facility.t;
      case _i15.Favorite:
        return _i15.Favorite.t;
      case _i19.Review:
        return _i19.Review.t;
      case _i20.Room:
        return _i20.Room.t;
      case _i21.RoomFacility:
        return _i21.RoomFacility.t;
      case _i24.User:
        return _i24.User.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'room_rental';

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
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i5.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
