import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/leaderboard/data/leaderboard_repository.dart';
import 'package:pracby_mobile/features/leaderboard/data/models/leaderboard_entry.dart';

final leaderboardProvider = FutureProvider.family<List<LeaderboardEntry>, String>(
  (ref, league) async {
    // Auth-only endpoint; guests see the empty state (docs 10.2).
    final isLoggedIn =
        ref.watch(authStateProvider.select((s) => s.valueOrNull != null));
    if (!isLoggedIn) return [];
    return ref.watch(leaderboardRepositoryProvider).getLeaderboard(
          league: league,
        );
  },
);
