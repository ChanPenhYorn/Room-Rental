// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoomEntityImpl _$$RoomEntityImplFromJson(Map<String, dynamic> json) =>
    _$RoomEntityImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      location: json['location'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      images: (json['images'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isAvailable: json['isAvailable'] as bool,
      rating: (json['rating'] as num).toDouble(),
      type: $enumDecode(_$RoomTypeEnumMap, json['type']),
      facilities: (json['facilities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      status:
          $enumDecodeNullable(_$RoomStatusEnumMap, json['status']) ??
          RoomStatus.pending,
      ownerName: json['ownerName'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      hasPendingEdit: json['hasPendingEdit'] as bool? ?? false,
      pendingData: json['pendingData'] as String?,
    );

Map<String, dynamic> _$$RoomEntityImplToJson(_$RoomEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'imageUrl': instance.imageUrl,
      'images': instance.images,
      'isAvailable': instance.isAvailable,
      'rating': instance.rating,
      'type': instance.type,
      'facilities': instance.facilities,
      'status': instance.status,
      'ownerName': instance.ownerName,
      'rejectionReason': instance.rejectionReason,
      'hasPendingEdit': instance.hasPendingEdit,
      'pendingData': instance.pendingData,
    };

const _$RoomTypeEnumMap = {
  RoomType.studio: 'studio',
  RoomType.apartment1br: 'apartment1br',
  RoomType.apartment2br: 'apartment2br',
  RoomType.dormitory: 'dormitory',
  RoomType.villa: 'villa',
  RoomType.house: 'house',
  RoomType.condo: 'condo',
};

const _$RoomStatusEnumMap = {
  RoomStatus.pending: 'pending',
  RoomStatus.approved: 'approved',
  RoomStatus.rejected: 'rejected',
  RoomStatus.archived: 'archived',
};
