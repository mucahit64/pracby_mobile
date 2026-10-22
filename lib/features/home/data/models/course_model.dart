import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_model.freezed.dart';
part 'course_model.g.dart';

@freezed
class ExamGroupModel with _$ExamGroupModel {
  const factory ExamGroupModel({
    required String id,
    required String name,
    required String slug,
    String? description,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'exam_types') @Default([]) List<ExamTypeModel> examTypes,
  }) = _ExamGroupModel;

  factory ExamGroupModel.fromJson(Map<String, dynamic> json) =>
      _$ExamGroupModelFromJson(json);
}

@freezed
class ExamTypeModel with _$ExamTypeModel {
  const factory ExamTypeModel({
    required String id,
    required String name,
    required String slug,
    String? description,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _ExamTypeModel;

  factory ExamTypeModel.fromJson(Map<String, dynamic> json) =>
      _$ExamTypeModelFromJson(json);
}

@freezed
class ModuleModel with _$ModuleModel {
  const factory ModuleModel({
    required String id,
    @JsonKey(name: 'exam_type_id') required String examTypeId,
    required String name,
    String? description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _ModuleModel;

  factory ModuleModel.fromJson(Map<String, dynamic> json) =>
      _$ModuleModelFromJson(json);
}

@freezed
class CourseModel with _$CourseModel {
  const factory CourseModel({
    required String id,
    @JsonKey(name: 'name') required String title,
    String? description,
    @JsonKey(name: 'icon_url') String? imageUrl,
    String? color,
    @JsonKey(name: 'exam_type_id') String? examTypeId,
    @JsonKey(name: 'module_id') String? moduleId,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @Default([]) List<TopicModel> topics,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
}

@freezed
class TopicModel with _$TopicModel {
  const factory TopicModel({
    required String id,
    @JsonKey(name: 'name') required String title,
    @JsonKey(name: 'sort_order') required int order,
    @JsonKey(name: 'course_id') String? courseId,
    String? description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'total_lessons') @Default(0) int totalLessons,
    @JsonKey(name: 'max_crown_level') @Default(5) int maxCrownLevel,
    @JsonKey(name: 'unlock_after') String? unlockAfter,
    @Default('approved') String status,
    @Default([]) List<StepModel> steps,
    UserTopicProgress? progress,
  }) = _TopicModel;

  factory TopicModel.fromJson(Map<String, dynamic> json) =>
      _$TopicModelFromJson(json);
}

@freezed
class StepModel with _$StepModel {
  const factory StepModel({
    required String id,
    @JsonKey(name: 'sort_order') required int order,
    @JsonKey(name: 'step_type') required StepType type,
    @JsonKey(name: 'topic_id') String? topicId,
    @JsonKey(name: 'name') @Default('') String title,
    String? description,
    @JsonKey(name: 'tests_required') @Default(5) int testsRequired,
    @JsonKey(name: 'reward_type') String? rewardType,
    @JsonKey(name: 'reward_amount') int? rewardAmount,
    @JsonKey(name: 'reward_item_id') String? rewardItemId,
    UserStepProgress? progress,
  }) = _StepModel;

  factory StepModel.fromJson(Map<String, dynamic> json) =>
      _$StepModelFromJson(json);
}

@freezed
class UserTopicProgress with _$UserTopicProgress {
  const factory UserTopicProgress({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'topic_id') required String topicId,
    @JsonKey(name: 'crown_level') @Default(0) int crownLevel,
    @JsonKey(name: 'lessons_completed') @Default(0) int lessonsCompleted,
    @JsonKey(name: 'is_unlocked') @Default(false) bool isUnlocked,
    @JsonKey(name: 'last_practiced_at') DateTime? lastPracticedAt,
    @Default(0.0) double strength,
    @JsonKey(name: 'next_review_at') DateTime? nextReviewAt,

    /// The topic final (the boss on the map): best score and first finish.
    @JsonKey(name: 'final_best_score') @Default(0) int finalBestScore,
    @JsonKey(name: 'final_completed_at') DateTime? finalCompletedAt,
  }) = _UserTopicProgress;

  factory UserTopicProgress.fromJson(Map<String, dynamic> json) =>
      _$UserTopicProgressFromJson(json);
}

@freezed
class UserStepProgress with _$UserStepProgress {
  const factory UserStepProgress({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'step_id') required String stepId,
    @JsonKey(name: 'tests_completed') @Default(0) int testsCompleted,
    @JsonKey(name: 'is_step_completed') @Default(false) bool isStepCompleted,
    @JsonKey(name: 'step_final_passed') @Default(false) bool stepFinalPassed,
    @Default(0) int stars,

    /// Best accuracy (0-100) — shown on completed lesson nodes (docs 6.4).
    @JsonKey(name: 'best_score') @Default(0) int bestScore,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
  }) = _UserStepProgress;

  factory UserStepProgress.fromJson(Map<String, dynamic> json) =>
      _$UserStepProgressFromJson(json);
}

enum StepType {
  @JsonValue('lesson')
  lesson,
  @JsonValue('reward')
  reward,
}
