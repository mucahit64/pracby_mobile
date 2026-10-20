import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/profile/data/models/enrollment_model.dart';
import 'package:pracby_mobile/features/profile/data/models/streak_day.dart';
import 'package:pracby_mobile/features/profile/data/models/user_stats.dart';
import 'package:pracby_mobile/features/profile/data/user_repository.dart';

/// The logged-in user's ID. The providers below depend on this rather than
/// on the whole user: watching the user rebuilt them — and showed a loading
/// state that reset the lesson map's scroll — whenever energy or acorns
/// changed. They still reload when the account changes; after a quiz they
/// are invalidated explicitly (see [refreshAfterQuiz]).
final _userIdProvider = Provider<String?>(
  (ref) => ref.watch(authStateProvider.select((s) => s.valueOrNull?.id)),
);

/// Stats, streak and achievements change when a quiz is finished.
void refreshAfterQuiz(Ref ref) {
  ref
    ..invalidate(userStatsProvider)
    ..invalidate(streakHistoryProvider)
    ..invalidate(achievementsProvider);
}

final userStatsProvider = FutureProvider<UserStats>((ref) async {
  if (ref.watch(_userIdProvider) == null) return const UserStats();
  return ref.watch(userRepositoryProvider).getStats();
});

final achievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  if (ref.watch(_userIdProvider) == null) return [];
  return ref.watch(userRepositoryProvider).getAchievements();
});

final enrollmentsProvider = FutureProvider<List<EnrollmentModel>>((ref) async {
  if (ref.watch(_userIdProvider) == null) return [];
  return ref.watch(userRepositoryProvider).getEnrollments();
});

/// This week's days (Mon–Sun) with quiz activity. Empty for guests, or when
/// it can't be loaded: the streak count still shows.
final streakHistoryProvider = FutureProvider<List<StreakDay>>((ref) async {
  if (ref.watch(_userIdProvider) == null) return [];
  try {
    return await ref.watch(userRepositoryProvider).getStreakHistory();
  } catch (_) {
    return [];
  }
});
