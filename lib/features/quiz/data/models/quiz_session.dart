import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pracby_mobile/features/quiz/data/models/question_model.dart';

part 'quiz_session.freezed.dart';
part 'quiz_session.g.dart';

@freezed
class QuizSession with _$QuizSession {
  const factory QuizSession({
    required String id,
    required List<QuestionModel> questions, @JsonKey(name: 'step_id') String? stepId,
    @JsonKey(name: 'topic_id') String? topicId,
    @JsonKey(name: 'test_id') String? testId,
    @JsonKey(name: 'session_type') @Default('lesson') String sessionType,
    @JsonKey(name: 'is_final_test') @Default(false) bool isFinalTest,
    @JsonKey(name: 'total_questions') @Default(0) int totalQuestions,
    @Default(0) int score,
    @JsonKey(name: 'xp_earned') @Default(0) int xpEarned,
    @JsonKey(name: 'correct_answers') @Default(0) int correctAnswers,
    @JsonKey(name: 'energy_lost') @Default(0) int energyLost,
  }) = _QuizSession;

  factory QuizSession.fromJson(Map<String, dynamic> json) =>
      _$QuizSessionFromJson(json);
}

@freezed
class QuizFinishResult with _$QuizFinishResult {
  const factory QuizFinishResult({
    @JsonKey(name: 'xp_earned') @Default(0) int xpEarned,
    @JsonKey(name: 'acorn_earned') @Default(0) int acornEarned,
    @JsonKey(name: 'step_completed') @Default(false) bool stepCompleted,
    @JsonKey(name: 'topic_completed') @Default(false) bool topicCompleted,
    @JsonKey(name: 'reward_available') @Default(false) bool rewardAvailable,
    @JsonKey(name: 'correct_answers') @Default(0) int correctAnswers,
    @JsonKey(name: 'total_questions') @Default(0) int totalQuestions,
    @Default(0) int score,
    @Default(0) int duration,
  }) = _QuizFinishResult;

  factory QuizFinishResult.fromJson(Map<String, dynamic> json) =>
      _$QuizFinishResultFromJson(json);
}

enum SessionType {
  lesson,
  review,
  practice,
  // ignore: constant_identifier_names
  step_final,
  // ignore: constant_identifier_names
  topic_final,
}
