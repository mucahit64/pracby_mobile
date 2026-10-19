import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_client.dart';
import 'package:pracby_mobile/core/api/endpoints.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';

final examGroupsRepositoryProvider = Provider<ExamGroupsRepository>((ref) {
  return ExamGroupsRepository(apiClient: ref.watch(apiClientProvider));
});

final examGroupsProvider = FutureProvider.autoDispose<List<ExamGroupModel>>((
  ref,
) {
  return ref.watch(examGroupsRepositoryProvider).getExamGroups();
});

class ExamGroupsRepository {
  const ExamGroupsRepository({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<ExamGroupModel>> getExamGroups() async {
    final response = await _apiClient.get<List<dynamic>>(Endpoints.examGroups);
    return (response.data ?? [])
        .map((e) => ExamGroupModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
