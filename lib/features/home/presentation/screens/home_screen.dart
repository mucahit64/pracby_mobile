import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/api/api_exception.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/storage/hive_storage.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_icon.dart';
import 'package:pracby_mobile/core/widgets/pb_loading.dart';
import 'package:pracby_mobile/features/auth/data/models/user_model.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';
import 'package:pracby_mobile/features/home/presentation/providers/course_provider.dart';
import 'package:pracby_mobile/features/home/presentation/widgets/map_dialogs.dart';
import 'package:pracby_mobile/features/home/presentation/widgets/map_selection_sheet.dart';
import 'package:pracby_mobile/features/home/presentation/widgets/lesson_map_node.dart';
import 'package:pracby_mobile/features/onboarding/data/exam_groups_repository.dart';
import 'package:pracby_mobile/features/home/presentation/widgets/status_top_bar.dart';
import 'package:pracby_mobile/features/offline/offline_queue.dart';
import 'package:pracby_mobile/features/profile/data/models/enrollment_model.dart';
import 'package:pracby_mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:pracby_mobile/features/quiz/data/quiz_repository.dart';
import 'package:pracby_mobile/features/store/presentation/providers/store_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const _moduleKey = 'pb_selectedModuleId';
  static const _courseKey = 'pb_selectedCourseId';

  String? _selectedModuleId;
  String? _selectedCourseId;

  @override
  void initState() {
    super.initState();
    // Remember the module / course across visits, like the web (docs 5).
    final prefs = ref.read(hiveStorageProvider).prefsBox;
    _selectedModuleId = prefs.get(_moduleKey);
    _selectedCourseId = prefs.get(_courseKey);
  }

  /// A guest whose exam was removed or deactivated goes back to exam
  /// selection, like the web (docs 4). A failed request (offline) keeps the
  /// exam.
  void _checkGuestExamExists(String examTypeId) {
    final groups = ref.watch(examGroupsProvider).valueOrNull;
    if (groups == null) return;
    final exists = groups.any(
      (g) => g.isActive && g.examTypes.any((t) => t.id == examTypeId),
    );
    if (exists) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Navigate first: without an exam the router no longer allows home.
      context.go(Routes.examSelect);
      ref.read(guestProvider.notifier).clearExamType();
    });
  }

  /// Updates the map selection and persists it (null clears it).
  void _select({required String? moduleId, required String? courseId}) {
    setState(() {
      _selectedModuleId = moduleId;
      _selectedCourseId = courseId;
    });
    final prefs = ref.read(hiveStorageProvider).prefsBox;
    moduleId == null
        ? prefs.delete(_moduleKey)
        : prefs.put(_moduleKey, moduleId);
    courseId == null
        ? prefs.delete(_courseKey)
        : prefs.put(_courseKey, courseId);
  }

  @override
  Widget build(BuildContext context) {
    // Reset exam/module/course selection whenever the logged-in user changes
    // so stale selections from a previous user don't persist.
    ref.listen<AsyncValue<UserModel?>>(authStateProvider, (prev, next) {
      final prevId = prev?.valueOrNull?.id;
      final nextId = next.valueOrNull?.id;
      if (prevId != nextId) {
        _select(moduleId: null, courseId: null);
      }
    });

    final user = ref.watch(authStateProvider).valueOrNull;
    final guestExamId = ref.watch(guestProvider.select((g) => g.examTypeId));
    // A guest's exam lives on the device; they have no enrollments (docs 10).
    final isGuest = user == null && guestExamId != null;
    if (isGuest) _checkGuestExamExists(guestExamId);
    final enrollmentsAsync = ref.watch(enrollmentsProvider);

    final enrolled = enrollmentsAsync.valueOrNull ?? const [];
    // The user's active exam, unless it is no longer enrolled.
    final activeExamId = isGuest
        ? guestExamId
        : enrolled.isEmpty ||
              enrolled.any((e) => e.examTypeId == user?.activeExamId)
        ? user?.activeExamId
        : enrolled.first.examTypeId;

    // Watch modules
    final modulesAsync = activeExamId != null
        ? ref.watch(modulesProvider(activeExamId))
        : const AsyncValue<List<ModuleModel>>.data([]);
    final modules = modulesAsync.valueOrNull ?? [];
    // A remembered module from another exam falls back to the first one.
    final activeModuleId = modules.isEmpty
        ? null
        : modules.any((m) => m.id == _selectedModuleId)
        ? _selectedModuleId
        : modules.first.id;

    // Watch courses for the active module (or exam)
    final coursesAsync = activeModuleId != null
        ? ref.watch(coursesByModuleProvider((activeExamId!, activeModuleId)))
        : activeExamId != null
        ? ref.watch(coursesByExamProvider(activeExamId))
        : const AsyncValue<List<CourseModel>>.data([]);
    final courses = coursesAsync.valueOrNull ?? [];
    final activeCourseId = courses.isNotEmpty
        ? (_selectedCourseId ?? courses.first.id)
        : null;
    // Validate that the saved course still belongs to this module
    final activeCourseIdValidated = courses.any((c) => c.id == activeCourseId)
        ? activeCourseId
        : courses.isNotEmpty
        ? courses.first.id
        : null;

    Widget map() => activeCourseIdValidated != null
        ? _buildSingleCourseRoadmap(context, activeCourseIdValidated)
        : activeExamId != null
        ? _buildFilteredRoadmap(context, activeExamId, moduleId: activeModuleId)
        : _buildRoadmapContent(context, user);

    // The exam / module / course tab rows took too much of the screen; the
    // top bar opens a picker instead.
    final activeCourse = courses
        .where((c) => c.id == activeCourseIdValidated)
        .firstOrNull;
    final selector = activeExamId == null || activeCourse == null
        ? null
        : _MapSelectorButton(
            label: activeCourse.title,
            onTap: () => _openMapSelection(
              enrollments: enrolled,
              examTypeId: activeExamId,
              moduleId: activeModuleId,
              courseId: activeCourse.id,
            ),
          );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: StatusTopBar(leading: selector),
      body: isGuest
          ? map()
          : enrollmentsAsync.when(
              // A reload keeps showing the map (and its scroll position).
              skipLoadingOnReload: true,
              loading: () => const PbLoading(),
              error: (e, _) => _buildRoadmapContent(context, user),
              data: (enrollments) => enrollments.isEmpty
                  ? _buildNoEnrollmentState(context)
                  : map(),
            ),
    );
  }

  /// Applies a choice from the map picker. A new exam is saved first; if
  /// that fails the map stays as it was.
  Future<void> _openMapSelection({
    required List<EnrollmentModel> enrollments,
    required String examTypeId,
    required String? moduleId,
    required String courseId,
  }) async {
    final picked = await showMapSelectionSheet(
      context,
      enrollments: enrollments,
      examTypeId: examTypeId,
      moduleId: moduleId,
      courseId: courseId,
    );
    if (picked == null || !mounted) return;
    if (picked.examTypeId != examTypeId &&
        !await _switchExam(picked.examTypeId)) {
      return;
    }
    _select(moduleId: picked.moduleId, courseId: picked.courseId);
  }

  /// Changing the exam clears the module / course (web `switchExam`).
  /// Returns false if it couldn't be saved.
  Future<bool> _switchExam(String examTypeId) async {
    final messenger = ScaffoldMessenger.of(context);
    final previous = (module: _selectedModuleId, course: _selectedCourseId);
    _select(moduleId: null, courseId: null);
    try {
      await ref.read(authStateProvider.notifier).setActiveExam(examTypeId);
      return true;
    } on ApiException catch (e) {
      if (!mounted) return false;
      _select(moduleId: previous.module, courseId: previous.course);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            e.isNetworkError
                ? 'Sınav değiştirmek için internet bağlantısı gerekli.'
                : e.message,
          ),
        ),
      );
      return false;
    }
  }

  Widget _buildSingleCourseRoadmap(BuildContext context, String courseId) {
    return ListView(
      children: [
        _CourseRoadmapSection(
          course: CourseModel(id: courseId, title: ''),
          onStart: (topicId, stepId, sessionType) => context.push(
            Routes.quizPath(topicId, stepId: stepId, sessionType: sessionType),
          ),
        ),
      ],
    );
  }

  Widget _buildFilteredRoadmap(
    BuildContext context,
    String examTypeId, {
    String? moduleId,
  }) {
    final coursesAsync = moduleId != null
        ? ref.watch(coursesByModuleProvider((examTypeId, moduleId)))
        : ref.watch(coursesByExamProvider(examTypeId));
    return coursesAsync.when(
      loading: () => const PbLoading(),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text('Bir hata oluştu: $e'),
            TextButton(
              onPressed: () => moduleId != null
                  ? ref.invalidate(
                      coursesByModuleProvider((examTypeId, moduleId)),
                    )
                  : ref.invalidate(coursesByExamProvider(examTypeId)),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
      data: (courses) => _buildCourseRoadmap(context, courses),
    );
  }

  Widget _buildCourseRoadmap(BuildContext context, List<CourseModel> courses) {
    if (courses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PbIcon(PbIcons.book, size: 56),
            SizedBox(height: 16),
            Text(
              'Bu sınav için henüz içerik eklenmedi.',
              style: TextStyle(fontSize: 16, color: AppColors.grey500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Flatten: show each course's full roadmap fetched lazily
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, i) => _CourseRoadmapSection(
        course: courses[i],
        onStart: (topicId, stepId, sessionType) => context.push(
          Routes.quizPath(topicId, stepId: stepId, sessionType: sessionType),
        ),
      ),
    );
  }

  Widget _buildNoEnrollmentState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.school_outlined,
              size: 64,
              color: AppColors.grey300,
            ),
            const SizedBox(height: 16),
            const Text(
              'Henüz bir sınava kayıt olmadın',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.grey700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Profil sayfasından sınav ekleyerek öğrenmeye başlayabilirsin.',
              style: TextStyle(fontSize: 14, color: AppColors.grey500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push(Routes.examSelect),
              icon: const Icon(Icons.add),
              label: const Text('Sınav Ekle'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoadmapContent(BuildContext context, UserModel? user) {
    final coursesAsync = ref.watch(coursesProvider);
    return coursesAsync.when(
      loading: () => const PbLoading(),
      error: (e, _) => Center(child: Text('Hata: $e')),
      data: (courses) => _buildCourseRoadmap(context, courses),
    );
  }
}

class _CourseRoadmapSection extends ConsumerWidget {
  const _CourseRoadmapSection({required this.course, required this.onStart});

  final CourseModel course;

  /// Opens the quiz (web route /quiz/:topicId?stepId&sessionType).
  final void Function(String topicId, String? stepId, String sessionType)
  onStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseFullAsync = ref.watch(courseFullProvider(course.id));

    // Offline, a failed refresh keeps showing the last loaded map.
    return courseFullAsync.when(
      skipError: true,
      // New guest results rebuild this provider; keep the map on screen
      // instead of a loader so the scroll position doesn't jump.
      skipLoadingOnReload: true,
      loading: () => const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (e, _) => _MapLoadError(
        error: e,
        onRetry: () => ref.invalidate(courseFullProvider(course.id)),
      ),
      data: (full) {
        if (full.topics.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...full.topics.asMap().entries.map((entry) {
              final idx = entry.key;
              final topic = entry.value;
              final colors = topicColors[idx % topicColors.length];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Section header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colors.color,
                        borderRadius: BorderRadius.circular(16),
                        border: Border(
                          bottom: BorderSide(color: colors.shadow, width: 4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BÖLÜM ${idx + 1}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white70,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            topic.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Nodes
                  _buildTopicNodes(context, ref, topic, colors, full.id),
                ],
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildTopicNodes(
    BuildContext context,
    WidgetRef ref,
    TopicModel topic,
    TopicColor color,
    String courseId,
  ) {
    final nodes = buildLessonNodes(
      topic,
      openedChests: ref.watch(openedChestsProvider),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          for (final (i, node) in nodes.indexed)
            Padding(
              // Shift by layout, not Transform.translate: a translated node
              // only took taps where it still overlapped its unshifted box,
              // so the right side of the button did nothing.
              padding: EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: nodeOffset(i) * 2,
              ),
              child: MapNodeView(
                node: node,
                topicColor: color,
                onTap: _isTappable(node)
                    ? () => _onNodeTap(context, ref, topic, node, courseId)
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  /// Online only when nothing is queued before it: the server checks that
  /// the lesson before the chest is done, and that lesson may still be in
  /// the offline queue. Otherwise the chest is opened locally and queued
  /// (docs 7.5.1); the map shows it opened from the queue.
  Future<void> _claimAsMember(
    WidgetRef ref,
    StepModel step,
    int amount,
    String courseId,
  ) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;
    final queue = ref.read(offlineQueueProvider);
    final auth = ref.read(authStateProvider.notifier);
    // Store-item chests only change the inventory, not the acorn balance.
    final acornReward = step.rewardType == 'store_item' ? 0 : amount;
    try {
      if (await queue.flush(user.id)) {
        await ref.read(quizRepositoryProvider).claimReward(stepId: step.id);
        auth.setBalances(acorns: user.acorns + acornReward);
        ref.invalidate(courseFullProvider(courseId));
        return;
      }
    } on ApiException catch (e) {
      // Rejected by the server: silently ignored, like the web client. The
      // chest shows closed again.
      if (!e.isNetworkError) {
        ref
            .read(openedChestsProvider.notifier)
            .update((ids) => {...ids}..remove(step.id));
        return;
      }
    }
    await queue.enqueueClaim(userId: user.id, stepId: step.id);
    auth.setBalances(acorns: user.acorns + acornReward);
  }

  /// Locked lessons / boss and claimed chests are disabled (web).
  bool _isTappable(MapNode node) => switch (node.type) {
    MapNodeType.chest => node.status == MapNodeStatus.active,
    _ => node.status != MapNodeStatus.locked,
  };

  /// Web `goToLesson`: chest → reward dialog; lesson / boss → energy check,
  /// then "Teste Hazır mısın?".
  Future<void> _onNodeTap(
    BuildContext context,
    WidgetRef ref,
    TopicModel topic,
    MapNode node,
    String courseId,
  ) async {
    final step = node.step;
    if (node.type == MapNodeType.chest && step != null) {
      final amount = step.rewardAmount ?? 10;
      final claim = await showRewardStepDialog(context, rewardAmount: amount);
      if (!claim) return;
      // Open the chest and unlock the next lesson now, not after the
      // requests below.
      ref
          .read(openedChestsProvider.notifier)
          .update((ids) => {...ids, step.id});
      if (ref.read(authStateProvider).valueOrNull == null) {
        // Guest: opened locally; the map re-renders from guest state.
        ref.read(guestProvider.notifier).claimReward(step.id, amount);
        return;
      }
      await _claimAsMember(ref, step, amount, courseId);
      return;
    }

    final user = ref.read(authStateProvider).valueOrNull;
    final energy = user?.energy ?? ref.read(guestProvider).energyCount;
    final unlimited = hasUnlimitedEnergy(
      ref.read(activeEffectsProvider).valueOrNull ?? const [],
    );
    if (energy <= 0 && !unlimited) {
      final goStore = await showEnergyOutDialog(context);
      if (goStore && context.mounted) context.go(Routes.store);
      return;
    }
    if (!context.mounted) return;
    final start = await showStepPreviewDialog(context);
    if (!start) return;
    if (node.type == MapNodeType.boss) {
      // Topic final: no step (docs 6.4).
      onStart(topic.id, null, 'topic_final');
    } else {
      onStart(topic.id, step?.id, 'lesson');
    }
  }
}

/// The course shown on the map; opens the exam / module / course picker.
class _MapSelectorButton extends StatelessWidget {
  const _MapSelectorButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.grey100,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.grey800,
                  ),
                ),
              ),
              const Icon(Icons.expand_more, size: 22, color: AppColors.grey500),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown instead of an empty map when the lesson map can't be loaded.
class _MapLoadError extends StatelessWidget {
  const _MapLoadError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final offline =
        error is ApiException && (error as ApiException).isNetworkError;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      child: Column(
        children: [
          const Text(
            'Harita yüklenemedi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            offline
                ? 'İnternet bağlantını kontrol edip tekrar dene.'
                : 'Bir sorun oluştu. Tekrar dene; sorun sürerse bize bildir.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.grey500),
          ),
          if (!offline) ...[
            const SizedBox(height: 8),
            // Lets a user report what went wrong.
            SelectableText(
              error is ApiException
                  ? (error as ApiException).message
                  : '$error',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.grey400),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('Tekrar Dene')),
        ],
      ),
    );
  }
}
