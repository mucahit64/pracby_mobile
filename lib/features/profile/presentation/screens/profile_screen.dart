import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/utils/level_progress.dart';
import 'package:pracby_mobile/core/widgets/pb_icon.dart';
import 'package:pracby_mobile/core/widgets/pb_loading.dart';
import 'package:pracby_mobile/features/auth/data/models/user_model.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/profile/data/models/user_stats.dart';
import 'package:pracby_mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:pracby_mobile/features/profile/presentation/widgets/enrollment_list.dart';
import 'package:pracby_mobile/features/profile/presentation/widgets/profile_ui.dart';
import 'package:pracby_mobile/features/profile/presentation/widgets/profile_week_row.dart';

/// Mirrors the web profile page: header card with level, stat cards, this
/// week's streak, achievements, enrolled exams, then edit / sign out.
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

    // Level 1, 0 / 500 XP until the stats arrive (web defaults).
    final progress = LevelProgress.fromTotalXp(
      statsAsync.valueOrNull?.totalXp ?? 0,
    );

    final sections = <Widget>[
      _Header(user: user, progress: progress),

      statsAsync.when(
        loading: () => const PbLoading(),
        error: (_, __) => const SizedBox.shrink(),
        data: (stats) => _StatGrid(stats: stats, acorns: user.acorns),
      ),

      if (streakDays.isNotEmpty)
        _Section(
          icon: PbIcons.calendar,
          title: 'Bu Haftaki Seri',
          child: ProfileWeekRow(days: streakDays),
        ),

      if (achievementsAsync.valueOrNull case final achievements?)
        _Section(
          icon: PbIcons.medal,
          title: 'Başarımlar',
          child: achievements.isEmpty
              ? const _Placeholder('Henüz başarım kazanılmadı.')
              : _AchievementGrid(achievements),
        ),

      _Section(
        icon: PbIcons.graduation,
        title: 'Kayıtlı Sınavlarım',
        child: enrollmentsAsync.when(
          loading: () => const _Placeholder('Yükleniyor…'),
          error: (_, __) => const SizedBox.shrink(),
          data: (enrollments) => EnrollmentList(enrollments: enrollments),
        ),
      ),

      Row(
        children: [
          Expanded(
            child: ProfileOutlineButton(
              label: 'Profili Düzenle',
              icon: const Icon(
                Icons.edit_outlined,
                size: 16,
                color: AppColors.grey400,
              ),
              onPressed: () => context.push(Routes.editProfile),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ProfileOutlineButton(
              label: 'Çıkış',
              color: AppColors.error,
              icon: const PbIcon(PbIcons.door, size: 17),
              onPressed: () => ref.read(authStateProvider.notifier).logout(),
            ),
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      // No streak / acorn / energy bar on this page (unlike the web).
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < sections.length; i++) ...[
                if (i > 0) const SizedBox(height: 28),
                sections[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Avatar with the level badge, name, e-mail and progress to the next level.
class _Header extends StatelessWidget {
  const _Header({required this.user, required this.progress});

  final UserModel user;
  final LevelProgress progress;

  @override
  Widget build(BuildContext context) {
    const small = TextStyle(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w700,
      color: AppColors.grey400,
    );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _Avatar(user.username),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Seviye ${progress.level}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.29,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 20,
                    height: 28 / 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.grey800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 20 / 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey400,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Seviye ${progress.level}', style: small),
                    Text(
                      '${progress.xpInLevel} / ${LevelProgress.xpPerLevel} XP',
                      style: small,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress.fraction,
                    minHeight: 12,
                    backgroundColor: AppColors.grey100,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Purple initial with a darker 4px bottom edge (`rounded-full border-b-4
/// border-primary-dark`).
class _Avatar extends StatelessWidget {
  const _Avatar(this.username);

  final String username;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 64,
        height: 64,
        color: AppColors.primaryDark,
        alignment: Alignment.topCenter,
        child: Container(
          width: 64,
          height: 60,
          alignment: Alignment.center,
          decoration: const ShapeDecoration(
            color: AppColors.primary,
            shape: OvalBorder(),
          ),
          child: Text(
            username.isNotEmpty ? username[0].toUpperCase() : '?',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Same five cards as the web profile, two per row. weekly_xp / daily_xp
/// aren't shown: the server never updates them, so they were always 0
/// (docs 16.3, 19).
class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.stats, required this.acorns});

  final UserStats stats;
  final int acorns;

  @override
  Widget build(BuildContext context) {
    final number = NumberFormat.decimalPattern('tr');
    final cards = [
      _StatCard(PbIcons.xp, number.format(stats.totalXp), 'Toplam XP'),
      _StatCard(PbIcons.fire, '${stats.displayStreak}', 'Güncel Seri'),
      _StatCard(PbIcons.trophy, '${stats.maxStreak}', 'En Uzun Seri'),
      _StatCard(PbIcons.target, '${stats.quizzesDone}', 'Quiz'),
      _StatCard(PbIcons.acorn, number.format(acorns), 'Acorn'),
    ];
    return _Grid(columns: 2, children: cards);
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(this.icon, this.value, this.label);

  final PbIcons icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        children: [
          // PbIcon is 1.2em of text-2xl.
          PbIcon(icon, size: 29),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              height: 28 / 20,
              fontWeight: FontWeight.w900,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            trUpper(label),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppColors.grey400,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementGrid extends StatelessWidget {
  const _AchievementGrid(this.achievements);

  final List<Achievement> achievements;

  @override
  Widget build(BuildContext context) {
    return _Grid(
      columns: 3,
      children: [for (final a in achievements) _AchievementCard(a)],
    );
  }
}

/// Badge card; earned ones carry a green dot in the corner, the rest are
/// faded and gray.
class _AchievementCard extends StatelessWidget {
  const _AchievementCard(this.achievement);

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final isEarned = achievement.earnedAt != null;
    Widget card = Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration,
      child: Column(
        children: [
          _icon(achievement.iconUrl),
          const SizedBox(height: 6),
          Text(
            achievement.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10.88,
              height: 1.25,
              fontWeight: FontWeight.w700,
              color: AppColors.grey800,
            ),
          ),
        ],
      ),
    );
    if (!isEarned) {
      card = Opacity(
        opacity: 0.4,
        child: ColorFiltered(
          colorFilter: const ColorFilter.matrix(_grayscale),
          child: card,
        ),
      );
    }
    return Tooltip(
      message: '${achievement.title}\n${achievement.description}',
      child: Stack(
        clipBehavior: Clip.none,
        // Lets the card stretch to the row's height.
        fit: StackFit.passthrough,
        children: [
          card,
          if (isEarned)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _icon(String? iconUrl) {
    const medal = PbIcon(PbIcons.medal, size: 29);
    if (iconUrl != null && iconUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: iconUrl,
        width: 29,
        height: 29,
        errorWidget: (_, __, ___) => medal,
      );
    }
    // Treat as emoji or short text.
    if (iconUrl == null || iconUrl.isEmpty) return medal;
    return Text(iconUrl, style: const TextStyle(fontSize: 24, height: 1.2));
  }
}

/// CSS `grayscale`.
const _grayscale = <double>[
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0, 0, 0, 1, 0, //
];

/// `bg-white border-2 border-gray-200 rounded-2xl`.
final _cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: AppColors.grey200, width: 2),
);

/// CSS grid with a 12px gap: rows stretch to their tallest card.
class _Grid extends StatelessWidget {
  const _Grid({required this.columns, required this.children});

  final int columns;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var start = 0; start < children.length; start += columns) {
      if (start > 0) rows.add(const SizedBox(height: 12));
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < columns; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(
                  child: start + i < children.length
                      ? children[start + i]
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

/// Heading with an icon over its content (`flex-col gap-3.5`).
class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.title,
    required this.child,
  });

  final PbIcons icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileSectionTitle(icon: icon, text: title),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}

/// Gray centered note (`text-sm font-semibold text-gray-400 py-4`).
class _Placeholder extends StatelessWidget {
  const _Placeholder(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w600,
          color: AppColors.grey400,
        ),
      ),
    );
  }
}
