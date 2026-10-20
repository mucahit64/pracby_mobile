import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/storage/hive_storage.dart';
import 'package:pracby_mobile/features/auth/data/auth_repository.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';

/// Guest mode (MOBILE_APP_DOCS.md 10), mirroring the web client's
/// `composables/useGuestState.ts`. A guest has no server record: progress,
/// energy and acorns live on the device until they register or log in.
final guestProvider = StateNotifierProvider<GuestNotifier, GuestState>(
  (ref) => GuestNotifier(ref.watch(hiveStorageProvider)),
);

const maxEnergy = 25;
const energyRegenInterval = Duration(minutes: 10);
const _initialAcorns = 500;
const _stateKey = 'state';
const _guestIdKey = 'guestId';

class GuestQuizResult {
  const GuestQuizResult({
    required this.topicId,
    required this.correctCount,
    required this.totalQuestions,
    this.stepId,
    this.testId,
  });

  factory GuestQuizResult.fromJson(Map<String, dynamic> json) =>
      GuestQuizResult(
        topicId: json['topicId'] as String,
        stepId: json['stepId'] as String?,
        testId: json['testId'] as String?,
        correctCount: (json['correctCount'] as num).toInt(),
        totalQuestions: (json['totalQuestions'] as num).toInt(),
      );

  final String topicId;
  final String? stepId;
  final String? testId;
  final int correctCount;
  final int totalQuestions;

  /// Same keys as the API's `guest_data.quiz_results` (docs 3.2).
  Map<String, dynamic> toJson() => {
    'topicId': topicId,
    if (stepId != null) 'stepId': stepId,
    if (testId != null) 'testId': testId,
    'correctCount': correctCount,
    'totalQuestions': totalQuestions,
  };
}

class GuestState {
  const GuestState({
    this.examTypeId,
    this.examGroupId,
    this.quizResults = const [],
    this.claimedRewardStepIds = const [],
    this.acornBalance = _initialAcorns,
    this.energyCount = maxEnergy,
    this.energyRefreshedAtMs,
  });

  factory GuestState.fromJson(Map<String, dynamic> json) => GuestState(
    examTypeId: json['examTypeId'] as String?,
    examGroupId: json['examGroupId'] as String?,
    quizResults: ((json['quizResults'] as List?) ?? const [])
        .map((e) => GuestQuizResult.fromJson(e as Map<String, dynamic>))
        .toList(),
    claimedRewardStepIds: ((json['claimedRewardStepIds'] as List?) ?? const [])
        .cast<String>(),
    acornBalance: (json['acornBalance'] as num?)?.toInt() ?? _initialAcorns,
    energyCount: (json['energyCount'] as num?)?.toInt() ?? maxEnergy,
    energyRefreshedAtMs: (json['energyRefreshedAtMs'] as num?)?.toInt(),
  );

  final String? examTypeId;
  final String? examGroupId;
  final List<GuestQuizResult> quizResults;
  final List<String> claimedRewardStepIds;
  final int acornBalance;
  final int energyCount;

  /// Start of the regen timer (epoch ms); null while energy is full.
  final int? energyRefreshedAtMs;

  /// The guest picked an exam and can use the lesson map.
  bool get isActive => examTypeId != null;

  /// Next +1 energy, or null when full (docs 10.4).
  DateTime? get nextEnergyAt =>
      energyCount >= maxEnergy || energyRefreshedAtMs == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(
          energyRefreshedAtMs! + energyRegenInterval.inMilliseconds,
        );

  /// Docs 10.9: progress exists when results, claims or extra acorns exist.
  bool get hasProgress =>
      quizResults.isNotEmpty ||
      claimedRewardStepIds.isNotEmpty ||
      acornBalance > _initialAcorns;

  Map<String, dynamic> toJson() => {
    'examTypeId': examTypeId,
    'examGroupId': examGroupId,
    'quizResults': quizResults.map((r) => r.toJson()).toList(),
    'claimedRewardStepIds': claimedRewardStepIds,
    'acornBalance': acornBalance,
    'energyCount': energyCount,
    'energyRefreshedAtMs': energyRefreshedAtMs,
  };

