import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_exception.dart';
import 'package:pracby_mobile/features/auth/data/auth_repository.dart';
import 'package:pracby_mobile/features/auth/data/models/user_model.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';
import 'package:pracby_mobile/features/quiz/data/models/question_model.dart';
import 'package:pracby_mobile/features/quiz/data/models/quiz_answer.dart';
import 'package:pracby_mobile/features/quiz/data/quiz_repository.dart';
import 'package:pracby_mobile/features/quiz/domain/offline_quiz_buffer.dart';
import 'package:pracby_mobile/features/store/data/models/store_item.dart';
import 'package:pracby_mobile/features/store/data/store_repository.dart';

/// Quiz flow for a logged-in user, mirroring the web client's
/// `pages/quiz/[id].vue` (MOBILE_APP_DOCS.md 7.5).
final quizControllerProvider = StateNotifierProvider.autoDispose
    .family<QuizController, QuizState, QuizParams>(QuizController.new);

enum QuizDialog { none, energyEmpty, exitWarning }

class QuizState {
  const QuizState({
    this.loading = true,
    this.error,
    this.questions = const [],
    this.currentIndex = 0,
    this.answered = false,
    this.selectedAnswerId,
    this.lastAnswerCorrect = false,
    this.correctCount = 0,
    this.xpEarned = 0,
    this.acornEarned = 0,
    this.energy = 25,
    this.unlimitedEnergy = false,
    this.energyDepleted = false,
    this.answeredCount = 0,
    this.totalAnswered = 0,
    this.finished = false,
    this.stepCompleted = false,
    this.topicCompleted = false,
    this.pendingSync = false,
    this.dialog = QuizDialog.none,
    this.energyPackages = const [],
    this.loadingPackages = false,
    this.acornBalanceForDialog = 0,
    this.purchasingId,
    this.purchaseError,
    this.exitRequested = false,
    this.isGuest = false,
  });

  final bool loading;
  final String? error;
  final List<QuestionModel> questions;
  final int currentIndex;
  final bool answered;
  final String? selectedAnswerId;
  final bool lastAnswerCorrect;
  final int correctCount;
  final int xpEarned;
  final int acornEarned;
  final int energy;
  final bool unlimitedEnergy;
  final bool energyDepleted;

  /// Questions the user moved past with "DEVAM ET" (drives the progress bar).
  final int answeredCount;

  /// Questions answered so far (decides whether ✕ needs a warning).
  final int totalAnswered;
  final bool finished;
  final bool stepCompleted;
  final bool topicCompleted;

  /// The result is queued offline, waiting for connectivity.
  final bool pendingSync;
  final QuizDialog dialog;
  final List<StoreItem> energyPackages;
  final bool loadingPackages;
  final int acornBalanceForDialog;
  final String? purchasingId;
  final String? purchaseError;

  /// The screen should leave the quiz and go back to the lesson map.
  final bool exitRequested;

  /// Guest quiz: scored on the device, nothing is sent (docs 10.7).
  final bool isGuest;

  QuestionModel? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  bool get isLastQuestion => currentIndex >= questions.length - 1;

  int get examScore =>
      questions.isEmpty ? 0 : (correctCount / questions.length * 100).round();

  /// Correct option shown in the feedback sheet after a wrong answer.
  String? get correctAnswerText {
    final options = currentQuestion?.options ?? const [];
    for (final o in options) {
      if (o.isCorrect) return o.text;
    }
    return null;
  }

  QuizState copyWith({
    bool? loading,
    String? Function()? error,
    List<QuestionModel>? questions,
    int? currentIndex,
    bool? answered,
    String? Function()? selectedAnswerId,
    bool? lastAnswerCorrect,
    int? correctCount,
    int? xpEarned,
    int? acornEarned,
    int? energy,
    bool? unlimitedEnergy,
    bool? energyDepleted,
    int? answeredCount,
    int? totalAnswered,
    bool? finished,
    bool? stepCompleted,
    bool? topicCompleted,
    bool? pendingSync,
    QuizDialog? dialog,
    List<StoreItem>? energyPackages,
    bool? loadingPackages,
    int? acornBalanceForDialog,
    String? Function()? purchasingId,
    String? Function()? purchaseError,
    bool? exitRequested,
  }) {
    return QuizState(
      loading: loading ?? this.loading,
      error: error != null ? error() : this.error,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      answered: answered ?? this.answered,
      selectedAnswerId: selectedAnswerId != null
          ? selectedAnswerId()
          : this.selectedAnswerId,
      lastAnswerCorrect: lastAnswerCorrect ?? this.lastAnswerCorrect,
      correctCount: correctCount ?? this.correctCount,
      xpEarned: xpEarned ?? this.xpEarned,
      acornEarned: acornEarned ?? this.acornEarned,
      energy: energy ?? this.energy,
      unlimitedEnergy: unlimitedEnergy ?? this.unlimitedEnergy,
      energyDepleted: energyDepleted ?? this.energyDepleted,
      answeredCount: answeredCount ?? this.answeredCount,
      totalAnswered: totalAnswered ?? this.totalAnswered,
      finished: finished ?? this.finished,
      stepCompleted: stepCompleted ?? this.stepCompleted,
      topicCompleted: topicCompleted ?? this.topicCompleted,
      pendingSync: pendingSync ?? this.pendingSync,
      dialog: dialog ?? this.dialog,
      energyPackages: energyPackages ?? this.energyPackages,
      loadingPackages: loadingPackages ?? this.loadingPackages,
      acornBalanceForDialog:
          acornBalanceForDialog ?? this.acornBalanceForDialog,
      purchasingId: purchasingId != null ? purchasingId() : this.purchasingId,
      purchaseError: purchaseError != null
          ? purchaseError()
          : this.purchaseError,
      exitRequested: exitRequested ?? this.exitRequested,
      isGuest: isGuest,
    );
  }
}

