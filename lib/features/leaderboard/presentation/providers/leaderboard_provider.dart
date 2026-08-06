import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/features/leaderboard/data/leaderboard_repository.dart';
import 'package:pracby_mobile/features/leaderboard/data/models/leaderboard_entry.dart';

final leaderboardProvider = FutureProvider.family<List<LeaderboardEntry>, String>(
  (ref, league) async {
    return ref.watch(leaderboardRepositoryProvider).getLeaderboard(
          league: league,
        );
  },
);
