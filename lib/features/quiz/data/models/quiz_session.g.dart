// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizFinishResultImpl _$$QuizFinishResultImplFromJson(
  Map<String, dynamic> json,
) => _$QuizFinishResultImpl(
  xpEarned: (json['xp_earned'] as num?)?.toInt() ?? 0,
  acornEarned: (json['acorn_earned'] as num?)?.toInt() ?? 0,
  correctAnswers: (json['correct_answers'] as num?)?.toInt() ?? 0,
  totalQuestions: (json['total_questions'] as num?)?.toInt() ?? 0,
  stepCompleted: json['step_completed'] as bool? ?? false,
  topicCompleted: json['topic_completed'] as bool? ?? false,
);

Map<String, dynamic> _$$QuizFinishResultImplToJson(
  _$QuizFinishResultImpl instance,
) => <String, dynamic>{
  'xp_earned': instance.xpEarned,
  'acorn_earned': instance.acornEarned,
  'correct_answers': instance.correctAnswers,
  'total_questions': instance.totalQuestions,
  'step_completed': instance.stepCompleted,
  'topic_completed': instance.topicCompleted,
};
