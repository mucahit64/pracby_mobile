import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/store/data/models/inventory_item.dart';
import 'package:pracby_mobile/features/store/data/models/store_item.dart';
import 'package:pracby_mobile/features/store/data/store_repository.dart';

final storeItemsProvider = FutureProvider<List<StoreItem>>((ref) async {
  return ref.watch(storeRepositoryProvider).getItems();
});

/// Owned items still in stock. Used-up rows (quantity 0) stay in the API
/// response and are left out. Auth-only; guests own nothing.
final storeInventoryProvider = FutureProvider<List<InventoryItem>>((ref) async {
  final isLoggedIn = ref.watch(
    authStateProvider.select((s) => s.valueOrNull != null),
  );
  if (!isLoggedIn) return [];
  final items = await ref.watch(storeRepositoryProvider).getInventory();
  return items.where((i) => i.quantity > 0).toList();
});

final activeEffectsProvider = FutureProvider<List<ActiveEffect>>((ref) async {
  // Auth-only endpoint; guests have no effects (docs 12.1).
  final isLoggedIn = ref.watch(
    authStateProvider.select((s) => s.valueOrNull != null),
  );
  if (!isLoggedIn) return [];
  return ref.watch(storeRepositoryProvider).getActiveEffects();
});

/// An unlimited-energy effect is running (members only).
final unlimitedEnergyProvider = Provider<bool>((ref) {
  final effects = ref.watch(activeEffectsProvider).valueOrNull ?? const [];
  final now = DateTime.now();
  return effects.any(
    (e) => e.itemType == 'unlimited_energy' && e.expiresAt.isAfter(now),
  );
});
