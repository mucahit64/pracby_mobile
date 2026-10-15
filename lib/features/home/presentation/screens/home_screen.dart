import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/storage/hive_storage.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_loading.dart';
import 'package:pracby_mobile/features/auth/data/models/user_model.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';
import 'package:pracby_mobile/features/home/presentation/providers/course_provider.dart';
import 'package:pracby_mobile/features/home/presentation/widgets/map_dialogs.dart';
import 'package:pracby_mobile/features/home/presentation/widgets/roadmap_node.dart';
import 'package:pracby_mobile/features/profile/data/models/enrollment_model.dart';
import 'package:pracby_mobile/features/profile/data/user_repository.dart';
import 'package:pracby_mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:pracby_mobile/features/quiz/data/quiz_repository.dart';

// Topic header colors — matches web app TOPIC_COLORS
const _kTopicColors = [
  (Color(0xFF3B82F6), Color(0xFF1D4ED8)), // blue
  (Color(0xFF10B981), Color(0xFF047857)), // emerald
  (Color(0xFFF59E0B), Color(0xFFB45309)), // amber
  (Color(0xFFF43F5E), Color(0xFFBE123C)), // rose
  (Color(0xFF8B5CF6), Color(0xFF6D28D9)), // violet
  (Color(0xFF06B6D4), Color(0xFF0E7490)), // cyan
  (Color(0xFFF97316), Color(0xFFC2410C)), // orange
  (Color(0xFFD946EF), Color(0xFFA21CAF)), // fuchsia
  (Color(0xFF14B8A6), Color(0xFF0F766E)), // teal
  (Color(0xFFEF4444), Color(0xFFB91C1C)), // red
];

