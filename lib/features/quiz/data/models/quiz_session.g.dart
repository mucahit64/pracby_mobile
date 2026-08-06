// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizSessionImpl _$$QuizSessionImplFromJson(Map<String, dynamic> json) =>
    _$QuizSessionImpl(
      id: json['id'] as String,
      stepId: json['step_id'] as String?,
      topicId: json['topic_id'] as String?,
      testId: json['test_id'] as String?,
      sessionType: json['session_type'] as String? ?? 'lesson',
      isFinalTest: json['is_final_test'] as bool? ?? false,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalQuestions: (json['total_questions'] as num?)?.toInt() ?? 0,
      score: (json['score'] as num?)?.toInt() ?? 0,
      xpEarned: (json['xp_earned'] as num?)?.toInt() ?? 0,
      correctAnswers: (json['correct_answers'] as num?)?.toInt() ?? 0,
      energyLost: (json['energy_lost'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$QuizSessionImplToJson(_$QuizSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'step_id': instance.stepId,
      'topic_id': instance.topicId,
      'test_id': instance.testId,
      'session_type': instance.sessionType,
      'is_final_test': instance.isFinalTest,
      'questions': instance.questions,
      'total_questions': instance.totalQuestions,
      'score': instance.score,
      'xp_earned': instance.xpEarned,
      'correct_answers': instance.correctAnswers,
      'energy_lost': instance.energyLost,
    };

_$QuizFinishResultImpl _$$QuizFinishResultImplFromJson(
  Map<String, dynamic> json,
) => _$QuizFinishResultImpl(
  xpEarned: (json['xp_earned'] as num?)?.toInt() ?? 0,
  acornEarned: (json['acorn_earned'] as num?)?.toInt() ?? 0,
  stepCompleted: json['step_completed'] as bool? ?? false,
  topicCompleted: json['topic_completed'] as bool? ?? false,
  rewardAvailable: json['reward_available'] as bool? ?? false,
  correctAnswers: (json['correct_answers'] as num?)?.toInt() ?? 0,
  totalQuestions: (json['total_questions'] as num?)?.toInt() ?? 0,
  score: (json['score'] as num?)?.toInt() ?? 0,
  duration: (json['duration'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$QuizFinishResultImplToJson(
  _$QuizFinishResultImpl instance,
) => <String, dynamic>{
  'xp_earned': instance.xpEarned,
  'acorn_earned': instance.acornEarned,
  'step_completed': instance.stepCompleted,
  'topic_completed': instance.topicCompleted,
  'reward_available': instance.rewardAvailable,
  'correct_answers': instance.correctAnswers,
  'total_questions': instance.totalQuestions,
  'score': instance.score,
  'duration': instance.duration,
};
