import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_client.dart';
import 'package:pracby_mobile/core/api/endpoints.dart';
import 'package:pracby_mobile/features/auth/data/models/auth_response.dart';
import 'package:pracby_mobile/features/auth/data/models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(apiClient: ref.watch(apiClientProvider));
});

class AuthRepository {
  const AuthRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<AuthResponse> login({
    required String identifier,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      Endpoints.login,
      data: {'identifier': identifier, 'password': password},
    );
    return AuthResponse.fromJson(response.data!);
  }

  Future<AuthResponse> register({
    required String email,
    required String username,
    required String password,
    String? examTypeId,
    Map<String, dynamic> guestPayload = const {},
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      Endpoints.register,
      data: {
        'email': email,
        'username': username,
        'password': password,
        // An empty string would be a 400 (docs 3.2).
        if (examTypeId != null && examTypeId.isNotEmpty)
          'exam_type_id': examTypeId,
        // acorn_balance, energy, guest_data (docs 10.8).
        ...guestPayload,
      },
    );
    return AuthResponse.fromJson(response.data!);
  }

  Future<bool> checkEmail(String email) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      Endpoints.checkEmail,
      queryParameters: {'email': email},
    );
    return response.data?['available'] as bool? ?? false;
  }

  Future<bool> checkUsername(String username) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      Endpoints.checkUsername,
      queryParameters: {'username': username},
    );
    return response.data?['available'] as bool? ?? false;
  }

  Future<void> forgotPassword({required String email}) async {
    await _apiClient.post<Map<String, dynamic>>(
      Endpoints.forgotPassword,
      data: {'email': email},
    );
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _apiClient.post<Map<String, dynamic>>(
      Endpoints.resetPassword,
      data: {'token': token, 'password': newPassword},
    );
  }

  Future<void> mergeGuestProgress({
    required List<Map<String, dynamic>> quizResults,
    required List<String> claimedRewards,
    required int earnedAcorns,
  }) async {
    await _apiClient.post<Map<String, dynamic>>(
      Endpoints.mergeGuestProgress,
      data: {
        'quiz_results': quizResults,
        'claimed_rewards': claimedRewards,
        'earned_acorns': earnedAcorns,
      },
    );
  }

  Future<UserModel> getMe() async {
    final response =
        await _apiClient.get<Map<String, dynamic>>(Endpoints.me);
    return UserModel.fromJson(response.data!);
  }
}