/// What the user submitted for the current question. Only the field that
/// belongs to the question type is set (docs 8.7).
class AnswerInputData {
  const AnswerInputData({
    this.answerId,
    this.textAnswer,
    this.matchingAnswer,
    this.orderedIndices,
    this.flashcardKnown,
  });

  final String? answerId;
  final String? textAnswer;
  final List<MatchingAnswerPair>? matchingAnswer;
  final List<int>? orderedIndices;
  final bool? flashcardKnown;
}

class QuizController extends StateNotifier<QuizState> {
  QuizController(this._ref, this.params)
    : _isGuest = _ref.read(authStateProvider).valueOrNull == null,
      super(
        QuizState(isGuest: _ref.read(authStateProvider).valueOrNull == null),
      ) {
    _start();
  }

  final Ref _ref;
  final bool _isGuest;
  final QuizParams params;
  String? _sessionId;
  final List<QuizAnswer> _localAnswers = [];

  QuizRepository get _quizRepo => _ref.read(quizRepositoryProvider);
  OfflineQuizBuffer get _offline => _ref.read(offlineQuizBufferProvider);
  GuestNotifier get _guest => _ref.read(guestProvider.notifier);

  /// Guest start: `guest-start` and local energy (docs 7.1, 10.7).
  Future<void> _startGuest() async {
    _guest.refreshEnergy();
    try {
      final questions = await _quizRepo.guestStart(params);
      state = state.copyWith(
        loading: false,
        questions: questions,
        energy: _ref.read(guestProvider).energyCount,
      );
    } on ApiException catch (e) {
      state = state.copyWith(loading: false, error: () => e.message);
    } catch (_) {
      state = state.copyWith(loading: false, error: () => 'Quiz başlatılamadı');
    }
  }

  Future<void> _start() async {
    if (_isGuest) return _startGuest();

    // Sessions that failed to submit in a previous visit (web: onMounted).
    unawaited(_offline.syncPendingSessions());

    // Profile (energy) and effects are fetched alongside, like the web.
    // They never throw, so a failing start is reported on its own.
    final userFuture = _ref
        .read(authRepositoryProvider)
        .getMe()
        .then<UserModel?>((u) => u)
        .catchError((Object _) => null);
    final effectsFuture = _ref
        .read(storeRepositoryProvider)
        .getActiveEffects()
        .catchError((Object _) => <ActiveEffect>[]);

    try {
      final started = await _quizRepo.start(params);
      final user = await userFuture;
      final effects = await effectsFuture;

      _sessionId = started.sessionId;
      state = state.copyWith(
        loading: false,
        questions: started.questions,
        energy: user?.energy ?? 25,
        unlimitedEnergy: effects.any(
          (e) =>
              e.itemType == 'unlimited_energy' &&
              e.expiresAt.isAfter(DateTime.now()),
        ),
      );
    } on ApiException catch (e) {
      if (e.statusCode == 403) {
        state = state.copyWith(loading: false);
        await openEnergyDialog();
        return;
      }
      state = state.copyWith(loading: false, error: () => e.message);
    } catch (_) {
      state = state.copyWith(loading: false, error: () => 'Quiz başlatılamadı');
    }
  }

