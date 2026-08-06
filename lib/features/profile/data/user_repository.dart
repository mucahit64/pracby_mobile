import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_client.dart';
import 'package:pracby_mobile/core/api/endpoints.dart';
import 'package:pracby_mobile/features/profile/data/models/enrollment_model.dart';
import 'package:pracby_mobile/features/profile/data/models/user_stats.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(apiClient: ref.watch(apiClientProvider));
});

class UserRepository {
  const UserRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<UserStats> getStats() async {
    final response =
        await _apiClient.get<Map<String, dynamic>>(Endpoints.myStats);
    return UserStats.fromJson(response.data!);
  }

  Future<List<Achievement>> getAchievements() async {
    final response =
        await _apiClient.get<List<dynamic>>(Endpoints.myAchievements);
    return (response.data ?? [])
        .map((e) => Achievement.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<StreakHistory>> getStreakHistory() async {
    final response =
        await _apiClient.get<List<dynamic>>(Endpoints.myStreakHistory);
    return (response.data ?? [])
        .map((e) => StreakHistory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<EnrollmentModel>> getEnrollments() async {
    final response =
        await _apiClient.get<List<dynamic>>(Endpoints.myEnrollments);
    return (response.data ?? [])
        .map((e) => EnrollmentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addEnrollment(String examTypeId) async {
    await _apiClient.post<Map<String, dynamic>>(
      Endpoints.myEnrollments,
      data: {'exam_type_id': examTypeId},
    );
  }

  Future<void> removeEnrollment(String examTypeId) async {
    await _apiClient.delete<Map<String, dynamic>>(
      '${Endpoints.myEnrollments}/$examTypeId',
    );
  }

  Future<void> updateActiveExam(String examTypeId) async {
    await _apiClient.patch<Map<String, dynamic>>(
      Endpoints.activeExam,
      data: {'exam_type_id': examTypeId},
    );
  }

  Future<void> updateProfile({
    String? username,
    String? avatarUrl,
    int? dailyGoalXp,
    String? currentPassword,
    String? newPassword,
  }) async {
    await _apiClient.patch<Map<String, dynamic>>(
      Endpoints.me,
      data: {
        if (username != null) 'username': username,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        if (dailyGoalXp != null) 'daily_goal_xp': dailyGoalXp,
        if (currentPassword != null) 'current_password': currentPassword,
        if (newPassword != null) 'new_password': newPassword,
      },
    );
  }
}
