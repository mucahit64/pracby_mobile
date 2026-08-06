import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_item.freezed.dart';
part 'store_item.g.dart';

@freezed
class StoreItem with _$StoreItem {
  const factory StoreItem({
    required String id,
    required String name,
    required String description,
    @JsonKey(name: 'price_acorn') required int price,
    @JsonKey(name: 'item_type') required String category,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'duration_hours') int? durationHours,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    Map<String, dynamic>? metadata,
    @Default(1) int quantity,
  }) = _StoreItem;

  factory StoreItem.fromJson(Map<String, dynamic> json) =>
      _$StoreItemFromJson(json);
}

@freezed
class ActiveEffect with _$ActiveEffect {
  const factory ActiveEffect({
    @JsonKey(name: 'item_type') required String itemType,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
  }) = _ActiveEffect;

  factory ActiveEffect.fromJson(Map<String, dynamic> json) =>
      _$ActiveEffectFromJson(json);
}

@freezed
class AcornPackage with _$AcornPackage {
  const factory AcornPackage({
    required String id,
    required int amount,
    required String label,
  }) = _AcornPackage;

  factory AcornPackage.fromJson(Map<String, dynamic> json) =>
      _$AcornPackageFromJson(json);
}
