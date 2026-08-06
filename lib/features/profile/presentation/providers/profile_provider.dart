import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/profile/data/models/enrollment_model.dart';
import 'package:pracby_mobile/features/profile/data/models/user_stats.dart';
import 'package:pracby_mobile/features/profile/data/user_repository.dart';

final userStatsProvider = FutureProvider<UserStats>((ref) async {
  // Rebuild when auth state changes so stale data from a previous user is cleared
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const UserStats();
  return ref.watch(userRepositoryProvider).getStats();
});

final achievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return [];
  return ref.watch(userRepositoryProvider).getAchievements();
});

final enrollmentsProvider = FutureProvider<List<EnrollmentModel>>((ref) async {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return [];
  return ref.watch(userRepositoryProvider).getEnrollments();
});