  GuestState copyWith({
    String? Function()? examTypeId,
    String? Function()? examGroupId,
    List<GuestQuizResult>? quizResults,
    List<String>? claimedRewardStepIds,
    int? acornBalance,
    int? energyCount,
    int? Function()? energyRefreshedAtMs,
  }) {
    return GuestState(
      examTypeId: examTypeId != null ? examTypeId() : this.examTypeId,
      examGroupId: examGroupId != null ? examGroupId() : this.examGroupId,
      quizResults: quizResults ?? this.quizResults,
      claimedRewardStepIds: claimedRewardStepIds ?? this.claimedRewardStepIds,
      acornBalance: acornBalance ?? this.acornBalance,
      energyCount: energyCount ?? this.energyCount,
      energyRefreshedAtMs: energyRefreshedAtMs != null
          ? energyRefreshedAtMs()
          : this.energyRefreshedAtMs,
    );
  }
}

class GuestNotifier extends StateNotifier<GuestState> {
  GuestNotifier(this._hive) : super(const GuestState()) {
    state = applyEnergyRegen(_load());
    // Keeps the header's energy current while the app is open.
    _regenTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => refreshEnergy(),
    );
  }

  final HiveStorage _hive;
  late final Timer _regenTimer;

  @override
  void dispose() {
    _regenTimer.cancel();
    super.dispose();
  }

  GuestState _load() {
    final raw = _hive.guestBox.get(_stateKey);
    if (raw == null) return const GuestState();
    try {
      return GuestState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const GuestState();
    }
  }

  void _save(GuestState next) {
    state = next;
    unawaited(_hive.guestBox.put(_stateKey, jsonEncode(next.toJson())));
  }

  /// Adds 1 energy per elapsed 10 minutes (docs 10.4).
  @visibleForTesting
  static GuestState applyEnergyRegen(GuestState s) {
    final startedAt = s.energyRefreshedAtMs;
    if (s.energyCount >= maxEnergy || startedAt == null) return s;
    final elapsed = DateTime.now().millisecondsSinceEpoch - startedAt;
    final toAdd = elapsed ~/ energyRegenInterval.inMilliseconds;
    if (toAdd <= 0) return s;
    final energy = min(maxEnergy, s.energyCount + toAdd);
    return s.copyWith(
      energyCount: energy,
      energyRefreshedAtMs: () => energy >= maxEnergy
          ? null
          : startedAt + toAdd * energyRegenInterval.inMilliseconds,
    );
  }

  /// Exam picked on the welcome screen (web: `guestExamTypeId`).
  void setExamType({required String examTypeId, String? examGroupId}) => _save(
    state.copyWith(
      examTypeId: () => examTypeId,
      examGroupId: () => examGroupId,
    ),
  );

  void refreshEnergy() {
    final next = applyEnergyRegen(state);
    if (!identical(next, state)) _save(next);
  }

  /// Docs 10.4 `setEnergy`: clamps and starts/stops the regen timer.
  void setEnergy(int count) {
    final clamped = count.clamp(0, maxEnergy);
    final wasFull = state.energyCount >= maxEnergy;
    final now = DateTime.now().millisecondsSinceEpoch;
    var refreshedAt = state.energyRefreshedAtMs;
    if (clamped >= maxEnergy) {
      refreshedAt = null;
    } else if (wasFull || refreshedAt == null) {
      refreshedAt = now;
    }
    _save(
      state.copyWith(
        energyCount: clamped,
        energyRefreshedAtMs: () => refreshedAt,
      ),
    );
  }

  void addQuizResult(GuestQuizResult result) =>
      _save(state.copyWith(quizResults: [...state.quizResults, result]));

  void gainAcorns(int amount) =>
      _save(state.copyWith(acornBalance: state.acornBalance + amount));

  /// Returns false when the balance is too low.
  bool spendAcorns(int amount) {
    if (state.acornBalance < amount) return false;
    _save(state.copyWith(acornBalance: state.acornBalance - amount));
    return true;
  }

  /// Opens a chest locally (docs 10.7).
  void claimReward(String stepId, int amount) {
    if (state.claimedRewardStepIds.contains(stepId)) return;
    _save(
      state.copyWith(
        claimedRewardStepIds: [...state.claimedRewardStepIds, stepId],
        acornBalance: state.acornBalance + amount,
      ),
    );
  }

  /// Fields added to `POST /auth/register` (docs 10.8).
  Map<String, dynamic> registrationPayload() {
    refreshEnergy();
    return {
      'acorn_balance': state.acornBalance,
      'energy': state.energyCount,
      'guest_data': {
        'quiz_results': state.quizResults.map((r) => r.toJson()).toList(),
        'claimed_reward_step_ids': state.claimedRewardStepIds,
      },
    };
  }

  /// After login: merges guest progress into the account (docs 10.9). Guest
  /// data is kept when the merge fails so it can be retried.
  Future<void> mergeAfterLogin(AuthRepository repo) async {
    if (!state.hasProgress) {
      clear();
      return;
    }
    try {
      await repo.mergeGuestProgress(
        quizResults: state.quizResults.map((r) => r.toJson()).toList(),
        claimedRewards: state.claimedRewardStepIds,
        earnedAcorns: max(0, state.acornBalance - _initialAcorns),
      );
      clear();
    } catch (_) {
      // Keep guest data for the next login.
    }
  }

  /// Removes guest progress; [guestId] is kept (docs 10.1).
  /// Forgets the chosen exam but keeps progress, energy and acorns (web
  /// removes only `guestExamTypeId` when that exam no longer exists).
  void clearExamType() => _save(
    state.copyWith(examTypeId: () => null, examGroupId: () => null),
  );

  void clear() {
    state = const GuestState();
    unawaited(_hive.guestBox.delete(_stateKey));
  }

  /// Stable anonymous UUID v4 for guest question reports (docs 9.2).
  String get guestId {
    final box = _hive.guestBox;
    final existing = box.get(_guestIdKey);
    if (existing != null) return existing;
    final id = _uuidV4();
    unawaited(box.put(_guestIdKey, id));
    return id;
  }

  /// Fills step progress from local results (docs 10.6, web
  /// `overlayGuestProgress`).
  CourseModel overlayProgress(CourseModel course) {
    final results = state.quizResults;
    final claimed = state.claimedRewardStepIds;
    return course.copyWith(
      topics: [
        for (final topic in course.topics)
          topic.copyWith(
            steps: [
              for (final step in topic.steps)
                if (step.progress != null)
                  step
                else if (step.type == StepType.reward)
                  step.copyWith(
                    progress: UserStepProgress(
                      id: '',
                      userId: '',
                      stepId: step.id,
                      isStepCompleted: claimed.contains(step.id),
                    ),
                  )
                else
                  _lessonProgress(
                    step,
                    results.where((r) => r.stepId == step.id).toList(),
                  ),
            ],
          ),
      ],
    );
  }

  StepModel _lessonProgress(StepModel step, List<GuestQuizResult> results) {
    final done = results.isNotEmpty;
    final best = results.fold<int>(
      0,
      (best, r) => max(
        best,
        r.totalQuestions > 0
            ? (r.correctCount / r.totalQuestions * 100).round()
            : 0,
      ),
    );
    return step.copyWith(
      progress: UserStepProgress(
        id: '',
        userId: '',
        stepId: step.id,
        testsCompleted: done ? 1 : 0,
        isStepCompleted: done,
        stepFinalPassed: done,
        bestScore: best,
      ),
    );
  }

  static String _uuidV4() {
    final rnd = Random.secure();
    final bytes = List<int>.generate(16, (_) => rnd.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }
}
