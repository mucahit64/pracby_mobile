import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_model.freezed.dart';
part 'question_model.g.dart';

/// `QuestionWithAnswers` from the API (MOBILE_APP_DOCS.md 7.3, 17).
@freezed
class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    required String id,
    @JsonKey(name: 'question_text') required String text,
    @JsonKey(
      name: 'question_type',
      unknownEnumValue: QuestionType.multipleChoice,
    )
    required QuestionType type,
    @JsonKey(name: 'answers') @Default([]) List<AnswerOption> options,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'exam_source') String? examSource,
    String? explanation,
    String? hint,
    @Default(1) int difficulty,
    @JsonKey(name: 'point_value') @Default(1) int pointValue,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'type_data') Map<String, dynamic>? typeData,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
}

@freezed
class AnswerOption with _$AnswerOption {
  const factory AnswerOption({
    required String id,
    @JsonKey(name: 'answer_text') required String text,
    @JsonKey(name: 'is_correct') @Default(false) bool isCorrect,
  }) = _AnswerOption;

  factory AnswerOption.fromJson(Map<String, dynamic> json) =>
      _$AnswerOptionFromJson(json);
}

enum QuestionType {
  @JsonValue('multiple_choice')
  multipleChoice,
  @JsonValue('true_false')
  trueFalse,
  @JsonValue('fill_blank')
  fillBlank,
  @JsonValue('flashcard')
  flashcard,
  @JsonValue('swipe')
  swipe,
  @JsonValue('matching')
  matching,
  @JsonValue('ordering')
  ordering,
}
