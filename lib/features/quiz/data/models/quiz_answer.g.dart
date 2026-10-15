// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizAnswerImpl _$$QuizAnswerImplFromJson(Map<String, dynamic> json) =>
    _$QuizAnswerImpl(
      questionId: json['questionId'] as String,
      answeredAt: json['answeredAt'] as String,
      answerId: json['answerId'] as String?,
      isSkipped: json['isSkipped'] as bool? ?? false,
      timeSpent: (json['timeSpent'] as num?)?.toInt(),
      textAnswer: json['textAnswer'] as String?,
      matchingAnswer: (json['matchingAnswer'] as List<dynamic>?)
          ?.map((e) => MatchingAnswerPair.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderedIndices: (json['orderedIndices'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      isCorrect: json['isCorrect'] as bool?,
    );

Map<String, dynamic> _$$QuizAnswerImplToJson(_$QuizAnswerImpl instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'answeredAt': instance.answeredAt,
      if (instance.answerId case final value?) 'answerId': value,
      'isSkipped': instance.isSkipped,
      if (instance.timeSpent case final value?) 'timeSpent': value,
      if (instance.textAnswer case final value?) 'textAnswer': value,
      if (instance.matchingAnswer?.map((e) => e.toJson()).toList()
          case final value?)
        'matchingAnswer': value,
      if (instance.orderedIndices case final value?) 'orderedIndices': value,
      if (instance.isCorrect case final value?) 'isCorrect': value,
    };

_$MatchingAnswerPairImpl _$$MatchingAnswerPairImplFromJson(
  Map<String, dynamic> json,
) => _$MatchingAnswerPairImpl(
  leftIndex: (json['leftIndex'] as num).toInt(),
  rightIndex: (json['rightIndex'] as num).toInt(),
);

Map<String, dynamic> _$$MatchingAnswerPairImplToJson(
  _$MatchingAnswerPairImpl instance,
) => <String, dynamic>{
  'leftIndex': instance.leftIndex,
  'rightIndex': instance.rightIndex,
};
