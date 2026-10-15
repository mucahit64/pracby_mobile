import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_client.dart';
import 'package:pracby_mobile/core/api/endpoints.dart';
import 'package:pracby_mobile/features/quiz/data/models/question_model.dart';
import 'package:pracby_mobile/features/quiz/data/models/quiz_answer.dart';
import 'package:pracby_mobile/features/quiz/data/models/quiz_session.dart';

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository(apiClient: ref.watch(apiClientProvider));
});

/// Parameters that identify a quiz, same as the web route
/// `/quiz/:topicId?stepId&testId&sessionType`.
typedef QuizParams = ({
  String topicId,
  String? stepId,
  String? testId,
  String? sessionType,
});

class QuizRepository {
  const QuizRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// `POST /api/quiz/start` (docs 7.2). Returns the session ID and questions.
  Future<({String sessionId, List<QuestionModel> questions})> start(
    QuizParams params,
  ) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      Endpoints.quizStart,
      data: {
        'topicId': params.topicId,
        if (params.stepId != null) 'stepId': params.stepId,
        if (params.testId != null) 'testId': params.testId,
        if (params.sessionType != null) 'sessionType': params.sessionType,
      },
    );
    final data = response.data!;
    return (
      sessionId: (data['session'] as Map<String, dynamic>)['id'] as String,
      questions: _parseQuestions(data['questions']),
    );
  }

  /// `GET /api/quiz/guest-start` (docs 7.1). No session is created.
  Future<List<QuestionModel>> guestStart(QuizParams params) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      Endpoints.quizGuestStart,
      queryParameters: {
        'topicId': params.topicId,
        if (params.stepId != null) 'stepId': params.stepId,
        if (params.testId != null) 'testId': params.testId,
        if (params.sessionType != null) 'sessionType': params.sessionType,
      },
    );
    return _parseQuestions(response.data!['questions']);
  }

  /// `POST /api/quiz/:sessionId/finish-bulk` (docs 7.4). Idempotent.
  Future<QuizFinishResult> finishBulk({
    required String sessionId,
    required List<QuizAnswer> answers,
    bool skipRewards = false,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      Endpoints.quizFinishBulk(sessionId),
      data: {
        'answers': answers.map((a) => a.toJson()).toList(),
        'skip_rewards': skipRewards,
      },
    );
    return QuizFinishResult.fromJson(response.data!);
  }

  /// `POST /api/quiz/reward/:stepId/claim` (docs 7.7).
  Future<Map<String, dynamic>> claimReward({required String stepId}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      Endpoints.quizRewardClaim(stepId),
    );
    return response.data!;
  }

  /// Report a question as a member (docs 9.1) or, with [guestId], as a guest
  /// (docs 9.2).
  Future<void> reportQuestion({
    required String questionId,
    required String reason,
    String? description,
    String? guestId,
  }) async {
    await _apiClient.post<Map<String, dynamic>>(
      guestId == null
          ? Endpoints.quizReportQuestion
          : Endpoints.quizGuestReportQuestion,
      data: {
        'questionId': questionId,
        'reason': reason,
        if (description != null && description.isNotEmpty)
          'description': description,
        if (guestId != null) 'guestId': guestId,
      },
    );
  }

  List<QuestionModel> _parseQuestions(Object? raw) => (raw! as List)
      .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
      .toList();
}
