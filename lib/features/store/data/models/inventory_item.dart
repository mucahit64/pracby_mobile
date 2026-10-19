/// An owned store item, from `GET /api/store/inventory` (docs 12.2).
///
/// The inventory rows have no price, so they are not `StoreItem`s.
class InventoryItem {
  const InventoryItem({
    required this.id,
    required this.itemId,
    required this.quantity,
    required this.name,
    required this.itemType,
    this.description,
    this.iconUrl,
    this.durationHours,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
    id: json['id'] as String,
    itemId: json['item_id'] as String,
    quantity: (json['quantity'] as num).toInt(),
    name: json['name'] as String,
    itemType: json['item_type'] as String,
    description: json['description'] as String?,
    iconUrl: json['icon_url'] as String?,
    durationHours: (json['duration_hours'] as num?)?.toInt(),
  );

  /// `user_items.id`.
  final String id;

  /// `store_items.id`, the ID `POST /api/store/activate/:itemId` takes.
  final String itemId;
  final int quantity;
  final String name;
  final String itemType;
  final String? description;

  /// An emoji.
  final String? iconUrl;

  /// Timed items (effects) can be activated; others can't (docs 12.5).
  final int? durationHours;

  bool get canActivate => durationHours != null && quantity > 0;
}
