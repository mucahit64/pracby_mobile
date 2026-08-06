import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_client.dart';
import 'package:pracby_mobile/core/api/endpoints.dart';
import 'package:pracby_mobile/features/quiz/data/models/question_model.dart';
import 'package:pracby_mobile/features/quiz/data/models/quiz_answer.dart';
import 'package:pracby_mobile/features/quiz/data/models/quiz_session.dart';

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository(apiClient: ref.watch(apiClientProvider));
});

class QuizRepository {
  const QuizRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<QuizSession> startQuiz({
    required String stepId,
    required String topicId,
    String sessionType = 'lesson',
    String? testId,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      Endpoints.quizStart,
      data: {
        'topicId': topicId,
        'stepId': stepId,
        'sessionType': sessionType,
        if (testId != null) 'testId': testId,
      },
    );
    final data = response.data!;
    final sessionData = data['session'] as Map<String, dynamic>;
    final questionList = (data['questions'] as List<dynamic>)
        .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
        .toList();
    return QuizSession(
      id: sessionData['id'] as String,
      stepId: sessionData['step_id'] as String?,
      topicId: sessionData['topic_id'] as String?,
      testId: sessionData['test_id'] as String?,
      sessionType: sessionData['session_type'] as String? ?? 'lesson',
      isFinalTest: sessionData['is_final_test'] as bool? ?? false,
      questions: questionList,
      totalQuestions: (sessionData['total_questions'] as num?)?.toInt() ??
          questionList.length,
    );
  }

  Future<QuizSession> guestStartQuiz({
    required String topicId,
    String? stepId,
    String? testId,
    String sessionType = 'lesson',
  }) async {
    final queryParams = <String, String>{
      'topicId': topicId,
      'sessionType': sessionType,
      if (stepId != null) 'stepId': stepId,
      if (testId != null) 'testId': testId,
    };
    final queryString = queryParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    final response = await _apiClient.get<Map<String, dynamic>>(
      '${Endpoints.quizGuestStart}?$queryString',
    );
    final data = response.data!;
    final questionList = (data['questions'] as List<dynamic>)
        .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
        .toList();
    return QuizSession(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      questions: questionList,
      totalQuestions: questionList.length,
    );
  }

  Future<Map<String, dynamic>> submitAnswer({
    required String quizId,
    required String questionId,
    required String answerId,
    required int timeSpent,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      Endpoints.quizAnswer(quizId),
      data: {
        'questionId': questionId,
        'answerId': answerId,
        'timeSpent': timeSpent,
        'answeredAt': DateTime.now().toIso8601String(),
      },
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> submitTextAnswer({
    required String quizId,
    required String questionId,
    required String textAnswer,
    required int timeSpent,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      Endpoints.quizAnswer(quizId),
      data: {
        'questionId': questionId,
        'textAnswer': textAnswer,
        'timeSpent': timeSpent,
        'answeredAt': DateTime.now().toIso8601String(),
      },
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> submitFlashcardAnswer({
    required String quizId,
    required String questionId,
    required bool isCorrect,
    required int timeSpent,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      Endpoints.quizAnswer(quizId),
      data: {
        'questionId': questionId,
        'isCorrect': isCorrect,
        'timeSpent': timeSpent,
        'answeredAt': DateTime.now().toIso8601String(),
      },
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> submitMatchingAnswer({
    required String quizId,
    required String questionId,
    required List<MatchingAnswerPair> matchingAnswer,
    required int timeSpent,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      Endpoints.quizAnswer(quizId),
      data: {
        'questionId': questionId,
        'matchingAnswer': matchingAnswer.map((p) => p.toJson()).toList(),
        'timeSpent': timeSpent,
        'answeredAt': DateTime.now().toIso8601String(),
      },
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> submitOrderingAnswer({
    required String quizId,
    required String questionId,
    required List<int> orderedIndices,
    required int timeSpent,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      Endpoints.quizAnswer(quizId),
      data: {
        'questionId': questionId,
        'orderedIndices': orderedIndices,
        'timeSpent': timeSpent,
        'answeredAt': DateTime.now().toIso8601String(),
      },
    );
    return response.data!;
  }

  Future<QuizFinishResult> finishBulk({
    required String quizId,
    required List<QuizAnswer> answers,
    bool skipRewards = false,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      Endpoints.quizFinishBulk(quizId),
      data: {
        'answers': answers.map((a) => a.toJson()).toList(),
        if (skipRewards) 'skip_rewards': true,
      },
    );
    return QuizFinishResult.fromJson(response.data!);
  }

  Future<Map<String, dynamic>> claimReward({required String stepId}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      Endpoints.quizRewardClaim(stepId),
    );
    return response.data!;
  }

  Future<void> reportQuestion({
    required String questionId,
    required String reason,
    String? description,
  }) async {
    await _apiClient.post<Map<String, dynamic>>(
      Endpoints.quizReportQuestion,
      data: {
        'questionId': questionId,
        'reason': reason,
        if (description != null) 'description': description,
      },
    );
  }
}
