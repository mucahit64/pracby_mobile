// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StoreItem _$StoreItemFromJson(Map<String, dynamic> json) {
  return _StoreItem.fromJson(json);
}

/// @nodoc
mixin _$StoreItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_acorn')
  int get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_type')
  String get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_hours')
  int? get durationHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  /// Serializes this StoreItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreItemCopyWith<StoreItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreItemCopyWith<$Res> {
  factory $StoreItemCopyWith(StoreItem value, $Res Function(StoreItem) then) =
      _$StoreItemCopyWithImpl<$Res, StoreItem>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    @JsonKey(name: 'price_acorn') int price,
    @JsonKey(name: 'item_type') String category,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'duration_hours') int? durationHours,
    @JsonKey(name: 'is_active') bool isActive,
    Map<String, dynamic>? metadata,
    int quantity,
  });
}

/// @nodoc
class _$StoreItemCopyWithImpl<$Res, $Val extends StoreItem>
    implements $StoreItemCopyWith<$Res> {
  _$StoreItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? price = null,
    Object? category = null,
    Object? iconUrl = freezed,
    Object? durationHours = freezed,
    Object? isActive = null,
    Object? metadata = freezed,
    Object? quantity = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as int,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            durationHours: freezed == durationHours
                ? _value.durationHours
                : durationHours // ignore: cast_nullable_to_non_nullable
                      as int?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StoreItemImplCopyWith<$Res>
    implements $StoreItemCopyWith<$Res> {
  factory _$$StoreItemImplCopyWith(
    _$StoreItemImpl value,
    $Res Function(_$StoreItemImpl) then,
  ) = __$$StoreItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    @JsonKey(name: 'price_acorn') int price,
    @JsonKey(name: 'item_type') String category,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'duration_hours') int? durationHours,
    @JsonKey(name: 'is_active') bool isActive,
    Map<String, dynamic>? metadata,
    int quantity,
  });
}

