import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_icon.dart';
import 'package:pracby_mobile/features/leaderboard/presentation/widgets/leaderboard_list.dart';

/// One league tab of the web leaderboard, with its banner colours
/// (`bg-*` and the darker `border-b-4`).
class _League {
  const _League(this.id, this.name, this.icon, this.color, this.edge);

  final String id;
  final String name;
  final PbIcons icon;
  final Color color;
  final Color edge;
}

const _leagues = [
  // bg-amber-800 / border-amber-900
  _League(
    'bronze',
    'Bronz',
    PbIcons.medalBronze,
    Color(0xFF92400E),
    Color(0xFF78350F),
  ),
  _League(
    'silver',
    'Gümüş',
    PbIcons.medalSilver,
    AppColors.grey500,
    AppColors.grey600,
  ),
  // bg-amber-600 / border-amber-700
  _League(
    'gold',
    'Altın',
    PbIcons.medalGold,
    Color(0xFFD97706),
    Color(0xFFB45309),
  ),
  // bg-blue-500 / border-blue-700
  _League(
    'diamond',
    'Elmas',
    PbIcons.diamond,
    Color(0xFF3B82F6),
    Color(0xFF1D4ED8),
  ),
];

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _active = 0;

  @override
  Widget build(BuildContext context) {
    final league = _leagues[_active];
    return Scaffold(
      backgroundColor: Colors.white,
      // No streak / acorn / energy bar on this page (unlike the web).
      body: SafeArea(
        bottom: false,
        child: ListView(
          // Web: main px-3 pt-20 (below the header) and the page's pb-10.
          padding: const EdgeInsets.fromLTRB(12, 24, 12, 40),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _Header(),
                    const SizedBox(height: 20),
                    _LeagueTabs(
                      active: _active,
                      onSelect: (i) => setState(() => _active = i),
                    ),
                    const SizedBox(height: 20),
                    _LeagueBanner(league: league),
                    const SizedBox(height: 20),
                    LeaderboardList(league: league.id),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PbIcon(PbIcons.trophy, size: 28.8),
              SizedBox(width: 8),
              Text(
                'Liderlik Tablosu',
                style: TextStyle(
                  fontSize: 24,
                  height: 32 / 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.grey800,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'Bu haftanın en iyileri arasına gir!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.w600,
              color: AppColors.grey400,
            ),
          ),
        ],
      ),
    );
  }
}

/// Segmented league picker: white bordered box, the active one purple.
class _LeagueTabs extends StatelessWidget {
  const _LeagueTabs({required this.active, required this.onSelect});

  final int active;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200, width: 2),
      ),
      child: Row(
        children: [
          for (var i = 0; i < _leagues.length; i++) ...[
            if (i > 0) const SizedBox(width: 2),
            Expanded(child: _tab(i)),
          ],
        ],
      ),
    );
  }

  Widget _tab(int i) {
    final selected = i == active;
    return Material(
      color: selected ? AppColors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onSelect(i),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          child: Column(
            children: [
              PbIcon(_leagues[i].icon, size: 21.6),
              const SizedBox(height: 2),
              Text(
                _leagues[i].name.toUpperCase(),
                maxLines: 1,
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.29,
                  color: selected ? Colors.white : AppColors.grey400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Coloured "<Lig> Ligi" card with the 3D bottom edge.
class _LeagueBanner extends StatelessWidget {
  const _LeagueBanner({required this.league});

  final _League league;

  @override
  Widget build(BuildContext context) {
    return Container(
      // The darker colour peeks out 4px below: the web's border-b-4.
      padding: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: league.edge,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: league.color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            PbIcon(league.icon, size: 36),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${league.name} Ligi',
                    style: const TextStyle(
                      fontSize: 18,
                      height: 28 / 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Same rule text for every league on the web.
                  Text(
                    "Top 10 → Gümüş'e yüksel • Alt 5 → Bronza düş",
                    style: TextStyle(
                      fontSize: 12,
                      height: 16 / 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
