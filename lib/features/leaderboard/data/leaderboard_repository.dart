import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_client.dart';
import 'package:pracby_mobile/core/api/endpoints.dart';
import 'package:pracby_mobile/features/leaderboard/data/models/leaderboard_entry.dart';

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  return LeaderboardRepository(apiClient: ref.watch(apiClientProvider));
});

class LeaderboardRepository {
  const LeaderboardRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<LeaderboardEntry>> getLeaderboard({
    required String league,
  }) async {
    final response = await _apiClient.get<List<dynamic>>(
      Endpoints.leaderboard,
      queryParameters: {'league': league},
    );
    return (response.data ?? [])
        .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
