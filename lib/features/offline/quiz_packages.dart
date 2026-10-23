import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_client.dart';
import 'package:pracby_mobile/core/storage/hive_storage.dart';
import 'package:pracby_mobile/core/utils/image_prefetch.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';
import 'package:pracby_mobile/features/quiz/data/models/question_model.dart';
import 'package:pracby_mobile/features/quiz/data/quiz_repository.dart';

final quizPackagesProvider = Provider<QuizPackages>((ref) {
  return QuizPackages(
    storage: ref.watch(hiveStorageProvider),
    quizRepository: ref.watch(quizRepositoryProvider),
  );
});

/// A lesson's questions (with the answer key and images) downloaded ahead,
/// so it can be played without a connection (docs 7.5.1).
class QuizPackage {
  const QuizPackage({
    required this.topicId,
    required this.stepId,
    required this.testId,
    required this.questions,
  });

  final String topicId;
  final String stepId;

  /// The test the questions belong to. The offline queue starts the session
  /// with it, so the server's questions are exactly these.
  final String testId;
  final List<QuestionModel> questions;
}

/// Keeps the next lessons of the lesson map downloaded: when the map loads,
/// the first [ahead] unfinished lessons of the course are fetched with
/// `guest-start` (no session) and stored; others are dropped. A lesson with a
/// package always starts from it, online or not (quiz_provider).
class QuizPackages {
  QuizPackages({
    required HiveStorage storage,
    required QuizRepository quizRepository,
  }) : _storage = storage,
       _quizRepository = quizRepository;

  final HiveStorage _storage;
  final QuizRepository _quizRepository;
  final _refreshing = <String>{};

  /// Lessons kept downloaded: the active one and the two after it.
  static const ahead = 3;

  /// A package counts as current for this long; older ones are fetched
  /// again on the next map load so edited questions come through.
  static const _maxAge = Duration(hours: 12);

  /// The package for a lesson step, if downloaded.
  QuizPackage? forStep(String stepId) {
    final raw = _storage.quizPackagesBox.get(stepId);
    if (raw == null) return null;
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return QuizPackage(
      topicId: json['topicId'] as String,
      stepId: stepId,
      testId: json['testId'] as String,
      questions: QuizRepository.parseQuestions(json['questions']),
    );
  }

  bool has(String stepId) => _storage.quizPackagesBox.containsKey(stepId);

  /// The next unfinished lessons of [course], in map order.
  static List<StepModel> nextLessons(CourseModel course) => [
    for (final topic in course.topics)
      for (final step in topic.steps)
        if (step.type == StepType.lesson &&
            !(step.progress?.isStepCompleted ?? false))
          step,
  ].take(ahead).toList();

  /// Downloads the packages [course]'s next lessons are missing (or that are
  /// old) and drops the rest. Failures (offline) keep what is stored.
  Future<void> refreshFor(CourseModel course) async {
    if (!_refreshing.add(course.id)) return;
    try {
      final box = _storage.quizPackagesBox;
      final wanted = nextLessons(course);
      final wantedIds = {for (final s in wanted) s.id};
      final topicOf = {
        for (final t in course.topics)
          for (final s in t.steps) s.id: t.id,
      };
      // This course's other lessons are no longer next; keep other courses'.
      for (final stepId in topicOf.keys) {
        if (!wantedIds.contains(stepId)) await box.delete(stepId);
      }
      for (final step in wanted) {
        if (!_isStale(step.id)) continue;
        await _download(topicId: topicOf[step.id]!, stepId: step.id);
      }
    } finally {
      _refreshing.remove(course.id);
    }
  }

  bool _isStale(String stepId) {
    final raw = _storage.quizPackagesBox.get(stepId);
    if (raw == null) return true;
    final savedAt = DateTime.tryParse(
      (jsonDecode(raw) as Map<String, dynamic>)['savedAt'] as String? ?? '',
    );
    return savedAt == null || DateTime.now().difference(savedAt) > _maxAge;
  }

  Future<void> _download({
    required String topicId,
    required String stepId,
  }) async {
    try {
      final raw = await _quizRepository.guestStartRaw((
        topicId: topicId,
        stepId: stepId,
        testId: null,
        sessionType: 'lesson',
      ));
      // guest-start serves the step's first test; the session must use it.
      final testId = raw.isEmpty
          ? null
          : (raw.first as Map<String, dynamic>)['test_id'] as String?;
      if (testId == null) return;
      final questions = QuizRepository.parseQuestions(raw);
      final images = [
        for (final q in questions)
          if (q.imageUrl case final url? when url.isNotEmpty)
            questionImageUrl(url),
      ];
      // A package without its images can't be played offline.
      if (images.isNotEmpty && !await ImagePrefetch.prefetch(images)) return;
      await _storage.quizPackagesBox.put(
        stepId,
        jsonEncode({
          'topicId': topicId,
          'testId': testId,
          'questions': raw,
          'savedAt': DateTime.now().toIso8601String(),
        }),
      );
    } catch (_) {
      // Offline or the lesson has no questions: try again on the next load.
    }
  }
}
