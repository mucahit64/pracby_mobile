import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pracby_mobile/core/api/api_exception.dart';
import 'package:pracby_mobile/core/storage/hive_storage.dart';
import 'package:pracby_mobile/core/storage/secure_storage.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';
import 'package:pracby_mobile/features/quiz/data/models/quiz_answer.dart';
import 'package:pracby_mobile/features/quiz/data/quiz_repository.dart';
import 'package:pracby_mobile/features/store/data/store_repository.dart';

final offlineQueueProvider = ChangeNotifierProvider<OfflineQueue>((ref) {
  return OfflineQueue(
    hiveStorage: ref.watch(hiveStorageProvider),
    quizRepository: ref.watch(quizRepositoryProvider),
    storeRepository: ref.watch(storeRepositoryProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

enum _ActionType { finishQuiz, purchase, claimReward, reportQuestion }

/// Actions done without a connection, sent to the API in the order they
/// happened once the device is online (docs 7.5.1).
///
/// Order matters: an energy purchase must reach the server before the quiz
/// that spent that energy, and a chest claim after the lesson before it.
/// Each entry is stored under a time-ordered key. A sync stops at the first
/// entry that fails for lack of connection, so later ones never overtake it.
///
/// Member actions carry the user's ID and are only sent for that user.
/// Listeners are notified when entries are added or sent, so the lesson map
/// can show queued progress.
class OfflineQueue extends ChangeNotifier {
  OfflineQueue({
    required HiveStorage hiveStorage,
    required QuizRepository quizRepository,
    required StoreRepository storeRepository,
    required SecureStorage secureStorage,
  }) : _storage = hiveStorage,
       _quizRepository = quizRepository,
       _storeRepository = storeRepository,
       _secureStorage = secureStorage {
    _migrateLegacyQuizQueue();
  }

  final HiveStorage _storage;
  final QuizRepository _quizRepository;
  final StoreRepository _storeRepository;
  final SecureStorage _secureStorage;
  bool _syncing = false;
  int _keySeq = 0;

  Box<String> get _box => _storage.offlineQueueBox;

  bool get isEmpty => _box.isEmpty;

  /// Whether actions of [userId] are still waiting to be sent.
  bool hasPendingFor(String userId) =>
      _entries().any((e) => _belongsTo(e.value, userId));

  // ── Enqueue ─────────────────────────────────────────────────────────────

  /// A quiz result whose `finish-bulk` failed. A retry of the same session
  /// replaces its entry and keeps its place in the queue.
  Future<void> enqueueFinish({
    required String? userId,
    required String sessionId,
    required List<QuizAnswer> answers,
    required bool skipRewards,
    required String topicId,
    String? stepId,
    int correctCount = 0,
    int totalQuestions = 0,
  }) {
    final existing = _entries()
        .where(
          (e) =>
              e.value['type'] == _ActionType.finishQuiz.name &&
              (e.value['payload'] as Map)['sessionId'] == sessionId,
        )
        .map((e) => e.key)
        .firstOrNull;
    return _put(
      _ActionType.finishQuiz,
      userId: userId,
      key: existing,
      payload: {
        'sessionId': sessionId,
        'answers': answers.map((a) => a.toJson()).toList(),
        'skipRewards': skipRewards,
        'topicId': topicId,
        'stepId': stepId,
        'correctCount': correctCount,
        'totalQuestions': totalQuestions,
      },
    );
  }

  /// A lesson played from a quiz package (no server session yet). The sync
  /// starts the session with [testId] first and stores its ID in the entry
  /// before sending the answers, so a retry finishes the same session and
  /// the reward is never given twice. [localId] identifies the play.
  Future<void> enqueuePackagedFinish({
    required String userId,
    required String localId,
    required List<QuizAnswer> answers,
    required bool skipRewards,
    required String topicId,
    required String stepId,
    required String testId,
    int correctCount = 0,
    int totalQuestions = 0,
  }) => _put(
    _ActionType.finishQuiz,
    userId: userId,
    payload: {
      'sessionId': null,
      'localId': localId,
      'testId': testId,
      'answers': answers.map((a) => a.toJson()).toList(),
      'skipRewards': skipRewards,
      'topicId': topicId,
      'stepId': stepId,
      'correctCount': correctCount,
      'totalQuestions': totalQuestions,
    },
  );

  Future<void> enqueuePurchase({
    required String userId,
    required String itemId,
  }) => _put(_ActionType.purchase, userId: userId, payload: {'itemId': itemId});

  Future<void> enqueueClaim({required String userId, required String stepId}) =>
      _put(
        _ActionType.claimReward,
        userId: userId,
        payload: {'stepId': stepId},
      );

  /// A member report ([userId]) or a guest report ([guestId], docs 9.2).
  Future<void> enqueueReport({
    required String questionId,
    required String reason,
    String? description,
    String? userId,
    String? guestId,
  }) => _put(
    _ActionType.reportQuestion,
    userId: userId,
    payload: {
      'questionId': questionId,
      'reason': reason,
      'description': description,
      'guestId': guestId,
    },
  );

  // ── Sync ────────────────────────────────────────────────────────────────

  /// Sends queued actions in order. [userId] is the logged-in user (null for
  /// a guest); other users' actions are kept for when they log in again.
  /// Returns true if anything was sent or dropped.
  Future<bool> sync({required String? userId}) async {
    if (_syncing || _box.isEmpty) return false;
    _syncing = true;
    var changed = false;
    try {
      final hasToken = await _secureStorage.getToken() != null;
      for (final entry in _entries()) {
        final action = entry.value;
        if (!_isSendable(action, userId: userId, hasToken: hasToken)) continue;
        try {
          await _send(entry.key, action);
        } on _RetryLater {
          break;
        } on ApiException catch (e) {
          // No connection, server trouble, rate limit or logged out: keep it
          // and everything after it for the next sync.
          if (e.isNetworkError ||
              e.statusCode >= 500 ||
              e.statusCode == 429 ||
              e.statusCode == 401) {
            break;
          }
          // Rejected for good (e.g. 400 insufficient acorns, 409 already
          // reported): drop it. The next /users/me shows the real balance.
        } catch (_) {
          // Not an HTTP failure (e.g. an unreadable response after the server
          // accepted it): retrying can't help and would block the queue.
        }
        await _box.delete(entry.key);
        changed = true;
      }
    } finally {
      _syncing = false;
      if (changed) notifyListeners();
    }
    return changed;
  }

  /// Sends [userId]'s queue and reports whether it is now empty. New member
  /// actions go through the queue while it isn't, to keep their order.
  Future<bool> flush(String userId) async {
    await sync(userId: userId);
    return !hasPendingFor(userId);
  }

  // ── Lesson map ──────────────────────────────────────────────────────────

  /// Shows [userId]'s queued lesson results and chest claims as completed on
  /// the lesson map until the server has them (like guest progress, 10.6).
  CourseModel overlayProgress(CourseModel course, String userId) {
    final finished = <String, int>{}; // stepId -> best score
    final finals = <String, int>{}; // topicId -> best boss score
    final claimed = <String>{};
    for (final e in _entries()) {
      final action = e.value;
      if (!_belongsTo(action, userId)) continue;
      final payload = action['payload'] as Map<String, dynamic>;
      if (action['type'] == _ActionType.finishQuiz.name &&
          payload['skipRewards'] != true) {
        final total = (payload['totalQuestions'] as num?)?.toInt() ?? 0;
        final correct = (payload['correctCount'] as num?)?.toInt() ?? 0;
        final score = total > 0 ? (correct / total * 100).round() : 0;
        final stepId = payload['stepId'] as String?;
        if (stepId != null) {
          finished[stepId] = max(finished[stepId] ?? 0, score);
        } else {
          // Without a step it is the topic's final (the boss).
          final topicId = payload['topicId'] as String;
          finals[topicId] = max(finals[topicId] ?? 0, score);
        }
      } else if (action['type'] == _ActionType.claimReward.name) {
        claimed.add(payload['stepId'] as String);
      }
    }
    if (finished.isEmpty && claimed.isEmpty && finals.isEmpty) return course;

    StepModel apply(StepModel step) {
      final score = finished[step.id];
      if (score == null && !claimed.contains(step.id)) return step;
      final current = step.progress;
      return step.copyWith(
        progress: UserStepProgress(
          id: current?.id ?? '',
          userId: current?.userId ?? userId,
          stepId: step.id,
          testsCompleted: max(
            current?.testsCompleted ?? 0,
            score != null ? 1 : 0,
          ),
          isStepCompleted: true,
          stepFinalPassed: (current?.stepFinalPassed ?? false) || score != null,
          bestScore: max(current?.bestScore ?? 0, score ?? 0),
          completedAt: current?.completedAt,
        ),
      );
    }

    UserTopicProgress? applyFinal(TopicModel topic) {
      final score = finals[topic.id];
      final current = topic.progress;
      if (score == null) return current;
      return (current ??
              UserTopicProgress(id: '', userId: userId, topicId: topic.id))
          .copyWith(
            finalBestScore: max(current?.finalBestScore ?? 0, score),
            finalCompletedAt: current?.finalCompletedAt ?? DateTime.now(),
          );
    }

    return course.copyWith(
      topics: [
        for (final topic in course.topics)
          topic.copyWith(
            progress: applyFinal(topic),
            steps: [for (final s in topic.steps) apply(s)],
          ),
      ],
    );
  }

  // ── Internals ───────────────────────────────────────────────────────────

  /// Entries in the order they were queued.
  List<MapEntry<String, Map<String, dynamic>>> _entries() {
    final keys = _box.keys.cast<String>().toList()..sort();
    return [
      for (final key in keys)
        if (_box.get(key) case final raw?)
          MapEntry(key, jsonDecode(raw) as Map<String, dynamic>),
    ];
  }

  /// Member actions without a user ID come from the old quiz-only queue and
  /// belong to whoever is logged in.
  bool _belongsTo(Map<String, dynamic> action, String userId) {
    final owner = action['userId'] as String?;
    return owner == null || owner == userId;
  }

  bool _isSendable(
    Map<String, dynamic> action, {
    required String? userId,
    required bool hasToken,
  }) {
    final isGuestReport =
        action['type'] == _ActionType.reportQuestion.name &&
        (action['payload'] as Map)['guestId'] != null;
    if (isGuestReport) return true;
    return hasToken && userId != null && _belongsTo(action, userId);
  }

  Future<void> _send(String key, Map<String, dynamic> action) async {
    final p = action['payload'] as Map<String, dynamic>;
    switch (_ActionType.values.byName(action['type'] as String)) {
      case _ActionType.finishQuiz:
        final sessionId =
            p['sessionId'] as String? ?? await _startPackagedSession(key, action);
        await _quizRepository.finishBulk(
          sessionId: sessionId,
          answers: (p['answers'] as List)
              .map((a) => QuizAnswer.fromJson(a as Map<String, dynamic>))
              .toList(),
          skipRewards: p['skipRewards'] as bool? ?? false,
        );
      case _ActionType.purchase:
        await _storeRepository.purchase(itemId: p['itemId'] as String);
      case _ActionType.claimReward:
        await _quizRepository.claimReward(stepId: p['stepId'] as String);
      case _ActionType.reportQuestion:
        await _quizRepository.reportQuestion(
          questionId: p['questionId'] as String,
          reason: p['reason'] as String,
          description: p['description'] as String?,
          guestId: p['guestId'] as String?,
        );
    }
  }

  /// Opens the server session of a lesson played from a quiz package and
  /// saves its ID in the entry first (see [enqueuePackagedFinish]).
  Future<String> _startPackagedSession(
    String key,
    Map<String, dynamic> action,
  ) async {
    final p = action['payload'] as Map<String, dynamic>;
    try {
      final started = await _quizRepository.start((
        topicId: p['topicId'] as String,
        stepId: p['stepId'] as String?,
        testId: p['testId'] as String?,
        sessionType: 'lesson',
      ));
      p['sessionId'] = started.sessionId;
      await _box.put(key, jsonEncode(action));
      return started.sessionId;
    } on ApiException catch (e) {
      // No energy on the server right now (403): the result must not be
      // dropped like other rejections; try again later, e.g. after regen.
      if (e.statusCode == 403) throw const _RetryLater();
      rethrow;
    }
  }

  Future<void> _put(
    _ActionType type, {
    required Map<String, dynamic> payload,
    String? userId,
    String? key,
  }) async {
    await _box.put(
      key ?? _nextKey(),
      jsonEncode({'type': type.name, 'userId': userId, 'payload': payload}),
    );
    notifyListeners();
  }

  /// Sortable by time; the sequence number separates same-microsecond keys.
  String _nextKey() {
    final micros = DateTime.now().microsecondsSinceEpoch;
    final seq = (_keySeq++ % 1000).toString().padLeft(3, '0');
    return '${micros.toString().padLeft(20, '0')}-$seq';
  }

  /// Moves results left in the old quiz-only queue into this one.
  void _migrateLegacyQuizQueue() {
    final legacy = _storage.pendingQuizBox;
    if (legacy.isEmpty) return;
    for (final raw in legacy.values) {
      final entry = jsonDecode(raw) as Map<String, dynamic>;
      _box.put(
        _nextKey(),
        jsonEncode({
          'type': _ActionType.finishQuiz.name,
          'userId': null,
          'payload': {
            'sessionId': entry['sessionId'],
            'answers': entry['answers'],
            'skipRewards': entry['skipRewards'] ?? false,
            'topicId': null,
            'stepId': null,
          },
        }),
      );
    }
    legacy.clear();
  }
}

/// Stops the sync and keeps the entry, like a network error.
class _RetryLater implements Exception {
  const _RetryLater();
}
