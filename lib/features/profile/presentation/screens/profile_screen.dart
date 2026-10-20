import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/utils/level_progress.dart';
import 'package:pracby_mobile/core/widgets/pb_loading.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/profile/data/models/streak_day.dart';
import 'package:pracby_mobile/features/profile/data/models/user_stats.dart';
import 'package:pracby_mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:pracby_mobile/features/profile/presentation/widgets/enrollment_list.dart';
import 'package:pracby_mobile/features/profile/presentation/widgets/week_streak_row.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final statsAsync = ref.watch(userStatsProvider);
    final achievementsAsync = ref.watch(achievementsProvider);
    final enrollmentsAsync = ref.watch(enrollmentsProvider);
    final streakDays = ref.watch(streakHistoryProvider).valueOrNull ?? const [];

    if (user == null) return const PbLoading();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(Routes.editProfile),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Avatar + Name
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      user.username.isNotEmpty
                          ? user.username[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.username,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.grey500),
                  ),
                ],
              ),
            ),
            if (statsAsync.valueOrNull case final stats?) ...[
              const SizedBox(height: 20),
              _LevelBar(LevelProgress.fromTotalXp(stats.totalXp)),
            ],
            const SizedBox(height: 24),

            // Stats grid
            statsAsync.when(
              loading: () => const PbLoading(),
              error: (_, __) => const SizedBox.shrink(),
              data: (stats) =>
                  _buildStatsSection(context, stats, acorns: user.acorns),
            ),
            const SizedBox(height: 24),

            // Weekly streak section
            statsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (stats) => _buildStreakSection(context, stats, streakDays),
            ),
            const SizedBox(height: 24),

            // Achievements
            achievementsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (achievements) =>
                  _buildAchievementsSection(context, achievements),
            ),
            const SizedBox(height: 24),

            // Enrolled exams
            enrollmentsAsync.when(
              loading: () => const PbLoading(),
              error: (_, __) => const SizedBox.shrink(),
              data: (enrollments) => EnrollmentList(enrollments: enrollments),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Same five cards as the web profile. weekly_xp / daily_xp aren't shown:
  /// the server never updates them, so they were always 0 (docs 16.3, 19).
  Widget _buildStatsSection(
    BuildContext context,
    UserStats stats, {
    required int acorns,
  }) {
    final number = NumberFormat.decimalPattern('tr');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'İstatistikler',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _StatCard(
              label: 'Toplam XP',
              value: number.format(stats.totalXp),
              icon: Icons.bolt,
              iconColor: AppColors.accent,
            ),
            const SizedBox(width: 8),
            _StatCard(
              label: 'Güncel Seri',
              value: '${stats.currentStreak}',
              icon: Icons.local_fire_department,
              iconColor: AppColors.error,
            ),
            const SizedBox(width: 8),
            _StatCard(
              label: 'En Uzun Seri',
              value: '${stats.maxStreak}',
              icon: Icons.emoji_events,
              iconColor: const Color(0xFFD97706),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _StatCard(
              label: 'Quiz',
              value: '${stats.quizzesDone}',
              icon: Icons.track_changes,
            ),
            const SizedBox(width: 8),
            _StatCard(
              label: 'Acorn',
              value: number.format(acorns),
              icon: Icons.eco,
              iconColor: AppColors.acorn,
            ),
            const SizedBox(width: 8),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildStreakSection(
    BuildContext context,
    UserStats stats,
    List<StreakDay> days,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.error.withValues(alpha: 0.08),
            AppColors.accent.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 40)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${stats.currentStreak} günlük seri',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'En yüksek: ${stats.maxStreak} gün',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (days.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Bu Haftaki Seri',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.grey600,
              ),
            ),
            const SizedBox(height: 10),
            WeekStreakRow(days: days),
          ],
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(
    BuildContext context,
    List<Achievement> achievements,
  ) {
    if (achievements.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Başarımlar',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              '${achievements.length} kazanıldı',
              style: const TextStyle(fontSize: 13, color: AppColors.grey500),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, i) {
            final a = achievements[i];
            final isEarned = a.earnedAt != null;
            return Tooltip(
              message: '${a.title}\n${a.description}',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: isEarned
                          ? AppColors.accent.withValues(alpha: 0.12)
                          : AppColors.grey100,
                      border: Border.all(
                        color: isEarned
                            ? AppColors.accent.withValues(alpha: 0.4)
                            : AppColors.grey200,
                      ),
                    ),
                    child: Center(
                      child: _buildAchievementIcon(a.iconUrl, isEarned),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    a.title,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isEarned ? AppColors.grey700 : AppColors.grey400,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAchievementIcon(String? iconUrl, bool isEarned) {
    final opacity = isEarned ? 1.0 : 0.3;
    if (iconUrl != null && iconUrl.startsWith('http')) {
      return Opacity(
        opacity: opacity,
        child: CachedNetworkImage(
          imageUrl: iconUrl,
          width: 32,
          height: 32,
          errorWidget: (_, __, ___) =>
              const Icon(Icons.emoji_events, size: 26, color: AppColors.accent),
        ),
      );
    }
    // Treat as emoji or short text
    return Opacity(
      opacity: opacity,
      child: Text(iconUrl ?? '🏅', style: const TextStyle(fontSize: 26)),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor = AppColors.primary,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.grey100,
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: AppColors.grey500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// "Seviye N" with progress to the next level (web profile header).
class _LevelBar extends StatelessWidget {
  const _LevelBar(this.progress);

  final LevelProgress progress;

  @override
  Widget build(BuildContext context) {
    const label = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: AppColors.grey500,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Seviye ${progress.level}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            Text(
              '${progress.xpInLevel} / ${LevelProgress.xpPerLevel} XP',
              style: label,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress.fraction,
            minHeight: 12,
            backgroundColor: AppColors.grey100,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
