import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_client.dart';
import 'package:pracby_mobile/core/storage/secure_storage.dart';
import 'package:pracby_mobile/features/auth/data/auth_repository.dart';
import 'package:pracby_mobile/features/auth/data/models/user_model.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';

final authStateProvider =
    AsyncNotifierProvider<AuthNotifier, UserModel?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    // A 401 on any authenticated request ends the session (docs 2).
    final sub = ref
        .read(apiClientProvider)
        .onUnauthorized
        .listen((_) => state = const AsyncValue.data(null));
    ref.onDispose(sub.cancel);

    final token = await ref.read(secureStorageProvider).getToken();
    if (token == null) return null;
    try {
      return await ref.read(authRepositoryProvider).getMe();
    } catch (_) {
      return null;
    }
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final response =
          await repo.login(identifier: identifier, password: password);
      await ref.read(secureStorageProvider).setToken(response.token);
      // Carry guest progress over to the account (docs 10.9).
      await ref.read(guestProvider.notifier).mergeAfterLogin(repo);
      // Login response has no energy / acorns / active exam (docs 3.3).
      return repo.getMe();
    });
  }

  Future<void> register({
    required String email,
    required String username,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final guest = ref.read(guestProvider.notifier);
      final response = await repo.register(
        email: email,
        username: username,
        password: password,
        examTypeId: ref.read(guestProvider).examTypeId,
        guestPayload: guest.registrationPayload(),
      );
      await ref.read(secureStorageProvider).setToken(response.token);
      guest.clear();
      // Register response has no role / permissions / energy (docs 3.2).
      return repo.getMe();
    });
  }

  Future<void> logout() async {
    await ref.read(secureStorageProvider).deleteToken();
    state = const AsyncValue.data(null);
  }

  /// Applies balances returned by the API (e.g. a store purchase) without
  /// refetching `/users/me`.
  void setBalances({int? energy, int? acorns}) {
    final user = state.valueOrNull;
    if (user == null) return;
    state = AsyncValue.data(
      user.copyWith(
        energy: energy ?? user.energy,
        acorns: acorns ?? user.acorns,
      ),
    );
  }

  Future<void> refreshUser() async {
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).getMe(),
    );
  }
}
