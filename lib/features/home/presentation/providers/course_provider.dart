import 'package:flutter_riverpod/flutter_riverpod.dart';
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

final courseFullProvider =
    FutureProvider.autoDispose.family<CourseModel, String>((ref, courseId) async {
  return ref.watch(courseRepositoryProvider).getCourseFull(courseId);
});
