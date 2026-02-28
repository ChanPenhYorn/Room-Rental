// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RoomEntity _$RoomEntityFromJson(Map<String, dynamic> json) {
  return _RoomEntity.fromJson(json);
}

/// @nodoc
mixin _$RoomEntity {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  RoomType get type => throw _privateConstructorUsedError;
  List<String> get facilities => throw _privateConstructorUsedError;

  /// Serializes this RoomEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoomEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoomEntityCopyWith<RoomEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomEntityCopyWith<$Res> {
  factory $RoomEntityCopyWith(
    RoomEntity value,
    $Res Function(RoomEntity) then,
  ) = _$RoomEntityCopyWithImpl<$Res, RoomEntity>;
  @useResult
  $Res call({
    int id,
    String title,
    String description,
    double price,
    String location,
    double latitude,
    double longitude,
    String? imageUrl,
    List<String> images,
    bool isAvailable,
    double rating,
    RoomType type,
    List<String> facilities,
  });
}

/// @nodoc
class _$RoomEntityCopyWithImpl<$Res, $Val extends RoomEntity>
    implements $RoomEntityCopyWith<$Res> {
  _$RoomEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoomEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? location = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? imageUrl = freezed,
    Object? images = null,
    Object? isAvailable = null,
    Object? rating = null,
    Object? type = null,
    Object? facilities = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isAvailable: null == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as RoomType,
            facilities: null == facilities
                ? _value.facilities
                : facilities // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RoomEntityImplCopyWith<$Res>
    implements $RoomEntityCopyWith<$Res> {
  factory _$$RoomEntityImplCopyWith(
    _$RoomEntityImpl value,
    $Res Function(_$RoomEntityImpl) then,
  ) = __$$RoomEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    String description,
    double price,
    String location,
    double latitude,
    double longitude,
    String? imageUrl,
    List<String> images,
    bool isAvailable,
    double rating,
    RoomType type,
    List<String> facilities,
  });
}

/// @nodoc
class __$$RoomEntityImplCopyWithImpl<$Res>
    extends _$RoomEntityCopyWithImpl<$Res, _$RoomEntityImpl>
    implements _$$RoomEntityImplCopyWith<$Res> {
  __$$RoomEntityImplCopyWithImpl(
    _$RoomEntityImpl _value,
    $Res Function(_$RoomEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? location = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? imageUrl = freezed,
    Object? images = null,
    Object? isAvailable = null,
    Object? rating = null,
    Object? type = null,
    Object? facilities = null,
  }) {
    return _then(
      _$RoomEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isAvailable: null == isAvailable
            ? _value.isAvailable
            : isAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as RoomType,
        facilities: null == facilities
            ? _value._facilities
            : facilities // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RoomEntityImpl implements _RoomEntity {
  const _$RoomEntityImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required final List<String> images,
    required this.isAvailable,
    required this.rating,
    required this.type,
    required final List<String> facilities,
  }) : _images = images,
       _facilities = facilities;

  factory _$RoomEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoomEntityImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  final double price;
  @override
  final String location;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? imageUrl;
  final List<String> _images;
  @override
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final bool isAvailable;
  @override
  final double rating;
  @override
  final RoomType type;
  final List<String> _facilities;
  @override
  List<String> get facilities {
    if (_facilities is EqualUnmodifiableListView) return _facilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_facilities);
  }

  @override
  String toString() {
    return 'RoomEntity(id: $id, title: $title, description: $description, price: $price, location: $location, latitude: $latitude, longitude: $longitude, imageUrl: $imageUrl, images: $images, isAvailable: $isAvailable, rating: $rating, type: $type, facilities: $facilities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(
              other._facilities,
              _facilities,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    price,
    location,
    latitude,
    longitude,
    imageUrl,
    const DeepCollectionEquality().hash(_images),
    isAvailable,
    rating,
    type,
    const DeepCollectionEquality().hash(_facilities),
  );

  /// Create a copy of RoomEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomEntityImplCopyWith<_$RoomEntityImpl> get copyWith =>
      __$$RoomEntityImplCopyWithImpl<_$RoomEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoomEntityImplToJson(this);
  }
}

abstract class _RoomEntity implements RoomEntity {
  const factory _RoomEntity({
    required final int id,
    required final String title,
    required final String description,
    required final double price,
    required final String location,
    required final double latitude,
    required final double longitude,
    required final String? imageUrl,
    required final List<String> images,
    required final bool isAvailable,
    required final double rating,
    required final RoomType type,
    required final List<String> facilities,
  }) = _$RoomEntityImpl;

  factory _RoomEntity.fromJson(Map<String, dynamic> json) =
      _$RoomEntityImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get description;
  @override
  double get price;
  @override
  String get location;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get imageUrl;
  @override
  List<String> get images;
  @override
  bool get isAvailable;
  @override
  double get rating;
  @override
  RoomType get type;
  @override
  List<String> get facilities;

  /// Create a copy of RoomEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoomEntityImplCopyWith<_$RoomEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
