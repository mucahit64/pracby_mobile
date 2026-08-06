import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/storage/hive_storage.dart';
import 'package:pracby_mobile/features/quiz/data/models/quiz_answer.dart';
import 'package:pracby_mobile/features/quiz/data/quiz_repository.dart';

final offlineQuizBufferProvider = Provider<OfflineQuizBuffer>((ref) {
  return OfflineQuizBuffer(
    hiveStorage: ref.watch(hiveStorageProvider),
    quizRepository: ref.watch(quizRepositoryProvider),
  );
});

class OfflineQuizBuffer {
  OfflineQuizBuffer({
    required HiveStorage hiveStorage,
    required QuizRepository quizRepository,
  })  : _hiveStorage = hiveStorage,
        _quizRepository = quizRepository;

  final HiveStorage _hiveStorage;
  final QuizRepository _quizRepository;

  Future<void> bufferAnswer({
    required String quizId,
    required QuizAnswer answer,
  }) async {
    await _hiveStorage.addBufferedAnswer({
      'quizId': quizId,
      ...answer.toJson(),
    });
  }

  bool get hasBufferedAnswers =>
      _hiveStorage.getBufferedAnswers().isNotEmpty;

  Future<void> syncBufferedAnswers() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) return;

    final buffered = _hiveStorage.getBufferedAnswers();
    if (buffered.isEmpty) return;

    // Group by quizId
    final grouped = <String, List<QuizAnswer>>{};
    for (final item in buffered) {
      final quizId = item['quizId'] as String;
      grouped.putIfAbsent(quizId, () => []);
      grouped[quizId]!.add(
        QuizAnswer(
          questionId: item['questionId'] as String,
          answerId: item['answerId'] as String,
          timeSpent: item['timeSpent'] as int,
        ),
      );
    }

    for (final entry in grouped.entries) {
      await _quizRepository.finishBulk(
        quizId: entry.key,
        answers: entry.value,
      );
    }

    await _hiveStorage.clearBufferedAnswers();
  }
}
