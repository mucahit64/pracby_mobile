import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pracby_mobile/core/api/api_exception.dart';
import 'package:pracby_mobile/core/storage/hive_storage.dart';
import 'package:pracby_mobile/core/storage/secure_storage.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';
import 'package:pracby_mobile/features/offline/offline_queue.dart';
import 'package:pracby_mobile/features/quiz/data/models/question_model.dart';
import 'package:pracby_mobile/features/quiz/data/models/quiz_answer.dart';
import 'package:pracby_mobile/features/quiz/data/models/quiz_session.dart';
import 'package:pracby_mobile/features/quiz/data/quiz_repository.dart';
import 'package:pracby_mobile/features/store/data/store_repository.dart';

/// Records every API call; [failWith] makes the next calls throw.
class _Api {
  final calls = <String>[];
  ApiException? failWith;

  Future<T> call<T>(String name, T result) async {
    final error = failWith;
    if (error != null) throw error;
    calls.add(name);
    return result;
  }
}

class _FakeQuizRepository implements QuizRepository {
  _FakeQuizRepository(this.api);
  final _Api api;

  /// Thrown by the next `start` / `finishBulk` only (then cleared).
  ApiException? failStartOnce;
  ApiException? failFinishOnce;
  int _sessions = 0;

  @override
  Future<({String sessionId, List<QuestionModel> questions})> start(
    QuizParams params,
  ) {
    final error = failStartOnce;
    failStartOnce = null;
    if (error != null) throw error;
    _sessions += 1;
    return api.call('start:${params.testId}', (
      sessionId: 'srv$_sessions',
      questions: const <QuestionModel>[],
    ));
  }

  @override
  Future<QuizFinishResult> finishBulk({
    required String sessionId,
    required List<QuizAnswer> answers,
    bool skipRewards = false,
  }) {
    final error = failFinishOnce;
    failFinishOnce = null;
    if (error != null) throw error;
    return api.call('finish:$sessionId', QuizFinishResult.fromJson(const {}));
  }

  @override
  Future<Map<String, dynamic>> claimReward({required String stepId}) =>
      api.call('claim:$stepId', <String, dynamic>{});

