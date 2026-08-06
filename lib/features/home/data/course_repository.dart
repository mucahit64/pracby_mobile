import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_client.dart';
import 'package:pracby_mobile/core/api/endpoints.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepository(apiClient: ref.watch(apiClientProvider));
});

class CourseRepository {
  const CourseRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<CourseModel>> getCourses({
    String? examTypeId,
    String? moduleId,
  }) async {
    final queryParams = <String, String>{
      if (examTypeId != null) 'exam_type_id': examTypeId,
      if (moduleId != null) 'module_id': moduleId,
    };
    final queryString = queryParams.isNotEmpty
        ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
        : '';
    final response = await _apiClient.get<List<dynamic>>(
      '${Endpoints.courses}$queryString',
    );
    return (response.data ?? [])
        .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CourseModel> getCourseFull(String courseId) async {
    final response = await _apiClient
        .get<Map<String, dynamic>>(Endpoints.courseFull(courseId));
    return CourseModel.fromJson(response.data!);
  }

  Future<List<ModuleModel>> getModules(String examTypeId) async {
    final response = await _apiClient.get<List<dynamic>>(
      '${Endpoints.modules}?exam_type_id=$examTypeId',
    );
    return (response.data ?? [])
        .map((e) => ModuleModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
