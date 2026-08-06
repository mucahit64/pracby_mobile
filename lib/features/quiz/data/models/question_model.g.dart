// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionModelImpl _$$QuestionModelImplFromJson(
  Map<String, dynamic> json,
) => _$QuestionModelImpl(
  id: json['id'] as String,
  text: json['question_text'] as String,
  type: $enumDecode(_$QuestionTypeEnumMap, json['question_type']),
  options: (json['answers'] as List<dynamic>?)
      ?.map((e) => AnswerOption.fromJson(e as Map<String, dynamic>))
      .toList(),
  imageUrl: json['image_url'] as String?,
  explanation: json['explanation'] as String?,
  hint: json['hint'] as String?,
  difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
  pointValue: (json['point_value'] as num?)?.toInt() ?? 1,
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
  typeData: json['type_data'] as Map<String, dynamic>?,
  blanks: (json['blanks'] as List<dynamic>?)?.map((e) => e as String).toList(),
  chips: (json['chips'] as List<dynamic>?)?.map((e) => e as String).toList(),
  front: json['front'] as String?,
  back: json['back'] as String?,
);

Map<String, dynamic> _$$QuestionModelImplToJson(_$QuestionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question_text': instance.text,
      'question_type': _$QuestionTypeEnumMap[instance.type]!,
      'answers': instance.options,
      'image_url': instance.imageUrl,
      'explanation': instance.explanation,
      'hint': instance.hint,
      'difficulty': instance.difficulty,
      'point_value': instance.pointValue,
      'sort_order': instance.sortOrder,
      'type_data': instance.typeData,
      'blanks': instance.blanks,
      'chips': instance.chips,
      'front': instance.front,
      'back': instance.back,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.multipleChoice: 'multiple_choice',
  QuestionType.trueFalse: 'true_false',
  QuestionType.fillBlank: 'fill_blank',
  QuestionType.fillBlankChip: 'fill_blank_chip',
  QuestionType.fillBlankText: 'fill_blank_text',
  QuestionType.flashcard: 'flashcard',
  QuestionType.swipe: 'swipe',
  QuestionType.matching: 'matching',
  QuestionType.ordering: 'ordering',
};

_$AnswerOptionImpl _$$AnswerOptionImplFromJson(Map<String, dynamic> json) =>
    _$AnswerOptionImpl(
      id: json['id'] as String,
      text: json['answer_text'] as String,
      isCorrect: json['is_correct'] as bool? ?? false,
      label: json['label'] as String?,
    );

Map<String, dynamic> _$$AnswerOptionImplToJson(_$AnswerOptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'answer_text': instance.text,
      'is_correct': instance.isCorrect,
      'label': instance.label,
    };

_$MatchingPairImpl _$$MatchingPairImplFromJson(Map<String, dynamic> json) =>
    _$MatchingPairImpl(
      left: json['left'] as String,
      right: json['right'] as String,
    );

Map<String, dynamic> _$$MatchingPairImplToJson(_$MatchingPairImpl instance) =>
    <String, dynamic>{'left': instance.left, 'right': instance.right};

_$OrderingItemImpl _$$OrderingItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderingItemImpl(
      text: json['text'] as String,
      position: (json['position'] as num).toInt(),
    );

Map<String, dynamic> _$$OrderingItemImplToJson(_$OrderingItemImpl instance) =>
    <String, dynamic>{'text': instance.text, 'position': instance.position};
