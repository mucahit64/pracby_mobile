import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';
import 'package:pracby_mobile/features/home/data/course_repository.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';

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

/// Lesson map data. For guests the API sends no progress, so local results
/// are overlaid (docs 10.6); it rebuilds when guest progress changes.
final courseFullProvider =
    FutureProvider.autoDispose.family<CourseModel, String>((ref, courseId) async {
  final isLoggedIn = ref.watch(
    authStateProvider.select((s) => s.valueOrNull != null),
  );
  final course =
      await ref.watch(courseRepositoryProvider).getCourseFull(courseId);
  if (isLoggedIn) return course;
  ref.watch(
    guestProvider.select(
      (g) => (g.quizResults.length, g.claimedRewardStepIds.length),
    ),
  );
  return ref.read(guestProvider.notifier).overlayProgress(course);
});
