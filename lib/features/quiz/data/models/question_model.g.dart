// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionModelImpl _$$QuestionModelImplFromJson(Map<String, dynamic> json) =>
    _$QuestionModelImpl(
      id: json['id'] as String,
      text: json['question_text'] as String,
      type: $enumDecode(
        _$QuestionTypeEnumMap,
        json['question_type'],
        unknownValue: QuestionType.multipleChoice,
      ),
      options:
          (json['answers'] as List<dynamic>?)
              ?.map((e) => AnswerOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      imageUrl: json['image_url'] as String?,
      examSource: json['exam_source'] as String?,
      explanation: json['explanation'] as String?,
      hint: json['hint'] as String?,
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
      pointValue: (json['point_value'] as num?)?.toInt() ?? 1,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      typeData: json['type_data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$QuestionModelImplToJson(_$QuestionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question_text': instance.text,
      'question_type': _$QuestionTypeEnumMap[instance.type]!,
      'answers': instance.options,
      'image_url': instance.imageUrl,
      'exam_source': instance.examSource,
      'explanation': instance.explanation,
      'hint': instance.hint,
      'difficulty': instance.difficulty,
      'point_value': instance.pointValue,
      'sort_order': instance.sortOrder,
      'type_data': instance.typeData,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.multipleChoice: 'multiple_choice',
  QuestionType.trueFalse: 'true_false',
  QuestionType.fillBlank: 'fill_blank',
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
    );

Map<String, dynamic> _$$AnswerOptionImplToJson(_$AnswerOptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'answer_text': instance.text,
      'is_correct': instance.isCorrect,
    };
