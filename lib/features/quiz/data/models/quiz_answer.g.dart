// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizAnswerImpl _$$QuizAnswerImplFromJson(Map<String, dynamic> json) =>
    _$QuizAnswerImpl(
      questionId: json['questionId'] as String,
      answerId: json['answerId'] as String?,
      timeSpent: (json['timeSpent'] as num).toInt(),
      isCorrect: json['isCorrect'] as bool? ?? false,
      isSkipped: json['isSkipped'] as bool? ?? false,
      textAnswer: json['textAnswer'] as String?,
      matchingAnswer: (json['matchingAnswer'] as List<dynamic>?)
          ?.map((e) => MatchingAnswerPair.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderedIndices: (json['orderedIndices'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      answeredAt: json['answeredAt'] as String?,
    );

Map<String, dynamic> _$$QuizAnswerImplToJson(_$QuizAnswerImpl instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'answerId': instance.answerId,
      'timeSpent': instance.timeSpent,
      'isCorrect': instance.isCorrect,
      'isSkipped': instance.isSkipped,
      'textAnswer': instance.textAnswer,
      'matchingAnswer': instance.matchingAnswer,
      'orderedIndices': instance.orderedIndices,
      'answeredAt': instance.answeredAt,
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