enum _StepStatus { completed, active, locked }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const _moduleKey = 'pb_selectedModuleId';
  static const _courseKey = 'pb_selectedCourseId';

  String? _selectedExamTypeId;
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
  void _select({
    required String? moduleId,
    required String? courseId,
    String? Function()? examTypeId,
  }) {
    setState(() {
      if (examTypeId != null) _selectedExamTypeId = examTypeId();
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
        _select(moduleId: null, courseId: null, examTypeId: () => null);
      }
    });

    final user = ref.watch(authStateProvider).valueOrNull;
    final guestExamId = ref.watch(guestProvider.select((g) => g.examTypeId));
    // A guest's exam lives on the device; they have no enrollments (docs 10).
    final isGuest = user == null && guestExamId != null;
    final enrollmentsAsync = ref.watch(enrollmentsProvider);

    final firstEnrollmentId = enrollmentsAsync.valueOrNull?.isNotEmpty ?? false
        ? enrollmentsAsync.valueOrNull!.first.examTypeId
        : null;
    final activeExamId = isGuest
        ? guestExamId
        : _selectedExamTypeId ?? user?.activeExamId ?? firstEnrollmentId;

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
              loading: () => const PbLoading(),
              error: (e, _) => _buildRoadmapContent(context, user),
              data: (enrollments) => enrollments.isEmpty
                  ? _buildNoEnrollmentState(context)
                  : map(enrollments: enrollments),
            ),
    );
  }

  PreferredSizeWidget _buildTopBar(BuildContext context, UserModel? user) {
    final stats = ref.watch(userStatsProvider).valueOrNull;
    final guest = ref.watch(guestProvider);
    // Guests show their local balances (docs 10.4, 10.5).
    final acorns = user?.acorns ?? guest.acornBalance;
    final energy = user?.energy ?? guest.energyCount;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Color(0xFFEF4444),
            size: 22,
          ),
          const SizedBox(width: 4),
          Text(
            '${stats?.currentStreak ?? 0}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(width: 20),
          const Icon(Icons.eco, color: AppColors.accent, size: 22),
          const SizedBox(width: 4),
          Text(
            '$acorns',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(width: 20),
          const Icon(
            Icons.battery_charging_full,
            color: Color(0xFF22C55E),
            size: 22,
          ),
          const SizedBox(width: 4),
          Text(
            '$energy',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.grey800,
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
            onTap: () {
              // Changing the exam clears the module / course (web).
              _select(
                moduleId: null,
                courseId: null,
                examTypeId: () => e.examTypeId,
              );
              ref.read(userRepositoryProvider).updateActiveExam(e.examTypeId);
            },
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
          onStepTap: (stepId, topicId) => context.push(
            Routes.quizPath(topicId, stepId: stepId, sessionType: 'lesson'),
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
        onStepTap: (stepId, topicId) => context.push(
          Routes.quizPath(topicId, stepId: stepId, sessionType: 'lesson'),
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
  const _CourseRoadmapSection({required this.course, required this.onStepTap});

  final CourseModel course;
  final void Function(String stepId, String topicId) onStepTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseFullAsync = ref.watch(courseFullProvider(course.id));

    return courseFullAsync.when(
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
              final colors = _kTopicColors[idx % _kTopicColors.length];
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
                        color: colors.$1,
                        borderRadius: BorderRadius.circular(16),
                        border: Border(
                          bottom: BorderSide(color: colors.$2, width: 4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BÖLÜM ${idx + 1}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            topic.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Nodes
                  _buildTopicNodes(context, ref, topic, idx, full.id),
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
    int topicIndex,
    String courseId,
  ) {
    final steps = topic.steps;
    if (steps.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: RoadmapNode(topic: topic, alignment: 0, onTap: () {}),
        ),
      );
    }

    // Compute step statuses: completed → active (first non-completed) → locked
    final isTopicAccessible = topic.progress?.isUnlocked ?? true;
    var foundActive = false;
    final statuses = steps.map((step) {
      if (!isTopicAccessible) return _StepStatus.locked;
      final isCompleted = step.progress?.isStepCompleted ?? false;
      if (isCompleted) return _StepStatus.completed;
      if (!foundActive) {
        foundActive = true;
        return _StepStatus.active;
      }
      return _StepStatus.locked;
    }).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: steps.length,
      itemBuilder: (context, stepIdx) {
        final step = steps[stepIdx];
        final status = statuses[stepIdx];
        final alignment = _zigzagAlignment(topicIndex * steps.length + stepIdx);
        return GestureDetector(
          onTap: status != _StepStatus.locked
              ? () =>
                    _showStepDialog(context, ref, topic, step, status, courseId)
              : null,
          child: Container(
            alignment: Alignment(alignment, 0),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _StepNode(step: step, status: status),
          ),
        );
      },
    );
  }

  double _zigzagAlignment(int index) {
    const positions = [-0.4, 0.0, 0.4, 0.0];
    return positions[index % positions.length];
  }

  Future<void> _showStepDialog(
    BuildContext context,
    WidgetRef ref,
    TopicModel topic,
    StepModel? step,
    _StepStatus status,
    String courseId,
  ) async {
    if (step == null || status == _StepStatus.locked) return;

    // Chest: claimed ones are disabled, open ones show the reward dialog
    // (web pages/index.vue goToLesson / claimReward).
    if (step.type == StepType.reward) {
      if (status == _StepStatus.completed) return;
      final amount = step.rewardAmount ?? 10;
      final claim = await showRewardStepDialog(context, rewardAmount: amount);
      if (!claim) return;
      if (ref.read(authStateProvider).valueOrNull == null) {
        // Guest: opened locally; the map re-renders from guest state.
        ref.read(guestProvider.notifier).claimReward(step.id, amount);
        return;
      }
      try {
        await ref.read(quizRepositoryProvider).claimReward(stepId: step.id);
        final acorns = ref.read(authStateProvider).valueOrNull?.acorns;
        if (acorns != null) {
          ref
              .read(authStateProvider.notifier)
              .setBalances(acorns: acorns + amount);
        }
        ref.invalidate(courseFullProvider(courseId));
      } catch (_) {
        // Silently ignored, like the web client.
      }
      return;
    }

    final user = ref.read(authStateProvider).valueOrNull;
    final energy = user?.energy ?? ref.read(guestProvider).energyCount;
    if (energy <= 0) {
      final goStore = await showEnergyOutDialog(context);
      if (goStore && context.mounted) context.go(Routes.store);
      return;
    }
    if (!context.mounted) return;
    final start = await showStepPreviewDialog(context);
    if (start) onStepTap(step.id, topic.id);
  }
}

class _StepNode extends StatelessWidget {
  const _StepNode({required this.step, required this.status});

  final StepModel step;
  final _StepStatus status;

  @override
  Widget build(BuildContext context) {
    final isLocked = status == _StepStatus.locked;
    final isCompleted = status == _StepStatus.completed;
    final isReward = step.type == StepType.reward;

    Color nodeColor;
    if (isLocked) {
      nodeColor = AppColors.grey300;
    } else if (isReward) {
      nodeColor = AppColors.accent;
    } else if (isCompleted) {
      nodeColor = AppColors.success;
    } else {
      nodeColor = AppColors.primary;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (!isLocked)
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: nodeColor.withValues(alpha: 0.15),
                ),
              ),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: nodeColor,
                boxShadow: isLocked
                    ? null
                    : [
                        BoxShadow(
                          color: nodeColor.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Center(
                child: Icon(
                  isLocked
                      ? Icons.lock
                      : isReward
                      ? Icons.card_giftcard
                      : isCompleted
                      ? Icons.check_circle_outline
                      : Icons.menu_book_outlined,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 90,
          child: Text(
            step.title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isLocked ? AppColors.grey400 : AppColors.grey700,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
