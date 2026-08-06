import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/features/quiz/data/models/question_model.dart';
import 'package:pracby_mobile/features/quiz/data/models/quiz_answer.dart';
import 'package:pracby_mobile/features/quiz/data/models/quiz_session.dart';
import 'package:pracby_mobile/features/quiz/data/quiz_repository.dart';
import 'package:pracby_mobile/features/quiz/domain/offline_quiz_buffer.dart';

final quizStateProvider =
    StateNotifierProvider.autoDispose<QuizNotifier, QuizState>((ref) {
  return QuizNotifier(
    quizRepository: ref.watch(quizRepositoryProvider),
    offlineBuffer: ref.watch(offlineQuizBufferProvider),
  );
});

class QuizState {
  const QuizState({
    this.session,
    this.currentIndex = 0,
    this.answers = const [],
    this.isLoading = false,
    this.isFinished = false,
    this.error,
    this.lastAnswerCorrect,
    this.xpEarned = 0,
    this.energyRemaining,
    this.finishResult,
  });

  final QuizSession? session;
  final int currentIndex;
  final List<QuizAnswer> answers;
  final bool isLoading;
  final bool isFinished;
  final String? error;
  final bool? lastAnswerCorrect;
  final int xpEarned;
  final int? energyRemaining;
  final QuizFinishResult? finishResult;

  int get totalQuestions => session?.questions.length ?? 0;
  int get correctAnswers => answers.where((a) => a.isCorrect).length;
  double get accuracy =>
      answers.isEmpty ? 0 : correctAnswers / answers.length;