/// @nodoc
class __$$StoreItemImplCopyWithImpl<$Res>
    extends _$StoreItemCopyWithImpl<$Res, _$StoreItemImpl>
    implements _$$StoreItemImplCopyWith<$Res> {
  __$$StoreItemImplCopyWithImpl(
    _$StoreItemImpl _value,
    $Res Function(_$StoreItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StoreItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? price = null,
    Object? category = null,
    Object? iconUrl = freezed,
    Object? durationHours = freezed,
    Object? isActive = null,
    Object? metadata = freezed,
    Object? quantity = null,
  }) {
    return _then(
      _$StoreItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as int,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        durationHours: freezed == durationHours
            ? _value.durationHours
            : durationHours // ignore: cast_nullable_to_non_nullable
                  as int?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreItemImpl implements _StoreItem {
  const _$StoreItemImpl({
    required this.id,
    required this.name,
    required this.description,
    @JsonKey(name: 'price_acorn') required this.price,
    @JsonKey(name: 'item_type') required this.category,
    @JsonKey(name: 'icon_url') this.iconUrl,
    @JsonKey(name: 'duration_hours') this.durationHours,
    @JsonKey(name: 'is_active') this.isActive = true,
    final Map<String, dynamic>? metadata,
    this.quantity = 1,
  }) : _metadata = metadata;

  factory _$StoreItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  @JsonKey(name: 'price_acorn')
  final int price;
  @override
  @JsonKey(name: 'item_type')
  final String category;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  @JsonKey(name: 'duration_hours')
  final int? durationHours;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final int quantity;

  @override
  String toString() {
    return 'StoreItem(id: $id, name: $name, description: $description, price: $price, category: $category, iconUrl: $iconUrl, durationHours: $durationHours, isActive: $isActive, metadata: $metadata, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.durationHours, durationHours) ||
                other.durationHours == durationHours) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    price,
    category,
    iconUrl,
    durationHours,
    isActive,
    const DeepCollectionEquality().hash(_metadata),
    quantity,
  );

  /// Create a copy of StoreItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreItemImplCopyWith<_$StoreItemImpl> get copyWith =>
      __$$StoreItemImplCopyWithImpl<_$StoreItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreItemImplToJson(this);
  }
}

abstract class _StoreItem implements StoreItem {
  const factory _StoreItem({
    required final String id,
    required final String name,
    required final String description,
    @JsonKey(name: 'price_acorn') required final int price,
    @JsonKey(name: 'item_type') required final String category,
    @JsonKey(name: 'icon_url') final String? iconUrl,
    @JsonKey(name: 'duration_hours') final int? durationHours,
    @JsonKey(name: 'is_active') final bool isActive,
    final Map<String, dynamic>? metadata,
    final int quantity,
  }) = _$StoreItemImpl;

  factory _StoreItem.fromJson(Map<String, dynamic> json) =
      _$StoreItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  @JsonKey(name: 'price_acorn')
  int get price;
  @override
  @JsonKey(name: 'item_type')
  String get category;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  @JsonKey(name: 'duration_hours')
  int? get durationHours;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  Map<String, dynamic>? get metadata;
  @override
  int get quantity;

  /// Create a copy of StoreItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreItemImplCopyWith<_$StoreItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActiveEffect _$ActiveEffectFromJson(Map<String, dynamic> json) {
  return _ActiveEffect.fromJson(json);
}

/// @nodoc
mixin _$ActiveEffect {
  @JsonKey(name: 'item_type')
  String get itemType => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this ActiveEffect to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActiveEffect
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActiveEffectCopyWith<ActiveEffect> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActiveEffectCopyWith<$Res> {
  factory $ActiveEffectCopyWith(
    ActiveEffect value,
    $Res Function(ActiveEffect) then,
  ) = _$ActiveEffectCopyWithImpl<$Res, ActiveEffect>;
  @useResult
  $Res call({
    @JsonKey(name: 'item_type') String itemType,
    @JsonKey(name: 'expires_at') DateTime expiresAt,
  });
}

/// @nodoc
class _$ActiveEffectCopyWithImpl<$Res, $Val extends ActiveEffect>
    implements $ActiveEffectCopyWith<$Res> {
  _$ActiveEffectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActiveEffect
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? itemType = null, Object? expiresAt = null}) {
    return _then(
      _value.copyWith(
            itemType: null == itemType
                ? _value.itemType
                : itemType // ignore: cast_nullable_to_non_nullable
                      as String,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActiveEffectImplCopyWith<$Res>
    implements $ActiveEffectCopyWith<$Res> {
  factory _$$ActiveEffectImplCopyWith(
    _$ActiveEffectImpl value,
    $Res Function(_$ActiveEffectImpl) then,
  ) = __$$ActiveEffectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'item_type') String itemType,
    @JsonKey(name: 'expires_at') DateTime expiresAt,
  });
}

/// @nodoc
class __$$ActiveEffectImplCopyWithImpl<$Res>
    extends _$ActiveEffectCopyWithImpl<$Res, _$ActiveEffectImpl>
    implements _$$ActiveEffectImplCopyWith<$Res> {
  __$$ActiveEffectImplCopyWithImpl(
    _$ActiveEffectImpl _value,
    $Res Function(_$ActiveEffectImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActiveEffect
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? itemType = null, Object? expiresAt = null}) {
    return _then(
      _$ActiveEffectImpl(
        itemType: null == itemType
            ? _value.itemType
            : itemType // ignore: cast_nullable_to_non_nullable
                  as String,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActiveEffectImpl implements _ActiveEffect {
  const _$ActiveEffectImpl({
    @JsonKey(name: 'item_type') required this.itemType,
    @JsonKey(name: 'expires_at') required this.expiresAt,
  });

  factory _$ActiveEffectImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActiveEffectImplFromJson(json);

  @override
  @JsonKey(name: 'item_type')
  final String itemType;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;

  @override
  String toString() {
    return 'ActiveEffect(itemType: $itemType, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActiveEffectImpl &&
            (identical(other.itemType, itemType) ||
                other.itemType == itemType) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, itemType, expiresAt);

  /// Create a copy of ActiveEffect
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActiveEffectImplCopyWith<_$ActiveEffectImpl> get copyWith =>
      __$$ActiveEffectImplCopyWithImpl<_$ActiveEffectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActiveEffectImplToJson(this);
  }
}

abstract class _ActiveEffect implements ActiveEffect {
  const factory _ActiveEffect({
    @JsonKey(name: 'item_type') required final String itemType,
    @JsonKey(name: 'expires_at') required final DateTime expiresAt,
  }) = _$ActiveEffectImpl;

  factory _ActiveEffect.fromJson(Map<String, dynamic> json) =
      _$ActiveEffectImpl.fromJson;

  @override
  @JsonKey(name: 'item_type')
  String get itemType;
  @override
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt;

  /// Create a copy of ActiveEffect
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActiveEffectImplCopyWith<_$ActiveEffectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AcornPackage _$AcornPackageFromJson(Map<String, dynamic> json) {
  return _AcornPackage.fromJson(json);
}

/// @nodoc
mixin _$AcornPackage {
  String get id => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;

  /// Serializes this AcornPackage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AcornPackage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AcornPackageCopyWith<AcornPackage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AcornPackageCopyWith<$Res> {
  factory $AcornPackageCopyWith(
    AcornPackage value,
    $Res Function(AcornPackage) then,
  ) = _$AcornPackageCopyWithImpl<$Res, AcornPackage>;
  @useResult
  $Res call({String id, int amount, String label});
}

/// @nodoc
class _$AcornPackageCopyWithImpl<$Res, $Val extends AcornPackage>
    implements $AcornPackageCopyWith<$Res> {
  _$AcornPackageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AcornPackage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? amount = null, Object? label = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AcornPackageImplCopyWith<$Res>
    implements $AcornPackageCopyWith<$Res> {
  factory _$$AcornPackageImplCopyWith(
    _$AcornPackageImpl value,
    $Res Function(_$AcornPackageImpl) then,
  ) = __$$AcornPackageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, int amount, String label});
}

/// @nodoc
class __$$AcornPackageImplCopyWithImpl<$Res>
    extends _$AcornPackageCopyWithImpl<$Res, _$AcornPackageImpl>
    implements _$$AcornPackageImplCopyWith<$Res> {
  __$$AcornPackageImplCopyWithImpl(
    _$AcornPackageImpl _value,
    $Res Function(_$AcornPackageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AcornPackage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? amount = null, Object? label = null}) {
    return _then(
      _$AcornPackageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AcornPackageImpl implements _AcornPackage {
  const _$AcornPackageImpl({
    required this.id,
    required this.amount,
    required this.label,
  });

  factory _$AcornPackageImpl.fromJson(Map<String, dynamic> json) =>
      _$$AcornPackageImplFromJson(json);

  @override
  final String id;
  @override
  final int amount;
  @override
  final String label;

  @override
  String toString() {
    return 'AcornPackage(id: $id, amount: $amount, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AcornPackageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, amount, label);

  /// Create a copy of AcornPackage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AcornPackageImplCopyWith<_$AcornPackageImpl> get copyWith =>
      __$$AcornPackageImplCopyWithImpl<_$AcornPackageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AcornPackageImplToJson(this);
  }
}

abstract class _AcornPackage implements AcornPackage {
  const factory _AcornPackage({
    required final String id,
    required final int amount,
    required final String label,
  }) = _$AcornPackageImpl;

  factory _AcornPackage.fromJson(Map<String, dynamic> json) =
      _$AcornPackageImpl.fromJson;

  @override
  String get id;
  @override
  int get amount;
  @override
  String get label;

  /// Create a copy of AcornPackage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AcornPackageImplCopyWith<_$AcornPackageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