  /// Grades the answer locally (the API sends `is_correct`), updates energy
  /// and buffers it for `finish-bulk` — web `submitToBackend`.
  void answer(AnswerInputData input) {
    final q = state.currentQuestion;
    if (q == null || state.answered) return;

    final isCorrect = switch (q.type) {
      QuestionType.multipleChoice ||
      QuestionType.trueFalse ||
      QuestionType.swipe => q.options.any(
        (o) => o.id == input.answerId && o.isCorrect,
      ),
      QuestionType.fillBlank => _acceptableAnswers(
        q,
      ).contains((input.textAnswer ?? '').trim().toLowerCase()),
      QuestionType.matching => (input.matchingAnswer ?? const []).every(
        (p) => p.leftIndex == p.rightIndex,
      ),
      QuestionType.ordering => _isIdentityOrder(input.orderedIndices),
      QuestionType.flashcard => input.flashcardKnown ?? false,
    };

    var energy = state.energy;
    var energyDepleted = state.energyDepleted;
    // A wrong answer costs 1 energy unless unlimited energy is active
    // (the server skips the deduction too).
    if (!isCorrect && !state.unlimitedEnergy) {
      energy = (energy - 1).clamp(0, 25);
      if (energy == 0) energyDepleted = true;
      if (_isGuest) _guest.setEnergy(energy);
    }

    _localAnswers.add(
      QuizAnswer(
        questionId: q.id,
        answeredAt: DateTime.now().toUtc().toIso8601String(),
        answerId: input.answerId,
        textAnswer: input.textAnswer,
        matchingAnswer: input.matchingAnswer,
        orderedIndices: input.orderedIndices,
        isCorrect: q.type == QuestionType.flashcard
            ? input.flashcardKnown
            : null,
      ),
    );

    state = state.copyWith(
      answered: true,
      selectedAnswerId: () => input.answerId,
      lastAnswerCorrect: isCorrect,
      totalAnswered: state.totalAnswered + 1,
      correctCount: state.correctCount + (isCorrect ? 1 : 0),
      xpEarned: state.xpEarned + (isCorrect ? 1 : 0),
      energy: energy,
      energyDepleted: energyDepleted,
    );
  }

  /// "DEVAM ET" in the feedback sheet — web `nextQuestion`.
  Future<void> next() async {
    state = state.copyWith(answeredCount: state.answeredCount + 1);
    if (state.isLastQuestion) {
      state = state.copyWith(energyDepleted: false);
      await _finish();
      return;
    }
    if (state.energyDepleted) {
      await openEnergyDialog();
      return;
    }
    _advance();
  }

