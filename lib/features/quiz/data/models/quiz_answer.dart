import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_answer.freezed.dart';
part 'quiz_answer.g.dart';

/// `AnswerInput` sent to `finish-bulk` (MOBILE_APP_DOCS.md 7.4).
@freezed
class QuizAnswer with _$QuizAnswer {
  // The backend's Zod schema accepts missing fields but rejects `null`,
  // so null fields must be omitted.
  @JsonSerializable(includeIfNull: false, explicitToJson: true)
  const factory QuizAnswer({
    required String questionId,
    /// ISO 8601 in UTC (`...Z`); Zod's `datetime()` rejects local offsets.
    required String answeredAt,
    String? answerId,
    @Default(false) bool isSkipped,
    int? timeSpent,
    String? textAnswer,
    List<MatchingAnswerPair>? matchingAnswer,
    List<int>? orderedIndices,
    /// Only for flashcards; the server grades every other type itself.
    bool? isCorrect,
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
