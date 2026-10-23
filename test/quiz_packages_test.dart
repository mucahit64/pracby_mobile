import 'package:flutter_test/flutter_test.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';
import 'package:pracby_mobile/features/offline/quiz_packages.dart';

StepModel _lesson(String id, int order, {bool done = false}) => StepModel(
  id: id,
  order: order,
  type: StepType.lesson,
  progress: done
      ? UserStepProgress(
          id: 'p-$id',
          userId: 'u1',
          stepId: id,
          isStepCompleted: true,
        )
      : null,
);

void main() {
  test('downloads the next unfinished lessons in map order, skipping chests', () {
    final course = CourseModel(
      id: 'c1',
      title: 'Matematik',
      topics: [
        TopicModel(
          id: 't1',
          title: 'Sayılar',
          order: 1,
          steps: [
            _lesson('a', 1, done: true),
            const StepModel(id: 'chest', order: 2, type: StepType.reward),
            _lesson('b', 3),
          ],
        ),
        TopicModel(
          id: 't2',
          title: 'Kesirler',
          order: 2,
          steps: [_lesson('c', 1), _lesson('d', 2), _lesson('e', 3)],
        ),
      ],
    );

    expect(QuizPackages.nextLessons(course).map((s) => s.id), ['b', 'c', 'd']);
  });
}
