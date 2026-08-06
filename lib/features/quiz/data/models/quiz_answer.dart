import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_answer.freezed.dart';
part 'quiz_answer.g.dart';

@freezed
class QuizAnswer with _$QuizAnswer {
  const factory QuizAnswer({
    required String questionId,
    required int timeSpent, String? answerId,
    @Default(false) bool isCorrect,
    @Default(false) bool isSkipped,
    String? textAnswer,
    List<MatchingAnswerPair>? matchingAnswer,
    List<int>? orderedIndices,
    String? answeredAt,
  }) = _QuizAnswer;

  factory QuizAnswer.fromJson(Map<String, dynamic> json) =>
      _$QuizAnswerFromJson(json);
}

@freezed
class MatchingAnswerPair with _$MatchingAnswerPair {
  const factory MatchingAnswerPair({
    required int leftIndex,
    required int rightIndex,
  }) = _MatchingAnswerPair;

  factory MatchingAnswerPair.fromJson(Map<String, dynamic> json) =>
      _$MatchingAnswerPairFromJson(json);
}
