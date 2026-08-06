// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExamGroupModelImpl _$$ExamGroupModelImplFromJson(Map<String, dynamic> json) =>
    _$ExamGroupModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      examTypes:
          (json['exam_types'] as List<dynamic>?)
              ?.map((e) => ExamTypeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ExamGroupModelImplToJson(
  _$ExamGroupModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'description': instance.description,
  'sort_order': instance.sortOrder,
  'is_active': instance.isActive,
  'exam_types': instance.examTypes,
};

_$ExamTypeModelImpl _$$ExamTypeModelImplFromJson(Map<String, dynamic> json) =>
    _$ExamTypeModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$ExamTypeModelImplToJson(_$ExamTypeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
    };

_$ModuleModelImpl _$$ModuleModelImplFromJson(Map<String, dynamic> json) =>
    _$ModuleModelImpl(
      id: json['id'] as String,
      examTypeId: json['exam_type_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$ModuleModelImplToJson(_$ModuleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'exam_type_id': instance.examTypeId,
      'name': instance.name,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
    };

_$CourseModelImpl _$$CourseModelImplFromJson(Map<String, dynamic> json) =>
    _$CourseModelImpl(
      id: json['id'] as String,
      title: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['icon_url'] as String?,
      color: json['color'] as String?,
      examTypeId: json['exam_type_id'] as String?,
      moduleId: json['module_id'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      topics:
          (json['topics'] as List<dynamic>?)
              ?.map((e) => TopicModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CourseModelImplToJson(_$CourseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.title,
      'description': instance.description,
      'icon_url': instance.imageUrl,
      'color': instance.color,
      'exam_type_id': instance.examTypeId,
      'module_id': instance.moduleId,
      'sort_order': instance.sortOrder,
      'topics': instance.topics,
    };

_$TopicModelImpl _$$TopicModelImplFromJson(Map<String, dynamic> json) =>
    _$TopicModelImpl(
      id: json['id'] as String,
      courseId: json['course_id'] as String?,
      title: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
      order: (json['sort_order'] as num).toInt(),
      totalLessons: (json['total_lessons'] as num?)?.toInt() ?? 0,
      maxCrownLevel: (json['max_crown_level'] as num?)?.toInt() ?? 5,
      unlockAfter: json['unlock_after'] as String?,
      status: json['status'] as String? ?? 'approved',
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map((e) => StepModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      progress: json['progress'] == null
          ? null
          : UserTopicProgress.fromJson(
              json['progress'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$$TopicModelImplToJson(_$TopicModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course_id': instance.courseId,
      'name': instance.title,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'sort_order': instance.order,
      'total_lessons': instance.totalLessons,
      'max_crown_level': instance.maxCrownLevel,
      'unlock_after': instance.unlockAfter,
      'status': instance.status,
      'steps': instance.steps,
      'progress': instance.progress,
    };

_$StepModelImpl _$$StepModelImplFromJson(Map<String, dynamic> json) =>
    _$StepModelImpl(
      id: json['id'] as String,
      topicId: json['topic_id'] as String?,
      title: json['name'] as String? ?? '',
      description: json['description'] as String?,
      order: (json['sort_order'] as num).toInt(),
      type: $enumDecode(_$StepTypeEnumMap, json['step_type']),
      testsRequired: (json['tests_required'] as num?)?.toInt() ?? 5,
      rewardType: json['reward_type'] as String?,
      rewardAmount: (json['reward_amount'] as num?)?.toInt(),
      rewardItemId: json['reward_item_id'] as String?,
      progress: json['progress'] == null
          ? null
          : UserStepProgress.fromJson(json['progress'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$StepModelImplToJson(_$StepModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topic_id': instance.topicId,
      'name': instance.title,
      'description': instance.description,
      'sort_order': instance.order,
      'step_type': _$StepTypeEnumMap[instance.type]!,
      'tests_required': instance.testsRequired,
      'reward_type': instance.rewardType,
      'reward_amount': instance.rewardAmount,
      'reward_item_id': instance.rewardItemId,
      'progress': instance.progress,
    };

const _$StepTypeEnumMap = {
  StepType.lesson: 'lesson',
  StepType.reward: 'reward',
};

_$UserTopicProgressImpl _$$UserTopicProgressImplFromJson(
  Map<String, dynamic> json,
) => _$UserTopicProgressImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  topicId: json['topic_id'] as String,
  crownLevel: (json['crown_level'] as num?)?.toInt() ?? 0,
  lessonsCompleted: (json['lessons_completed'] as num?)?.toInt() ?? 0,
  isUnlocked: json['is_unlocked'] as bool? ?? false,
  lastPracticedAt: json['last_practiced_at'] == null
      ? null
      : DateTime.parse(json['last_practiced_at'] as String),
  strength: (json['strength'] as num?)?.toDouble() ?? 0.0,
  nextReviewAt: json['next_review_at'] == null
      ? null
      : DateTime.parse(json['next_review_at'] as String),
);

Map<String, dynamic> _$$UserTopicProgressImplToJson(
  _$UserTopicProgressImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'topic_id': instance.topicId,
  'crown_level': instance.crownLevel,
  'lessons_completed': instance.lessonsCompleted,
  'is_unlocked': instance.isUnlocked,
  'last_practiced_at': instance.lastPracticedAt?.toIso8601String(),
  'strength': instance.strength,
  'next_review_at': instance.nextReviewAt?.toIso8601String(),
};

_$UserStepProgressImpl _$$UserStepProgressImplFromJson(
  Map<String, dynamic> json,
) => _$UserStepProgressImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  stepId: json['step_id'] as String,
  testsCompleted: (json['tests_completed'] as num?)?.toInt() ?? 0,
  isStepCompleted: json['is_step_completed'] as bool? ?? false,
  stepFinalPassed: json['step_final_passed'] as bool? ?? false,
  stars: (json['stars'] as num?)?.toInt() ?? 0,
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
);

Map<String, dynamic> _$$UserStepProgressImplToJson(
  _$UserStepProgressImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'step_id': instance.stepId,
  'tests_completed': instance.testsCompleted,
  'is_step_completed': instance.isStepCompleted,
  'step_final_passed': instance.stepFinalPassed,
  'stars': instance.stars,
  'completed_at': instance.completedAt?.toIso8601String(),
};
