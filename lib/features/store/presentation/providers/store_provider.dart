import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/features/store/data/models/store_item.dart';
import 'package:pracby_mobile/features/store/data/store_repository.dart';

final storeItemsProvider = FutureProvider<List<StoreItem>>((ref) async {
  return ref.watch(storeRepositoryProvider).getItems();
});

final storeInventoryProvider = FutureProvider<List<StoreItem>>((ref) async {
  return ref.watch(storeRepositoryProvider).getInventory();
});

final activeEffectsProvider = FutureProvider<List<ActiveEffect>>((ref) async {
  return ref.watch(storeRepositoryProvider).getActiveEffects();
});
