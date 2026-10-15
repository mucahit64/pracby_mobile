import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/store/data/models/store_item.dart';
import 'package:pracby_mobile/features/store/data/store_repository.dart';

final storeItemsProvider = FutureProvider<List<StoreItem>>((ref) async {
  return ref.watch(storeRepositoryProvider).getItems();
});

final storeInventoryProvider = FutureProvider<List<StoreItem>>((ref) async {
  return ref.watch(storeRepositoryProvider).getInventory();
});

final activeEffectsProvider = FutureProvider<List<ActiveEffect>>((ref) async {
  // Auth-only endpoint; guests have no effects (docs 12.1).
  final isLoggedIn =
      ref.watch(authStateProvider.select((s) => s.valueOrNull != null));
  if (!isLoggedIn) return [];
  return ref.watch(storeRepositoryProvider).getActiveEffects();
});