  void _advance() {
    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      answered: false,
      selectedAnswerId: () => null,
    );
  }

  Future<void> _finish() async {
    if (_isGuest) {
      // Saved on the device; +1 acorn per correct answer (docs 10.5).
      _guest
        ..addQuizResult(
          GuestQuizResult(
            topicId: params.topicId,
            stepId: params.stepId,
            testId: params.testId,
            correctCount: state.correctCount,
            totalQuestions: state.questions.length,
          ),
        )
        ..gainAcorns(state.correctCount);
      state = state.copyWith(acornEarned: state.correctCount, finished: true);
      return;
    }
    final sessionId = _sessionId;
    if (sessionId == null) return;
    final answers = List<QuizAnswer>.of(_localAnswers);
    final skipRewards = state.energyDepleted;

    try {
      final result = await _quizRepo.finishBulk(
        sessionId: sessionId,
        answers: answers,
        skipRewards: skipRewards,
      );
      _localAnswers.clear();
      state = state.copyWith(
        xpEarned: result.xpEarned,
        acornEarned: result.acornEarned,
        correctCount: result.correctAnswers,
        stepCompleted: result.stepCompleted,
        topicCompleted: result.topicCompleted,
        finished: true,
      );
      unawaited(_ref.read(authStateProvider.notifier).refreshUser());
    } catch (_) {
      // Network failure — queue it and send when back online.
      await _offline.savePending(
        sessionId: sessionId,
        answers: answers,
        skipRewards: skipRewards,
      );
      state = state.copyWith(pendingSync: true, finished: true);
    }
  }

  /// Energy packages (`energy_refill`) with the current acorn balance.
  Future<void> openEnergyDialog() async {
    final cachedAcorns = _isGuest
        ? _ref.read(guestProvider).acornBalance
        : _ref.read(authStateProvider).valueOrNull?.acorns ?? 0;
    state = state.copyWith(
      dialog: QuizDialog.energyEmpty,
      purchaseError: () => null,
      loadingPackages: true,
      acornBalanceForDialog: cachedAcorns,
    );
    if (_isGuest) {
      try {
        final items = await _ref.read(storeRepositoryProvider).getItems();
        if (mounted) {
          state = state.copyWith(
            energyPackages: items
                .where((i) => i.category == 'energy_refill')
                .toList(),
          );
        }
      } catch (_) {}
      if (mounted) state = state.copyWith(loadingPackages: false);
      return;
    }
    try {
      final userFuture = _ref
          .read(authRepositoryProvider)
          .getMe()
          .then<UserModel?>((u) => u)
          .catchError((Object _) => null);
      final items = await _ref.read(storeRepositoryProvider).getItems();
      final user = await userFuture;
      if (!mounted) return;
      state = state.copyWith(
        energyPackages: items
            .where((i) => i.category == 'energy_refill')
            .toList(),
        acornBalanceForDialog: user?.acorns ?? cachedAcorns,
      );
    } catch (_) {
      // Offline — keep the cached balance; packages stay empty.
    }
    if (mounted) state = state.copyWith(loadingPackages: false);
  }

  Future<void> buyEnergy(StoreItem pkg) async {
    state = state.copyWith(
      purchasingId: () => pkg.id,
      purchaseError: () => null,
    );
    if (_isGuest) return _buyEnergyAsGuest(pkg);
    try {
      final result = await _ref
          .read(storeRepositoryProvider)
          .purchase(itemId: pkg.id);
      final energy = (result['energy'] as num?)?.toInt() ?? state.energy;
      final balance = (result['balance'] as num).toInt();
      _ref
          .read(authStateProvider.notifier)
          .setBalances(energy: energy, acorns: balance);
      state = state.copyWith(
        energy: energy,
        acornBalanceForDialog: balance,
        energyDepleted: false,
        dialog: QuizDialog.none,
        purchasingId: () => null,
      );
      if (state.questions.isEmpty) {
        // Started with no energy (403) — start again now that we have some.
        state = state.copyWith(loading: true);
        await _start();
      } else if (!state.isLastQuestion) {
        _advance();
      } else {
        await _finish();
      }
    } catch (_) {
      state = state.copyWith(
        purchaseError: () => 'Satın alma başarısız. Tekrar dene.',
        purchasingId: () => null,
      );
    }
  }

  void declineEnergyPurchase() {
    state = state.copyWith(dialog: QuizDialog.none);
    if (state.finished) return;
    if (state.questions.isEmpty) {
      state = state.copyWith(exitRequested: true);
      return;
    }
    state = state.copyWith(dialog: QuizDialog.exitWarning);
  }

  void continueFromWarning() {
    state = state.copyWith(dialog: QuizDialog.none);
    if (state.energy == 0 && !state.unlimitedEnergy) {
      unawaited(openEnergyDialog());
    }
  }

  /// Leaves without rewards: the session is closed with no answers.
  void exit() {
    _localAnswers.clear();
    final sessionId = _sessionId;
    // A guest leaving saves nothing (docs 10.7).
    if (sessionId != null && !_isGuest) {
      _quizRepo
          .finishBulk(sessionId: sessionId, answers: [], skipRewards: true)
          .then((_) => _ref.read(authStateProvider.notifier).refreshUser())
          .catchError((Object _) {});
    }
    state = state.copyWith(dialog: QuizDialog.none, exitRequested: true);
  }

  /// ✕ button: leave at once if nothing was answered, otherwise warn.
  void handleClose() {
    if (state.totalAnswered == 0) {
      exit();
    } else {
      state = state.copyWith(dialog: QuizDialog.exitWarning);
    }
  }

  /// "🔄 Tekrar Dene" on the result screen.
  Future<void> restart() async {
    final energy = _isGuest
        ? _ref.read(guestProvider).energyCount
        : state.energy;
    if (energy <= 0 && !state.unlimitedEnergy) {
      await openEnergyDialog();
      return;
    }
    _localAnswers.clear();
    _sessionId = null;
    state = QuizState(isGuest: _isGuest);
    await _start();
  }

  /// Guests pay energy packages with local acorns (docs 10.4).
  Future<void> _buyEnergyAsGuest(StoreItem pkg) async {
    if (!_guest.spendAcorns(pkg.price)) {
      state = state.copyWith(
        purchaseError: () => 'Yetersiz palamut.',
        purchasingId: () => null,
      );
      return;
    }
    final count = (pkg.metadata?['energy_count'] as num?)?.toInt() ?? 1;
    final energy = (state.energy + count).clamp(0, maxEnergy);
    _guest.setEnergy(energy);
    state = state.copyWith(
      energy: energy,
      acornBalanceForDialog: _ref.read(guestProvider).acornBalance,
      energyDepleted: false,
      dialog: QuizDialog.none,
      purchasingId: () => null,
    );
    if (!state.isLastQuestion) {
      _advance();
    } else {
      await _finish();
    }
  }

  Set<String> _acceptableAnswers(QuestionModel q) =>
      ((q.typeData?['acceptable_answers'] as List?) ?? const [])
          .map((e) => e.toString().toLowerCase())
          .toSet();

  bool _isIdentityOrder(List<int>? indices) {
    if (indices == null) return false;
    for (var i = 0; i < indices.length; i++) {
      if (indices[i] != i) return false;
    }
    return true;
  }
}
