import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/api/api_exception.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/storage/hive_storage.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/countdown.dart';
import 'package:pracby_mobile/core/widgets/pb_loading.dart';
import 'package:pracby_mobile/features/auth/data/models/user_model.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';
import 'package:pracby_mobile/features/home/presentation/providers/course_provider.dart';
import 'package:pracby_mobile/features/home/presentation/widgets/map_dialogs.dart';
import 'package:pracby_mobile/features/home/presentation/widgets/lesson_map_node.dart';
import 'package:pracby_mobile/features/home/presentation/widgets/status_sheets.dart';
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

    Widget map({List<EnrollmentModel> enrollments = const []}) => Column(
      children: [
        if (enrollments.isNotEmpty)
          _buildExamTabs(context, enrollments, activeExamId),
        if (activeExamId != null && modules.isNotEmpty)
          _buildModuleTabs(context, modules, activeModuleId),
        if (courses.length > 1)
          _buildCourseTabs(context, courses, activeCourseIdValidated),
        Expanded(
          child: activeCourseIdValidated != null
              ? _buildSingleCourseRoadmap(context, activeCourseIdValidated)
              : activeExamId != null
              ? _buildFilteredRoadmap(
                  context,
                  activeExamId,
                  moduleId: activeModuleId,
                )
              : _buildRoadmapContent(context, user),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildTopBar(context, user),
      body: isGuest
          ? map()
          : enrollmentsAsync.when(
              // A reload keeps showing the map (and its scroll position).
              skipLoadingOnReload: true,
              loading: () => const PbLoading(),
              error: (e, _) => _buildRoadmapContent(context, user),
              data: (enrollments) => enrollments.isEmpty
                  ? _buildNoEnrollmentState(context)
                  : map(enrollments: enrollments),
            ),
    );
  }

  /// Changing the exam clears the module / course (web `switchExam`).
  Future<void> _switchExam(String examTypeId) async {
    final messenger = ScaffoldMessenger.of(context);
    final previous = (module: _selectedModuleId, course: _selectedCourseId);
    _select(moduleId: null, courseId: null);
    try {
      await ref.read(authStateProvider.notifier).setActiveExam(examTypeId);
    } on ApiException catch (e) {
      if (!mounted) return;
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
    }
  }

  PreferredSizeWidget _buildTopBar(BuildContext context, UserModel? user) {
    final stats = ref.watch(userStatsProvider).valueOrNull;
    final guest = ref.watch(guestProvider);
    final energy = ref.watch(energyStatusProvider);
    // Guests show their local balances (docs 10.4, 10.5).
    final acorns = user?.acorns ?? guest.acornBalance;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _TopBarItem(
            icon: const Icon(
              Icons.local_fire_department,
              color: Color(0xFFEF4444),
              size: 22,
            ),
            label: '${stats?.currentStreak ?? 0}',
            tooltip: 'Seri',
            onTap: () => showStreakSheet(context),
          ),
          const SizedBox(width: 12),
          _TopBarItem(
            icon: const Icon(Icons.eco, color: AppColors.accent, size: 22),
            label: '$acorns',
            tooltip: 'Palamut',
            onTap: () => context.go(Routes.store),
          ),
          const SizedBox(width: 12),
          _TopBarItem(
            icon: const Icon(
              Icons.battery_charging_full,
              color: Color(0xFF22C55E),
              size: 22,
            ),
            label: energy.unlimited ? '∞' : '${energy.count}',
            tooltip: 'Enerji',
            onTap: () => showEnergySheet(context),
            trailing: energy.unlimited || energy.isFull
                ? null
                : Countdown(
                    target: energy.nextEnergyAt,
                    onDone: () => refreshEnergy(ref),
                    builder: (context, remaining) => remaining == null
                        ? const SizedBox.shrink()
                        : _CountdownChip(Countdown.format(remaining)),
                  ),
          ),
        ],
      ),
      // Notifications are hidden until the web client has them.
    );
  }

  Widget _buildExamTabs(
    BuildContext context,
    List<EnrollmentModel> enrollments,
    String? activeId,
  ) {
    return Container(
      height: 48,
      color: Colors.white,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: enrollments.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final e = enrollments[index];
          final isSelected = e.examTypeId == activeId;
          return GestureDetector(
            onTap: () => _switchExam(e.examTypeId),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey300,
                ),
              ),
              child: Text(
                e.examTypeName,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.grey600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModuleTabs(
    BuildContext context,
    List<ModuleModel> modules,
    String? activeModuleId,
  ) {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: AppColors.grey50,
        border: Border(bottom: BorderSide(color: AppColors.grey200)),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: modules.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final m = modules[index];
          final isSelected = m.id == activeModuleId;
          return GestureDetector(
            onTap: () => _select(moduleId: m.id, courseId: null),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey300,
                ),
              ),
              child: Text(
                m.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.grey600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseTabs(
    BuildContext context,
    List<CourseModel> courses,
    String? activeCourseId,
  ) {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.grey100)),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: courses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final c = courses[index];
          final isSelected = c.id == activeCourseId;
          return GestureDetector(
            onTap: () => _select(moduleId: _selectedModuleId, courseId: c.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey200,
                ),
              ),
              child: Text(
                c.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : AppColors.grey600,
                ),
              ),
            ),
          );
        },
      ),
    );
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
            Text('📚', style: TextStyle(fontSize: 48)),
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
      error: (_, __) => const SizedBox.shrink(),
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
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
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
    final nodes = buildLessonNodes(topic);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          for (final (i, node) in nodes.indexed)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Transform.translate(
                offset: Offset(nodeOffset(i), 0),
                child: MapNodeView(
                  node: node,
                  topicColor: color,
                  onTap: _isTappable(node)
                      ? () => _onNodeTap(context, ref, topic, node, courseId)
                      : null,
                ),
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
      // Rejected by the server: silently ignored, like the web client.
      if (!e.isNetworkError) return;
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

/// A header counter (streak, acorns, energy) that opens its details.
class _TopBarItem extends StatelessWidget {
  const _TopBarItem({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.onTap,
    this.trailing,
  });

  final Widget icon;
  final String label;
  final String tooltip;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$tooltip: $label',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.grey800,
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}

/// Time to the next energy, next to the count (web mobile header).
class _CountdownChip extends StatelessWidget {
  const _CountdownChip(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
