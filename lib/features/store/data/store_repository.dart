import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_client.dart';
import 'package:pracby_mobile/core/api/endpoints.dart';
import 'package:pracby_mobile/features/store/data/models/store_item.dart';

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  return StoreRepository(apiClient: ref.watch(apiClientProvider));
});

class StoreRepository {
  const StoreRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<StoreItem>> getItems() async {
    final response = await _apiClient.get<List<dynamic>>(Endpoints.storeItems);
    return (response.data ?? [])
        .map((e) => StoreItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<StoreItem>> getInventory() async {
    final response =
        await _apiClient.get<List<dynamic>>(Endpoints.storeInventory);
    return (response.data ?? [])
        .map((e) => StoreItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ActiveEffect>> getActiveEffects() async {
    final response =
        await _apiClient.get<List<dynamic>>(Endpoints.storeEffects);
    return (response.data ?? [])
        .map((e) => ActiveEffect.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> purchase({
    required String itemId,
    int quantity = 1,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      Endpoints.storePurchase,
      data: {'itemId': itemId, 'quantity': quantity},
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> activate({required String itemId}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      Endpoints.storeActivate(itemId),
    );
    return response.data!;
  }

  Future<List<AcornPackage>> getAcornPackages() async {
    final response =
        await _apiClient.get<List<dynamic>>(Endpoints.acornPackages);
    return (response.data ?? [])
        .map((e) => AcornPackage.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
