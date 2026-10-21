import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_icon.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/leaderboard/data/models/leaderboard_entry.dart';
import 'package:pracby_mobile/features/leaderboard/presentation/providers/leaderboard_provider.dart';

/// Avatar backgrounds by list position, same order as the web.
const _avatarColors = [
  Color(0xFF7C3AED),
  Color(0xFF059669),
  Color(0xFFDC2626),
  Color(0xFF2563EB),
  Color(0xFFD97706),
  Color(0xFFDB2777),
  Color(0xFF0891B2),
  Color(0xFF65A30D),
  Color(0xFFEA580C),
  Color(0xFF7C3AED),
];

/// The players card of the web leaderboard: promotion zone, rows and
/// demotion zone inside one bordered white box.
class LeaderboardList extends ConsumerWidget {
  const LeaderboardList({required this.league, super.key});

  final String league;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(leaderboardProvider(league));
    // The API has no "me" flag; match by username like the web.
    final myUsername = ref.watch(
      authStateProvider.select((s) => s.valueOrNull?.username),
    );

    final content = entriesAsync.when<Widget>(
      loading: () => const _Message('Yükleniyor…'),
      error: (error, _) => _Message('Hata: $error'),
      data: (entries) {
        if (entries.isEmpty) {
          return const _Message('Bu ligde henüz kimse yok.');
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _ZoneLabel.promotion(),
            for (var i = 0; i < entries.length; i++)
              _PlayerRow(
                entry: entries[i],
                index: i,
                isLast: i == entries.length - 1,
                // The bottom three rows are faded.
                isFaded: i >= entries.length - 3,
                isMe: entries[i].username == myUsername,
              ),
            const _ZoneLabel.demotion(),
          ],
        );
      },
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200, width: 2),
      ),
      child: content,
    );
  }
}

/// Loading / empty / error text inside the card.
class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          height: 1.5,
          fontWeight: FontWeight.w700,
          color: AppColors.grey400,
        ),
      ),
    );
  }
}

/// "Yükselme / Düşme Bölgesi" strip with a dashed edge towards the rows.
class _ZoneLabel extends StatelessWidget {
  const _ZoneLabel.promotion()
    : text = '↑ YÜKSELME BÖLGESİ',
      color = AppColors.success,
      background = 0.1,
      line = 0.3,
      lineAtBottom = true;

  const _ZoneLabel.demotion()
    : text = '↓ DÜŞME BÖLGESİ',
      color = AppColors.error,
      background = 0.05,
      line = 0.25,
      lineAtBottom = false;

  final String text;
  final Color color;
  final double background;
  final double line;
  final bool lineAtBottom;

  @override
  Widget build(BuildContext context) {
    final dashed = SizedBox(
      height: 2,
      child: CustomPaint(
        painter: _DashedLinePainter(color.withValues(alpha: line)),
      ),
    );
    return ColoredBox(
      color: color.withValues(alpha: background),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!lineAtBottom) dashed,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.2,
                height: 1.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.12,
                color: color,
              ),
            ),
          ),
          if (lineAtBottom) dashed,
        ],
      ),
    );
  }
}

/// A 2px dashed line, like CSS `border-dashed`.
class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const dash = 6.0;
    const gap = 6.0;
    final paint = Paint()..color = color;
    for (var x = 0.0; x < size.width; x += dash + gap) {
      canvas.drawRect(Rect.fromLTWH(x, 0, dash, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _PlayerRow extends StatelessWidget {
  const _PlayerRow({
    required this.entry,
    required this.index,
    required this.isLast,
    required this.isFaded,
    required this.isMe,
  });

  final LeaderboardEntry entry;

  /// 0-based place in the list (web uses the index, not `rank`).
  final int index;
  final bool isLast;
  final bool isFaded;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final initial = entry.username.isNotEmpty
        ? entry.username[0].toUpperCase()
        : '?';

    final row = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primary.withValues(alpha: 0.05) : null,
        border: Border(
          left: isMe
              ? const BorderSide(color: AppColors.primary, width: 3)
              : BorderSide.none,
          bottom: isLast
              ? BorderSide.none
              : const BorderSide(color: AppColors.grey100),
        ),
      ),
      child: Row(
        children: [
          // Rank: medals for the top three, the number below.
          SizedBox(
            width: 32,
            child: Center(
              child: switch (index) {
                0 => const PbIcon(PbIcons.medalGold),
                1 => const PbIcon(PbIcons.medalSilver),
                2 => const PbIcon(PbIcons.medalBronze),
                _ => Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 20 / 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.grey400,
                  ),
                ),
              },
            ),
          ),
          const SizedBox(width: 14),
          _Avatar(
            initial: initial,
            color: _avatarColors[index % _avatarColors.length],
            isMe: isMe,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    entry.username,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 20 / 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.grey800,
                    ),
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 6),
                  const _Pill(
                    'sen',
                    fontSize: 10.4,
                    weight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NumberFormat.decimalPattern('tr').format(entry.xpEarned),
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w900,
                  color: AppColors.grey800,
                ),
              ),
              const Text(
                'XP',
                style: TextStyle(
                  fontSize: 10.4,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.04,
                  color: AppColors.grey400,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return isFaded ? Opacity(opacity: 0.75, child: row) : row;
  }
}

/// Coloured initial circle; the user's own one gets a "SEN" badge.
class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.initial,
    required this.color,
    required this.isMe,
  });

  final String initial;
  final Color color;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Text(
            initial,
            style: const TextStyle(
              fontSize: 18,
              height: 28 / 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
        if (isMe)
          const Positioned(
            right: -4,
            bottom: -4,
            child: _Pill(
              'SEN',
              fontSize: 8.8,
              weight: FontWeight.w900,
              letterSpacing: 0.22,
            ),
          ),
      ],
    );
  }
}

/// Small purple rounded label ("sen" / "SEN").
class _Pill extends StatelessWidget {
  const _Pill(
    this.text, {
    required this.fontSize,
    required this.weight,
    required this.letterSpacing,
  });

  final String text;
  final double fontSize;
  final FontWeight weight;
  final double letterSpacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          height: 1.5,
          fontWeight: weight,
          letterSpacing: letterSpacing,
          color: Colors.white,
        ),
      ),
    );
  }
}