  @override
  Future<void> reportQuestion({
    required String questionId,
    required String reason,
    String? description,
    String? guestId,
  }) => api.call('report:$questionId', null);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeStoreRepository implements StoreRepository {
  _FakeStoreRepository(this.api);
  final _Api api;

  @override
  Future<Map<String, dynamic>> purchase({
    required String itemId,
    int quantity = 1,
  }) => api.call('purchase:$itemId', <String, dynamic>{});

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSecureStorage implements SecureStorage {
  String? token = 'token';

  @override
  Future<String?> getToken() async => token;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _offline = ApiException(statusCode: 0, message: 'offline');

void main() {
  late Directory dir;
  late HiveStorage storage;
  late _Api api;
  late OfflineQueue queue;
  late _FakeQuizRepository quizRepo;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('offline_queue_test');
    storage = HiveStorage();
    await storage.init(path: dir.path);
    api = _Api();
    queue = OfflineQueue(
      hiveStorage: storage,
      quizRepository: quizRepo = _FakeQuizRepository(api),
      storeRepository: _FakeStoreRepository(api),
      secureStorage: _FakeSecureStorage(),
    );
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await Hive.close();
    await dir.delete(recursive: true);
  });

  Future<void> finish(String session, {String? stepId, String user = 'u1'}) =>
      queue.enqueueFinish(
        userId: user,
        sessionId: session,
        answers: const [],
        skipRewards: false,
        topicId: 't1',
        stepId: stepId,
        correctCount: 8,
        totalQuestions: 10,
      );

  Future<void> packagedFinish(String localId) => queue.enqueuePackagedFinish(
    userId: 'u1',
    localId: localId,
    answers: const [],
    skipRewards: false,
    topicId: 't1',
    stepId: 'step1',
    testId: 'test1',
    correctCount: 8,
    totalQuestions: 10,
  );

  test('a lesson played from a package starts its session, then finishes', () async {
    await packagedFinish('local1');
    await queue.sync(userId: 'u1');
    expect(api.calls, ['start:test1', 'finish:srv1']);
    expect(queue.isEmpty, isTrue);
  });

  test('a retry after a lost finish reuses the started session', () async {
    await packagedFinish('local1');
    quizRepo.failFinishOnce = _offline;
    await queue.sync(userId: 'u1');
    expect(queue.hasPendingFor('u1'), isTrue);

    await queue.sync(userId: 'u1');
    // One session only, so the reward can't be given twice.
    expect(api.calls, ['start:test1', 'finish:srv1']);
    expect(queue.isEmpty, isTrue);
  });

  test('no energy on the server keeps the packaged result for later', () async {
    await packagedFinish('local1');
    quizRepo.failStartOnce = const ApiException(statusCode: 403, message: 'Enerjin kalmadı!');
    await queue.sync(userId: 'u1');
    expect(queue.hasPendingFor('u1'), isTrue);

    await queue.sync(userId: 'u1');
    expect(api.calls, ['start:test1', 'finish:srv1']);
  });

  test('sends actions in the order they happened', () async {
    await queue.enqueuePurchase(userId: 'u1', itemId: 'energy5');
    await finish('s1', stepId: 'step1');
    await queue.enqueueClaim(userId: 'u1', stepId: 'chest1');

    expect(await queue.sync(userId: 'u1'), isTrue);
    expect(api.calls, ['purchase:energy5', 'finish:s1', 'claim:chest1']);
    expect(queue.isEmpty, isTrue);
  });

  test('stops at a connection failure and keeps the rest in order', () async {
    await finish('s1', stepId: 'step1');
    await queue.enqueueClaim(userId: 'u1', stepId: 'chest1');

    api.failWith = _offline;
    expect(await queue.sync(userId: 'u1'), isFalse);
    expect(await queue.flush('u1'), isFalse);

    api.failWith = null;
    expect(await queue.flush('u1'), isTrue);
    expect(api.calls, ['finish:s1', 'claim:chest1']);
  });

  test('drops an action the server rejects for good and continues', () async {
    await queue.enqueuePurchase(userId: 'u1', itemId: 'energy5');
    await queue.enqueueClaim(userId: 'u1', stepId: 'chest1');

    api.failWith = const ApiException(
      statusCode: 400,
      message: 'Insufficient acorn',
    );
    await queue.sync(userId: 'u1');
    // Both were rejected (the fake fails every call) and dropped.
    expect(queue.isEmpty, isTrue);
  });

  test("keeps another user's actions until that user is logged in", () async {
    await finish('s-other', user: 'u2');
    await finish('s-mine');

    await queue.sync(userId: 'u1');
    expect(api.calls, ['finish:s-mine']);
    expect(queue.hasPendingFor('u2'), isTrue);
    expect(queue.hasPendingFor('u1'), isFalse);
  });

  test('sends guest reports without a logged-in user', () async {
    await queue.enqueueReport(questionId: 'q1', reason: 'typo', guestId: 'g1');
    await finish('s1');

    await queue.sync(userId: null);
    expect(api.calls, ['report:q1']);
    expect(queue.hasPendingFor('u1'), isTrue);
  });

  test('a retried session replaces its entry and keeps its place', () async {
    await finish('s1');
    await queue.enqueueClaim(userId: 'u1', stepId: 'chest1');
    await finish('s1'); // e.g. leaving the quiz after a failed finish

    await queue.sync(userId: 'u1');
    expect(api.calls, ['finish:s1', 'claim:chest1']);
  });

  test('shows queued lessons and chests as completed on the map', () async {
    const course = CourseModel(
      id: 'c1',
      title: 'Matematik',
      topics: [
        TopicModel(
          id: 't1',
          title: 'Konu',
          order: 1,
          steps: [
            StepModel(id: 'step1', order: 1, type: StepType.lesson),
            StepModel(id: 'chest1', order: 2, type: StepType.reward),
            StepModel(id: 'step2', order: 3, type: StepType.lesson),
          ],
        ),
      ],
    );
    await finish('s1', stepId: 'step1');
    await queue.enqueueClaim(userId: 'u1', stepId: 'chest1');

    final steps = queue.overlayProgress(course, 'u1').topics.single.steps;
    expect(steps[0].progress?.isStepCompleted, isTrue);
    expect(steps[0].progress?.bestScore, 80);
    expect(steps[1].progress?.isStepCompleted, isTrue);
    expect(steps[2].progress, isNull);

    // Another user's queue doesn't show.
    final other = queue.overlayProgress(course, 'u2').topics.single.steps;
    expect(other[0].progress, isNull);
  });
}
