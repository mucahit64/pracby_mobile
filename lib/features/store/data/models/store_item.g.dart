// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoreItemImpl _$$StoreItemImplFromJson(Map<String, dynamic> json) =>
    _$StoreItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price_acorn'] as num).toInt(),
      category: json['item_type'] as String,
      iconUrl: json['icon_url'] as String?,
      durationHours: (json['duration_hours'] as num?)?.toInt(),
      isActive: json['is_active'] as bool? ?? true,
      metadata: json['metadata'] as Map<String, dynamic>?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$StoreItemImplToJson(_$StoreItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price_acorn': instance.price,
      'item_type': instance.category,
      'icon_url': instance.iconUrl,
      'duration_hours': instance.durationHours,
      'is_active': instance.isActive,
      'metadata': instance.metadata,
      'quantity': instance.quantity,
    };

_$ActiveEffectImpl _$$ActiveEffectImplFromJson(Map<String, dynamic> json) =>
    _$ActiveEffectImpl(
      itemType: json['item_type'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$$ActiveEffectImplToJson(_$ActiveEffectImpl instance) =>
    <String, dynamic>{
      'item_type': instance.itemType,
      'expires_at': instance.expiresAt.toIso8601String(),
    };

_$AcornPackageImpl _$$AcornPackageImplFromJson(Map<String, dynamic> json) =>
    _$AcornPackageImpl(
      id: json['id'] as String,
      amount: (json['amount'] as num).toInt(),
      label: json['label'] as String,
    );

Map<String, dynamic> _$$AcornPackageImplToJson(_$AcornPackageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'label': instance.label,
    };
