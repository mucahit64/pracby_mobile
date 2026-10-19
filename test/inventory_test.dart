import 'package:flutter_test/flutter_test.dart';
import 'package:pracby_mobile/features/store/data/models/inventory_item.dart';
import 'package:pracby_mobile/features/store/presentation/widgets/inventory_section.dart';

void main() {
  group('InventoryItem (GET /api/store/inventory)', () {
    // A row as the API returns it: no price, store item ID in `item_id`.
    Map<String, dynamic> row({int quantity = 2, int? durationHours = 1}) => {
      'id': 'user-item-1',
      'item_id': 'store-item-1',
      'quantity': quantity,
      'purchased_at': '2026-10-19T10:00:00.000Z',
      'name': 'XP Boost',
      'description': '1 saat boyunca 2x XP',
      'icon_url': '⚡',
      'item_type': 'xp_boost',
      'duration_hours': durationHours,
    };

    test('parses a row without a price', () {
      final item = InventoryItem.fromJson(row());
      expect(item.itemId, 'store-item-1');
      expect(item.quantity, 2);
      expect(item.iconUrl, '⚡');
      expect(item.canActivate, isTrue);
    });

    test('items without a duration or out of stock cannot be activated', () {
      expect(
        InventoryItem.fromJson(row(durationHours: null)).canActivate,
        isFalse,
      );
      expect(InventoryItem.fromJson(row(quantity: 0)).canActivate, isFalse);
    });
  });

  group('effect labels and remaining time (web store.vue)', () {
    test('labels known effects in Turkish', () {
      expect(effectLabel('unlimited_energy'), '🔋 Sınırsız Enerji');
      expect(effectLabel('unknown'), 'unknown');
    });

    test('formats hours and minutes left', () {
      final now = DateTime.now();
      expect(
        formatRemaining(
          now.add(const Duration(hours: 7, minutes: 42, seconds: 30)),
        ),
        '7s 42dk',
      );
      expect(
        formatRemaining(now.add(const Duration(minutes: 15, seconds: 30))),
        '15dk',
      );
      expect(
        formatRemaining(now.subtract(const Duration(minutes: 1))),
        'Bitti',
      );
    });
  });
}
