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

  /// `PATCH /api/users/me` (docs 11.5). Only the given fields are sent.
  /// Field names are camelCase: the API drops unknown (e.g. snake_case) keys
  /// without an error. [currentPassword] is required with [email] or
  /// [newPassword].
  Future<void> updateProfile({
    String? username,
    String? email,
    String? currentPassword,
    String? newPassword,
    String? avatarUrl,
    int? dailyGoalXp,
  }) async {
    await _apiClient.patch<Map<String, dynamic>>(
      Endpoints.me,
      data: {
        if (username != null) 'username': username,
        if (email != null) 'email': email,
        if (currentPassword != null) 'currentPassword': currentPassword,
        if (newPassword != null) 'newPassword': newPassword,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
        // The API takes the goal as a string enum: "10" | "20" | "50" | "100".
        if (dailyGoalXp != null) 'dailyGoalXp': '$dailyGoalXp',
      },
    );
  }
}
