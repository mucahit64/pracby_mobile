import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_loading.dart';
import 'package:pracby_mobile/features/leaderboard/data/models/leaderboard_entry.dart';
import 'package:pracby_mobile/features/leaderboard/presentation/providers/leaderboard_provider.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _leagues = ['bronze', 'silver', 'gold', 'diamond'];
  static const _leagueNames = ['Bronz', 'Gümüş', 'Altın', 'Elmas'];
  static const _leagueColors = [
    Color(0xFFCD7F32),
    Color(0xFFC0C0C0),
    Color(0xFFFFD700),
    Color(0xFFB9F2FF),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _leagues.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sıralama'),
        bottom: TabBar(
          controller: _tabController,
          tabs: List.generate(
            _leagues.length,
            (i) => Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emoji_events, color: _leagueColors[i], size: 18),
                  const SizedBox(width: 4),
                  Text(_leagueNames[i]),
                ],
              ),
            ),
          ),
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey500,
          indicatorColor: AppColors.primary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _leagues.map((league) => _LeagueTab(league: league)).toList(),
      ),
    );
  }
}

class _LeagueTab extends ConsumerWidget {
  const _LeagueTab({required this.league});

  final String league;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(leaderboardProvider(league));

    return entriesAsync.when(
      loading: () => const PbLoading(),
      error: (error, _) => Center(child: Text('Hata: $error')),
      data: (entries) {
        if (entries.isEmpty) {
          return const Center(child: Text('Henüz veri yok'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          itemBuilder: (context, index) =>
              _RankEntryTile(entry: entries[index], totalCount: entries.length),
        );
      },
    );
  }
}

class _RankEntryTile extends StatelessWidget {
  const _RankEntryTile({required this.entry, required this.totalCount});

  final LeaderboardEntry entry;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final isPromotion = entry.rank <= 3;
    final isDemotion = entry.rank > totalCount - 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: entry.isCurrentUser
            ? AppColors.primary.withValues(alpha: 0.1)
            : isPromotion
                ? AppColors.success.withValues(alpha: 0.05)
                : isDemotion
                    ? AppColors.error.withValues(alpha: 0.05)
                    : null,
        border: entry.isCurrentUser
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '${entry.rank}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: _getRankColor(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.grey200,
            child: Text(
              entry.username.isNotEmpty ? entry.username[0].toUpperCase() : '?',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.grey700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              entry.username,
              style: TextStyle(
                fontWeight:
                    entry.isCurrentUser ? FontWeight.w700 : FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            '${entry.xp} XP',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor() {
    switch (entry.rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return AppColors.grey600;
    }
  }
}
