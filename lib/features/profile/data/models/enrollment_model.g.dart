// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrollment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EnrollmentModelImpl _$$EnrollmentModelImplFromJson(
  Map<String, dynamic> json,
) => _$EnrollmentModelImpl(
  id: json['id'] as String,
  examTypeId: json['exam_type_id'] as String,
  enrolledAt: DateTime.parse(json['enrolled_at'] as String),
  examTypeName: json['exam_type_name'] as String,
  examTypeSlug: json['exam_type_slug'] as String,
  examGroupName: json['exam_group_name'] as String,
  examGroupSlug: json['exam_group_slug'] as String,
);

Map<String, dynamic> _$$EnrollmentModelImplToJson(
  _$EnrollmentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'exam_type_id': instance.examTypeId,
  'enrolled_at': instance.enrolledAt.toIso8601String(),
  'exam_type_name': instance.examTypeName,
  'exam_type_slug': instance.examTypeSlug,
  'exam_group_name': instance.examGroupName,
  'exam_group_slug': instance.examGroupSlug,
};
