import 'package:freezed_annotation/freezed_annotation.dart';

part 'enrollment_model.freezed.dart';
part 'enrollment_model.g.dart';

@freezed
class EnrollmentModel with _$EnrollmentModel {
  const factory EnrollmentModel({
    required String id,
    @JsonKey(name: 'exam_type_id') required String examTypeId,
    @JsonKey(name: 'enrolled_at') required DateTime enrolledAt,
    @JsonKey(name: 'exam_type_name') required String examTypeName,
    @JsonKey(name: 'exam_type_slug') required String examTypeSlug,
    @JsonKey(name: 'exam_group_name') required String examGroupName,
    @JsonKey(name: 'exam_group_slug') required String examGroupSlug,
  }) = _EnrollmentModel;

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentModelFromJson(json);
}
