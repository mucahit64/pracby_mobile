import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_icon.dart';
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
  static const _leagueIcons = [
    PbIcons.medalBronze,
    PbIcons.medalSilver,
    PbIcons.medalGold,
    PbIcons.diamond,
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
                  PbIcon(_leagueIcons[i], size: 20),
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
    // The API has no "me" flag; match by username like the web.
    final myUsername = ref.watch(
      authStateProvider.select((s) => s.valueOrNull?.username),
    );

    return entriesAsync.when(
      loading: () => const PbLoading(),
      error: (error, _) => Center(child: Text('Hata: $error')),
      data: (entries) {
        if (entries.isEmpty) {
          return const Center(child: Text('Bu ligde henüz kimse yok.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          itemBuilder: (context, index) => _RankEntryTile(
            entry: entries[index],
            position: index + 1,
            totalCount: entries.length,
            isMe: entries[index].username == myUsername,
          ),
        );
      },
    );
  }
}

class _RankEntryTile extends StatelessWidget {
  const _RankEntryTile({
    required this.entry,
    required this.position,
    required this.totalCount,
    required this.isMe,
  });

  final LeaderboardEntry entry;

  /// 1-based place in the list (web uses the index, not `rank`).
  final int position;
  final int totalCount;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final isPromotion = position <= 3;
    final isDemotion = position > totalCount - 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isMe
            ? AppColors.primary.withValues(alpha: 0.1)
            : isPromotion
                ? AppColors.success.withValues(alpha: 0.05)
                : isDemotion
                    ? AppColors.error.withValues(alpha: 0.05)
                    : null,
        border: isMe
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: switch (position) {
              1 => const PbIcon(PbIcons.medalGold),
              2 => const PbIcon(PbIcons.medalSilver),
              3 => const PbIcon(PbIcons.medalBronze),
              _ => Text(
                  '$position',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.grey600,
                  ),
                ),
            },
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
                    isMe ? FontWeight.w700 : FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            '${entry.xpEarned} XP',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }


}
