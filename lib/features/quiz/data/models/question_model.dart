import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_model.freezed.dart';
part 'question_model.g.dart';

@freezed
class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    required String id,
    @JsonKey(name: 'question_text') required String text,
    @JsonKey(name: 'question_type') required QuestionType type,
    @JsonKey(name: 'answers') List<AnswerOption>? options,
    @JsonKey(name: 'image_url') String? imageUrl,
    String? explanation,
    String? hint,
    @Default(1) int difficulty,
    @JsonKey(name: 'point_value') @Default(1) int pointValue,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'type_data') Map<String, dynamic>? typeData,
    // For fill-in-blank
    List<String>? blanks,
    List<String>? chips,
    // For flashcard
    String? front,
    String? back,
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
    String? label, // A, B, C, D — assigned in UI
  }) = _AnswerOption;

  factory AnswerOption.fromJson(Map<String, dynamic> json) =>
      _$AnswerOptionFromJson(json);
}

@freezed
class MatchingPair with _$MatchingPair {
  const factory MatchingPair({
    required String left,
    required String right,
  }) = _MatchingPair;

  factory MatchingPair.fromJson(Map<String, dynamic> json) =>
      _$MatchingPairFromJson(json);
}

@freezed
class OrderingItem with _$OrderingItem {
  const factory OrderingItem({
    required String text,
    required int position,
  }) = _OrderingItem;

  factory OrderingItem.fromJson(Map<String, dynamic> json) =>
      _$OrderingItemFromJson(json);
}

enum QuestionType {
  @JsonValue('multiple_choice')
  multipleChoice,
  @JsonValue('true_false')
  trueFalse,
  @JsonValue('fill_blank')
  fillBlank,
  @JsonValue('fill_blank_chip')
  fillBlankChip,
  @JsonValue('fill_blank_text')
  fillBlankText,
  @JsonValue('flashcard')
  flashcard,
  @JsonValue('swipe')
  swipe,
  @JsonValue('matching')
  matching,
  @JsonValue('ordering')
  ordering,
}
