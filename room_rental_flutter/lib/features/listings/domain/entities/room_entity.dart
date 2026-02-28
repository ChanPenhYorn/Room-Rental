import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:room_rental_client/room_rental_client.dart';

part 'room_entity.freezed.dart';
part 'room_entity.g.dart';

@freezed
class RoomEntity with _$RoomEntity {
  const factory RoomEntity({
    required int id,
    required String title,
    required String description,
    required double price,
    required String location,
    required double latitude,
    required double longitude,
    required String? imageUrl,
    required List<String> images,
    required bool isAvailable,
    required double rating,
    required RoomType type,
    required List<String> facilities,
    @Default(RoomStatus.pending) RoomStatus status,
    String? ownerName,
    String? rejectionReason,
    @Default(false) bool hasPendingEdit,
    String? pendingData,
  }) = _RoomEntity;

  factory RoomEntity.fromJson(Map<String, dynamic> json) =>
      _$RoomEntityFromJson(json);
}
