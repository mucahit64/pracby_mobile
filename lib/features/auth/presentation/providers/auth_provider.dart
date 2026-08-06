import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/storage/secure_storage.dart';
import 'package:pracby_mobile/features/auth/data/auth_repository.dart';
import 'package:pracby_mobile/features/auth/data/models/user_model.dart';

final authStateProvider =
    AsyncNotifierProvider<AuthNotifier, UserModel?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    final token = await ref.read(secureStorageProvider).getToken();
    if (token == null) return null;
    try {
      return await ref.read(authRepositoryProvider).getMe();
    } catch (_) {
      await ref.read(secureStorageProvider).deleteToken();
      return null;
    }
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final response = await ref.read(authRepositoryProvider).login(
            identifier: identifier,
            password: password,
          );
      await ref.read(secureStorageProvider).setToken(response.token);
      return response.user;
    });
  }

  Future<void> register({
    required String email,
    required String username,
    required String password,
    String? examTypeId,
    Map<String, dynamic>? guestData,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final response = await ref.read(authRepositoryProvider).register(
            email: email,
            username: username,
            password: password,
            examTypeId: examTypeId,
            guestData: guestData,
          );
      await ref.read(secureStorageProvider).setToken(response.token);
      return response.user;
    });
  }

  Future<void> logout() async {
    await ref.read(secureStorageProvider).deleteToken();
    state = const AsyncValue.data(null);
  }

  Future<void> refreshUser() async {
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).getMe(),
    );
  }
}
