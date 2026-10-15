import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/storage/hive_storage.dart';
import 'package:pracby_mobile/core/storage/secure_storage.dart';
import 'package:pracby_mobile/features/quiz/data/models/quiz_answer.dart';
import 'package:pracby_mobile/features/quiz/data/quiz_repository.dart';

final offlineQuizBufferProvider = Provider<OfflineQuizBuffer>((ref) {
  return OfflineQuizBuffer(
    hiveStorage: ref.watch(hiveStorageProvider),
    quizRepository: ref.watch(quizRepositoryProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

/// Offline queue for `finish-bulk` (MOBILE_APP_DOCS.md 7.5), mirroring the
/// web client's `composables/useOfflineQuiz.ts`.
class OfflineQuizBuffer {
  OfflineQuizBuffer({
    required HiveStorage hiveStorage,
    required QuizRepository quizRepository,
    required SecureStorage secureStorage,
  })  : _hiveStorage = hiveStorage,
        _quizRepository = quizRepository,
        _secureStorage = secureStorage;

  final HiveStorage _hiveStorage;
  final QuizRepository _quizRepository;
  final SecureStorage _secureStorage;
  bool _syncing = false;

  /// Stores a session for later; a retry of the same session replaces it.
  Future<void> savePending({
    required String sessionId,
    required List<QuizAnswer> answers,
    required bool skipRewards,
  }) {
    return _hiveStorage.pendingQuizBox.put(
      sessionId,
      jsonEncode({
        'sessionId': sessionId,
        'answers': answers.map((a) => a.toJson()).toList(),
        'savedAt': DateTime.now().toUtc().toIso8601String(),
        'skipRewards': skipRewards,
      }),
    );
  }

  bool get hasPending => _hiveStorage.pendingQuizBox.isNotEmpty;

  /// Sends every pending session. Ones that still fail stay queued.
  /// `finish-bulk` is idempotent, so repeating a sent session is safe.
  Future<void> syncPendingSessions() async {
    if (_syncing) return;
    final box = _hiveStorage.pendingQuizBox;
    if (box.isEmpty || await _secureStorage.getToken() == null) return;

    _syncing = true;
    try {
      for (final key in box.keys.toList()) {
        final raw = box.get(key);
        if (raw == null) continue;
        final entry = jsonDecode(raw) as Map<String, dynamic>;
        try {
          await _quizRepository.finishBulk(
            sessionId: entry['sessionId'] as String,
            answers: (entry['answers'] as List)
                .map((a) => QuizAnswer.fromJson(a as Map<String, dynamic>))
                .toList(),
            skipRewards: entry['skipRewards'] as bool? ?? false,
          );
          await box.delete(key);
        } catch (_) {
          // Still offline or server error — retry next time.
        }
      }
    } finally {
      _syncing = false;
    }
  }
}
