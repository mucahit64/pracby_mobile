import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_client.dart';
import 'package:pracby_mobile/core/api/endpoints.dart';
import 'package:pracby_mobile/features/friends/data/models/friendship_model.dart';

final friendsRepositoryProvider = Provider<FriendsRepository>((ref) {
  return FriendsRepository(apiClient: ref.watch(apiClientProvider));
});

class FriendsRepository {
  const FriendsRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<FriendshipModel>> getFriends() async {
    final response = await _apiClient.get<List<dynamic>>(Endpoints.friends);
    return (response.data ?? [])
        .map((e) => FriendshipModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<FriendshipModel>> getRequests() async {
    final response =
        await _apiClient.get<List<dynamic>>(Endpoints.friendRequests);
    return (response.data ?? [])
        .map((e) => FriendshipModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> sendRequest({required String username}) async {
    await _apiClient.post<Map<String, dynamic>>(
      Endpoints.friendRequest,
      data: {'username': username},
    );
  }

  Future<void> respondToRequest({
    required String id,
    required String action, // "accept" or "reject"
  }) async {
    await _apiClient.patch<Map<String, dynamic>>(
      Endpoints.friendRespond(id),
      data: {'action': action},
    );
  }

  Future<void> removeFriend(String id) async {
    await _apiClient.delete<Map<String, dynamic>>(
      Endpoints.friendRemove(id),
    );
  }
}