  QuizState copyWith({
    QuizSession? session,
    int? currentIndex,
    List<QuizAnswer>? answers,
    bool? isLoading,
    bool? isFinished,
    String? error,
    bool? lastAnswerCorrect,
    int? xpEarned,
    int? energyRemaining,
    QuizFinishResult? finishResult,
  }) {
    return QuizState(
      session: session ?? this.session,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      isLoading: isLoading ?? this.isLoading,
      isFinished: isFinished ?? this.isFinished,
      error: error ?? this.error,
      lastAnswerCorrect: lastAnswerCorrect,
      xpEarned: xpEarned ?? this.xpEarned,
      energyRemaining: energyRemaining ?? this.energyRemaining,
      finishResult: finishResult ?? this.finishResult,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier({
    required QuizRepository quizRepository,
    required OfflineQuizBuffer offlineBuffer,
  })  : _quizRepository = quizRepository,
        _offlineBuffer = offlineBuffer,
        super(const QuizState());

  final QuizRepository _quizRepository;
  final OfflineQuizBuffer _offlineBuffer;
  DateTime? _questionStartTime;

  Future<void> startQuiz({
    required String stepId,
    required String topicId,
    String sessionType = 'lesson',
    String? testId,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final session = await _quizRepository.startQuiz(
        stepId: stepId,
        topicId: topicId,
        sessionType: sessionType,
        testId: testId,
      );
      state = state.copyWith(
        session: session,
        isLoading: false,
        currentIndex: 0,
        answers: [],
      );
      _questionStartTime = DateTime.now();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> submitAnswer(String answerId) async {
    final session = state.session;
    if (session == null) return;

    final timeSpent = _questionStartTime != null
        ? DateTime.now().difference(_questionStartTime!).inMilliseconds
        : 0;

    final question = session.questions[state.currentIndex];
    final isCorrectFromOptions = question.options
            ?.any((o) => o.id == answerId && o.isCorrect) ??
        false;

    // Immediately set optimistic result for instant UI feedback
    state = state.copyWith(lastAnswerCorrect: isCorrectFromOptions);

    final connectivity = await Connectivity().checkConnectivity();
    final isOnline = !connectivity.contains(ConnectivityResult.none);

    bool isCorrect;
    int? energyRemaining;

    if (isOnline) {
      try {
        final result = await _quizRepository.submitAnswer(
          quizId: session.id,
          questionId: question.id,
          answerId: answerId,
          timeSpent: timeSpent,
        );
        isCorrect = result['isCorrect'] as bool? ?? false;
        energyRemaining = result['energy_remaining'] as int?;
      } catch (_) {
        isCorrect = isCorrectFromOptions;
        await _offlineBuffer.bufferAnswer(
          quizId: session.id,
          answer: QuizAnswer(
            questionId: question.id,
            answerId: answerId,
            timeSpent: timeSpent,
          ),
        );
      }
    } else {
      isCorrect = isCorrectFromOptions;
      await _offlineBuffer.bufferAnswer(
        quizId: session.id,
        answer: QuizAnswer(
          questionId: question.id,
          answerId: answerId,
          timeSpent: timeSpent,
        ),
      );
    }

    final answer = QuizAnswer(
      questionId: question.id,
      answerId: answerId,
      timeSpent: timeSpent,
      isCorrect: isCorrect,
      answeredAt: DateTime.now().toIso8601String(),
    );

    state = state.copyWith(
      answers: [...state.answers, answer],
      lastAnswerCorrect: isCorrect,
      energyRemaining: energyRemaining,
    );
  }

  Future<void> submitTextAnswer(String text) async {
    final session = state.session;
    if (session == null) return;

    final timeSpent = _questionStartTime != null
        ? DateTime.now().difference(_questionStartTime!).inMilliseconds
        : 0;

    final question = session.questions[state.currentIndex];

    // Optimistic local check for instant UI feedback
    final acceptable = (question.typeData?['acceptable_answers'] as List?)
            ?.map((e) => e.toString().toLowerCase())
            .toList() ??
        [];
    final optimisticCorrect = acceptable.contains(text.toLowerCase().trim());
    state = state.copyWith(lastAnswerCorrect: optimisticCorrect);

    final connectivity = await Connectivity().checkConnectivity();
    final isOnline = !connectivity.contains(ConnectivityResult.none);

    var isCorrect = false;
    int? energyRemaining;

    if (isOnline) {
      try {
        final result = await _quizRepository.submitTextAnswer(
          quizId: session.id,
          questionId: question.id,
          textAnswer: text,
          timeSpent: timeSpent,
        );
        isCorrect = result['isCorrect'] as bool? ?? false;
        energyRemaining = result['energy_remaining'] as int?;
      } catch (_) {
        // Check locally
        final acceptable = (question.typeData?['acceptable_answers'] as List?)
                ?.map((e) => e.toString().toLowerCase())
                .toList() ??
            [];
        isCorrect = acceptable.contains(text.toLowerCase().trim());
      }
    } else {
      final acceptable = (question.typeData?['acceptable_answers'] as List?)
              ?.map((e) => e.toString().toLowerCase())
              .toList() ??
          [];
      isCorrect = acceptable.contains(text.toLowerCase().trim());
    }

    final answer = QuizAnswer(
      questionId: question.id,
      textAnswer: text,
      timeSpent: timeSpent,
      isCorrect: isCorrect,
      answeredAt: DateTime.now().toIso8601String(),
    );

    state = state.copyWith(
      answers: [...state.answers, answer],
      lastAnswerCorrect: isCorrect,
      energyRemaining: energyRemaining,
    );
  }

  Future<void> submitFlashcardAnswer(bool isCorrect) async {
    final session = state.session;
    if (session == null) return;

    // Immediate UI feedback for flashcard (user self-reports)
    state = state.copyWith(lastAnswerCorrect: isCorrect);

    final timeSpent = _questionStartTime != null
        ? DateTime.now().difference(_questionStartTime!).inMilliseconds
        : 0;

    final question = session.questions[state.currentIndex];

    final connectivity = await Connectivity().checkConnectivity();
    final isOnline = !connectivity.contains(ConnectivityResult.none);

    if (isOnline) {
      try {
        await _quizRepository.submitFlashcardAnswer(
          quizId: session.id,
          questionId: question.id,
          isCorrect: isCorrect,
          timeSpent: timeSpent,
        );
      } catch (_) {
        // Silent fail — buffer offline
      }
    }

    final answer = QuizAnswer(
      questionId: question.id,
      timeSpent: timeSpent,
      isCorrect: isCorrect,
      answeredAt: DateTime.now().toIso8601String(),
    );

    state = state.copyWith(
      answers: [...state.answers, answer],
      lastAnswerCorrect: isCorrect,
    );
  }

  Future<void> submitMatchingAnswer(List<Map<String, int>> matchingAnswer) async {
    final session = state.session;
    if (session == null) return;

    final timeSpent = _questionStartTime != null
        ? DateTime.now().difference(_questionStartTime!).inMilliseconds
        : 0;

    final question = session.questions[state.currentIndex];

    final connectivity = await Connectivity().checkConnectivity();
    final isOnline = !connectivity.contains(ConnectivityResult.none);

    var isCorrect = false;
    int? energyRemaining;

    final matchingPairs = matchingAnswer
        .map((m) => MatchingAnswerPair(
              leftIndex: m['leftIndex']!,
              rightIndex: m['rightIndex']!,
            ))
        .toList();

    if (isOnline) {
      try {
        final result = await _quizRepository.submitMatchingAnswer(
          quizId: session.id,
          questionId: question.id,
          matchingAnswer: matchingPairs,
          timeSpent: timeSpent,
        );
        isCorrect = result['isCorrect'] as bool? ?? false;
        energyRemaining = result['energy_remaining'] as int?;
      } catch (_) {
        // Check locally — correct if leftIndex == rightIndex for all
        isCorrect = matchingPairs.every((p) => p.leftIndex == p.rightIndex);
      }
    } else {
      isCorrect = matchingPairs.every((p) => p.leftIndex == p.rightIndex);
    }

    final answer = QuizAnswer(
      questionId: question.id,
      matchingAnswer: matchingPairs,
      timeSpent: timeSpent,
      isCorrect: isCorrect,
      answeredAt: DateTime.now().toIso8601String(),
    );

    state = state.copyWith(
      answers: [...state.answers, answer],
      lastAnswerCorrect: isCorrect,
      energyRemaining: energyRemaining,
    );
  }

  Future<void> submitOrderingAnswer(List<int> orderedIndices) async {
    final session = state.session;
    if (session == null) return;

    final timeSpent = _questionStartTime != null
        ? DateTime.now().difference(_questionStartTime!).inMilliseconds
        : 0;

    final question = session.questions[state.currentIndex];

    final connectivity = await Connectivity().checkConnectivity();
    final isOnline = !connectivity.contains(ConnectivityResult.none);

    var isCorrect = false;
    int? energyRemaining;

    if (isOnline) {
      try {
        final result = await _quizRepository.submitOrderingAnswer(
          quizId: session.id,
          questionId: question.id,
          orderedIndices: orderedIndices,
          timeSpent: timeSpent,
        );
        isCorrect = result['isCorrect'] as bool? ?? false;
        energyRemaining = result['energy_remaining'] as int?;
      } catch (_) {
        // Check locally — correct if ordering matches position sequence
        final items = (question.typeData?['items'] as List?)
                ?.map((e) => OrderingItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        if (items.isNotEmpty) {
          final correctOrder = List.generate(items.length, (i) => i);
          correctOrder.sort((a, b) => items[a].position.compareTo(items[b].position));
          isCorrect = orderedIndices.length == correctOrder.length &&
              List.generate(orderedIndices.length, (i) => orderedIndices[i] == correctOrder[i])
                  .every((e) => e);
        }
      }
    } else {
      final items = (question.typeData?['items'] as List?)
              ?.map((e) => OrderingItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      if (items.isNotEmpty) {
        final correctOrder = List.generate(items.length, (i) => i);
        correctOrder.sort((a, b) => items[a].position.compareTo(items[b].position));
        isCorrect = orderedIndices.length == correctOrder.length &&
            List.generate(orderedIndices.length, (i) => orderedIndices[i] == correctOrder[i])
                .every((e) => e);
      }
    }

    final answer = QuizAnswer(
      questionId: question.id,
      orderedIndices: orderedIndices,
      timeSpent: timeSpent,
      isCorrect: isCorrect,
      answeredAt: DateTime.now().toIso8601String(),
    );

    state = state.copyWith(
      answers: [...state.answers, answer],
      lastAnswerCorrect: isCorrect,
      energyRemaining: energyRemaining,
    );
  }

  void nextQuestion() {
    if (state.currentIndex >= state.totalQuestions - 1) {
      _finishQuiz();
    } else {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
      );
      _questionStartTime = DateTime.now();
    }
  }

  Future<void> _finishQuiz() async {
    final session = state.session;
    if (session == null) {
      state = state.copyWith(isFinished: true);
      return;
    }

    state = state.copyWith(isLoading: true);
    try {
      final result = await _quizRepository.finishBulk(
        quizId: session.id,
        answers: state.answers,
      );
      state = state.copyWith(
        isFinished: true,
        isLoading: false,
        xpEarned: result.xpEarned,
        finishResult: result,
      );
    } catch (e) {
      state = state.copyWith(
        isFinished: true,
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> retryFinish() async {
    state = QuizState(
      session: state.session,
      currentIndex: state.currentIndex,
      answers: state.answers,
      isLoading: true,
      isFinished: true,
      xpEarned: state.xpEarned,
      energyRemaining: state.energyRemaining,
      finishResult: state.finishResult,
      lastAnswerCorrect: state.lastAnswerCorrect,
    );
    await _finishQuiz();
  }
}
