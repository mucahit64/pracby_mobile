import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_client.dart';
import 'package:pracby_mobile/core/api/response_cache.dart';
import 'package:pracby_mobile/core/storage/secure_storage.dart';
import 'package:pracby_mobile/features/auth/data/auth_repository.dart';
import 'package:pracby_mobile/features/auth/data/models/user_model.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';
import 'package:pracby_mobile/features/offline/offline_queue.dart';
import 'package:pracby_mobile/features/store/data/models/store_item.dart';

final authStateProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(
  AuthNotifier.new,
);

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
      // Offline, this is the cached profile (ResponseCache), so a logged-in
      // user isn't turned into a guest by a missing connection.
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
      final response = await repo.login(
        identifier: identifier,
        password: password,
      );
      await ref.read(secureStorageProvider).setToken(response.token);
      await ref.read(responseCacheProvider).clear();
      // Carry guest progress over to the account (docs 10.9).
      await ref.read(guestProvider.notifier).mergeAfterLogin(repo);
      // Login response has no energy / acorns / active exam (docs 3.3).
      return repo.getMe();
    });
  }

  /// [examTypeId] is the exam picked on the register form; a guest's
  /// chosen exam is used otherwise (docs 3.2).
  Future<void> register({
    required String email,
    required String username,
    required String password,
    String? examTypeId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final guest = ref.read(guestProvider.notifier);
      final response = await repo.register(
        email: email,
        username: username,
        password: password,
        examTypeId: examTypeId ?? ref.read(guestProvider).examTypeId,
        guestPayload: guest.registrationPayload(),
      );
      await ref.read(secureStorageProvider).setToken(response.token);
      await ref.read(responseCacheProvider).clear();
      guest.clear();
      // Register response has no role / permissions / energy (docs 3.2).
      return repo.getMe();
    });
  }

  Future<void> logout() async {
    await ref.read(secureStorageProvider).deleteToken();
    await ref.read(responseCacheProvider).clear();
    state = const AsyncValue.data(null);
  }

  /// Applies balances returned by the API (e.g. a store purchase) or changed
  /// offline without refetching `/users/me`. They are also written to the
  /// cached profile so they survive an offline restart.
  void setBalances({int? energy, int? acorns}) {
    final user = state.valueOrNull;
    if (user == null) return;
    final newEnergy = energy ?? user.energy;
    state = AsyncValue.data(
      user.copyWith(
        energy: newEnergy,
        acorns: acorns ?? user.acorns,
        // Keeps the header countdown going after an offline change; like
        // the server, regen starts when energy drops below max.
        nextEnergyAt: newEnergy >= maxEnergy
            ? null
            : user.nextEnergyAt ?? DateTime.now().add(energyRegenInterval),
      ),
    );
    ref.read(responseCacheProvider).patchUser(energy: energy, acorns: acorns);
  }

  /// Energy purchase without a connection (docs 7.5.1): paid from the local
  /// acorn balance and queued for the server. Returns false if the balance
  /// is too low.
  Future<bool> buyEnergyOffline(StoreItem item) async {
    final user = state.valueOrNull;
    if (user == null || user.acorns < item.price) return false;
    final count = (item.metadata?['energy_count'] as num?)?.toInt() ?? 1;
    setBalances(
      acorns: user.acorns - item.price,
      energy: min(maxEnergy, user.energy + count),
    );
    await ref
        .read(offlineQueueProvider)
        .enqueuePurchase(userId: user.id, itemId: item.id);
    return true;
  }

  /// Refetches `/users/me`. A failed request (e.g. offline) keeps the
  /// current user instead of turning the session into an error, which the
  /// router would treat as logged out. A 401 still ends the session through
  /// `ApiClient.onUnauthorized`.
  Future<void> refreshUser() async {
    try {
      final user = await ref.read(authRepositoryProvider).getMe();
      state = AsyncValue.data(user);
    } catch (e, st) {
      if (state.valueOrNull == null) state = AsyncValue.error(e, st);
    }
  }
}
