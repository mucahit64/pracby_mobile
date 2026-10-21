import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';
import 'package:pracby_mobile/features/home/data/course_repository.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';
import 'package:pracby_mobile/features/offline/offline_queue.dart';

final coursesProvider = FutureProvider<List<CourseModel>>((ref) async {
  return ref.watch(courseRepositoryProvider).getCourses();
});

final coursesByExamProvider =
    FutureProvider.family<List<CourseModel>, String>((ref, examTypeId) async {
  return ref.watch(courseRepositoryProvider).getCourses(examTypeId: examTypeId);
});

final coursesByModuleProvider =
    FutureProvider.family<List<CourseModel>, (String, String)>((ref, params) async {
  return ref.watch(courseRepositoryProvider).getCourses(
    examTypeId: params.$1,
    moduleId: params.$2,
  );
});

final modulesProvider =
    FutureProvider.family<List<ModuleModel>, String>((ref, examTypeId) async {
  return ref.watch(courseRepositoryProvider).getModules(examTypeId);
});

/// Chests opened on this device that the map data may not show yet. The map
/// shows them opened at once: waiting for the claim request and the map
/// reload left the next lesson locked for a few seconds, so taps on it did
/// nothing. Cleared when the user changes.
final openedChestsProvider = StateProvider<Set<String>>((ref) {
  ref.watch(authStateProvider.select((s) => s.valueOrNull?.id));
  return const {};
});

/// Lesson map data. For guests the API sends no progress, so local results
/// are overlaid (docs 10.6); it rebuilds when guest progress changes. A
/// member's lessons and chests done offline are overlaid from the offline
/// queue until the server has them (docs 7.5.1).
final courseFullProvider =
    FutureProvider.autoDispose.family<CourseModel, String>((ref, courseId) async {
  final userId = ref.watch(
    authStateProvider.select((s) => s.valueOrNull?.id),
  );
  final course =
      await ref.watch(courseRepositoryProvider).getCourseFull(courseId);
  if (userId != null) {
    return ref.watch(offlineQueueProvider).overlayProgress(course, userId);
  }
  ref.watch(
    guestProvider.select(
      (g) => (g.quizResults.length, g.claimedRewardStepIds.length),
    ),
  );
  return ref.read(guestProvider.notifier).overlayProgress(course);
});
