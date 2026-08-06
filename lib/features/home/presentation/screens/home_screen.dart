import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_loading.dart';
import 'package:pracby_mobile/features/auth/data/models/user_model.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';
import 'package:pracby_mobile/features/home/presentation/providers/course_provider.dart';
import 'package:pracby_mobile/features/home/presentation/widgets/roadmap_node.dart';
import 'package:pracby_mobile/features/profile/data/models/enrollment_model.dart';
import 'package:pracby_mobile/features/profile/data/user_repository.dart';
import 'package:pracby_mobile/features/profile/presentation/providers/profile_provider.dart';

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
  String? _selectedExamTypeId;
  String? _selectedModuleId;
  String? _selectedCourseId;

  @override
  Widget build(BuildContext context) {
    // Reset exam/module/course selection whenever the logged-in user changes
    // so stale selections from a previous user don't persist.
    ref.listen<AsyncValue<UserModel?>>(authStateProvider, (prev, next) {
      final prevId = prev?.valueOrNull?.id;
      final nextId = next.valueOrNull?.id;
      if (prevId != nextId) {
        setState(() {
          _selectedExamTypeId = null;
          _selectedModuleId = null;
          _selectedCourseId = null;
        });
      }
    });

    final user = ref.watch(authStateProvider).valueOrNull;
    final enrollmentsAsync = ref.watch(enrollmentsProvider);

    final firstEnrollmentId = enrollmentsAsync.valueOrNull?.isNotEmpty ?? false
        ? enrollmentsAsync.valueOrNull!.first.examTypeId
        : null;
    final activeExamId =
        _selectedExamTypeId ?? user?.activeExamId ?? firstEnrollmentId;

    // Watch modules
    final modulesAsync = activeExamId != null
        ? ref.watch(modulesProvider(activeExamId))
        : const AsyncValue<List<ModuleModel>>.data([]);
    final modules = modulesAsync.valueOrNull ?? [];
    final activeModuleId =
        modules.isNotEmpty ? (_selectedModuleId ?? modules.first.id) : null;

    // Watch courses for the active module (or exam)
    final coursesAsync = activeModuleId != null
        ? ref.watch(coursesByModuleProvider((activeExamId!, activeModuleId)))
        : activeExamId != null
            ? ref.watch(coursesByExamProvider(activeExamId))
            : const AsyncValue<List<CourseModel>>.data([]);
    final courses = coursesAsync.valueOrNull ?? [];
    final activeCourseId =
        courses.isNotEmpty ? (_selectedCourseId ?? courses.first.id) : null;
    // Validate that the saved course still belongs to this module
    final activeCourseIdValidated = courses.any((c) => c.id == activeCourseId)
        ? activeCourseId
        : courses.isNotEmpty
            ? courses.first.id
            : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildTopBar(context, user),
      body: enrollmentsAsync.when(
        loading: () => const PbLoading(),
        error: (e, _) => _buildRoadmapContent(context, user),
        data: (enrollments) {
          if (enrollments.isEmpty) {
            return _buildNoEnrollmentState(context);
          }
          return Column(
            children: [
              if (enrollments.isNotEmpty)
                _buildExamTabs(context, enrollments, activeExamId),
              if (activeExamId != null && modules.isNotEmpty)
                _buildModuleTabs(context, modules, activeModuleId),
              if (courses.length > 1)
                _buildCourseTabs(context, courses, activeCourseIdValidated),
              Expanded(
                child: activeCourseIdValidated != null
                    ? _buildSingleCourseRoadmap(
                        context, activeCourseIdValidated)
                    : activeExamId != null
                        ? _buildFilteredRoadmap(
                            context, activeExamId,
                            moduleId: activeModuleId)
                        : _buildRoadmapContent(context, user),
              ),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildTopBar(BuildContext context, UserModel? user) {
    final stats = ref.watch(userStatsProvider).valueOrNull;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_fire_department, color: Color(0xFFEF4444), size: 22),
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
            '${user?.acorns ?? 0}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(width: 20),
          const Icon(Icons.battery_charging_full, color: Color(0xFF22C55E), size: 22),
          const SizedBox(width: 4),
          Text(
            '${user?.energy ?? 0}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.grey800,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: AppColors.grey700),
          onPressed: () => context.push(Routes.notifications),
        ),
      ],
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
              setState(() {
                _selectedExamTypeId = e.examTypeId;
                _selectedModuleId = null;
                _selectedCourseId = null;
              });
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
            onTap: () => setState(() {
              _selectedModuleId = m.id;
              _selectedCourseId = null; // reset course when module changes
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color:
                      isSelected ? AppColors.primary : AppColors.grey300,
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
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: courses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final c = courses[index];
          final isSelected = c.id == activeCourseId;
          return GestureDetector(
            onTap: () => setState(() => _selectedCourseId = c.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 3),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.grey200,
                ),
              ),
              child: Text(
                c.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                      isSelected ? AppColors.primary : AppColors.grey600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSingleCourseRoadmap(
      BuildContext context, String courseId) {
    return ListView(
      children: [
        _CourseRoadmapSection(
          course: CourseModel(
            id: courseId,
            title: '',
          ),
          onStepTap: (stepId, topicId) => context
              .push(Routes.quizWithId(stepId), extra: {'topicId': topicId}),
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
                      coursesByModuleProvider((examTypeId, moduleId)))
                  : ref.invalidate(coursesByExamProvider(examTypeId)),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
      data: (courses) => _buildCourseRoadmap(context, courses),
    );
  }

  Widget _buildCourseRoadmap(
    BuildContext context,
    List<CourseModel> courses,
  ) {
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
        onStepTap: (stepId, topicId) =>
            context.push(Routes.quizWithId(stepId), extra: {'topicId': topicId}),
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
            const Icon(Icons.school_outlined,
                size: 64, color: AppColors.grey300),
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
  const _CourseRoadmapSection({
    required this.course,
    required this.onStepTap,
  });

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
          child: RoadmapNode(
            topic: topic,
            alignment: 0,
            onTap: () => _showStepDialog(context, topic, null, _StepStatus.active),
          ),
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
        final alignment =
            _zigzagAlignment(topicIndex * steps.length + stepIdx);
        return GestureDetector(
          onTap: status != _StepStatus.locked
              ? () => _showStepDialog(context, topic, step, status)
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

  void _showStepDialog(
    BuildContext context,
    TopicModel topic,
    StepModel? step,
    _StepStatus status,
  ) {
    // Reward step gets its own dialog
    if (step != null && step.type == StepType.reward) {
      showDialog<void>(
        context: context,
        builder: (ctx) => _RewardStepDialog(
          step: step,
          topic: topic,
        ),
      );
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _StepPreviewSheet(
        topic: topic,
        step: step,
        onStart: () {
          Navigator.pop(ctx);
          if (step != null) {
            onStepTap(step.id, topic.id);
          }
        },
      ),
    );
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

class _StepPreviewSheet extends StatelessWidget {
  const _StepPreviewSheet({
    required this.topic,
    required this.step,
    required this.onStart,
  });

  final TopicModel topic;
  final StepModel? step;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final stepLabel = step != null
        ? (step!.type == StepType.reward
            ? 'Ödül'
            : 'Ders')
        : 'Konu';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
            child: Center(
              child: Icon(
                step?.type == StepType.reward
                    ? Icons.card_giftcard
                    : Icons.menu_book,
                color: AppColors.primary,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            topic.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.grey900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              stepLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: step != null ? onStart : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Başlat',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'İptal',
              style: TextStyle(color: AppColors.grey500),
            ),
          ),
        ],
      ),
    );
  }
}



class _RewardStepDialog extends StatelessWidget {
  const _RewardStepDialog({required this.step, required this.topic});

  final StepModel step;
  final TopicModel topic;

  @override
  Widget build(BuildContext context) {
    final rewardType = step.rewardType ?? 'acorn';
    final rewardAmount = step.rewardAmount ?? 0;

    final (icon, iconColor, label) = switch (rewardType) {
      'acorn' => (Icons.eco, AppColors.accent, '$rewardAmount Meşe Palamudu'),
      'energy' => (Icons.battery_charging_full, const Color(0xFF22C55E), '$rewardAmount Enerji'),
      'item' => (Icons.card_giftcard, AppColors.primary, 'Özel Ödül'),
      _ => (Icons.star, AppColors.accent, 'Ödül'),
    };

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withValues(alpha: 0.12),
              ),
              child: Icon(icon, size: 40, color: iconColor),
            ),
            const SizedBox(height: 16),
            const Text(
              '🎉 Tebrikler!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              topic.title,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: iconColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: iconColor, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: iconColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              step.description ??
                  'Bu bölümü tamamladığın için ödül kazandın!',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.grey600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Harika!',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
