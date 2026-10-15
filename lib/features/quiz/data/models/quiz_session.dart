import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_session.freezed.dart';
part 'quiz_session.g.dart';

/// `finish-bulk` response (MOBILE_APP_DOCS.md 7.4).
@freezed
class QuizFinishResult with _$QuizFinishResult {
  const factory QuizFinishResult({
    @JsonKey(name: 'xp_earned') @Default(0) int xpEarned,
    @JsonKey(name: 'acorn_earned') @Default(0) int acornEarned,
    @JsonKey(name: 'correct_answers') @Default(0) int correctAnswers,
    @JsonKey(name: 'total_questions') @Default(0) int totalQuestions,
    @JsonKey(name: 'step_completed') @Default(false) bool stepCompleted,
    @JsonKey(name: 'topic_completed') @Default(false) bool topicCompleted,
  }) = _QuizFinishResult;

  factory QuizFinishResult.fromJson(Map<String, dynamic> json) =>
      _$QuizFinishResultFromJson(json);
}
