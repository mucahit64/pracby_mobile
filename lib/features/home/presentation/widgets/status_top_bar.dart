import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/countdown.dart';
import 'package:pracby_mobile/core/widgets/pb_icon.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';
import 'package:pracby_mobile/features/home/presentation/widgets/status_sheets.dart';
import 'package:pracby_mobile/features/profile/presentation/providers/profile_provider.dart';

/// Streak, acorns and energy at the top of the tab screens, like the web's
/// mobile header (shown on every page there). The lesson map puts its course
/// picker in [leading].
class StatusTopBar extends ConsumerWidget implements PreferredSizeWidget {
  const StatusTopBar({this.leading, super.key});

  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final selector = leading;
    final stats = ref.watch(userStatsProvider).valueOrNull;
    final guest = ref.watch(guestProvider);
    final energy = ref.watch(energyStatusProvider);
    // Guests show their local balances (docs 10.4, 10.5).
    final acorns = user?.acorns ?? guest.acornBalance;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 12,
      title: Row(
        // The course and the counts spread evenly. The course button is
        // capped so a long name is cut off instead of squeezing the counts.
        mainAxisAlignment: selector == null
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        children: [
          if (selector != null)
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: selector,
              ),
            ),
          _TopBarItem(
            icon: const PbIcon(PbIcons.fire, size: 22),
            label: '${stats?.displayStreak ?? 0}',
            tooltip: 'Seri',
            onTap: () => showStreakSheet(context),
          ),
          _TopBarItem(
            icon: const PbIcon(PbIcons.acorn, size: 22),
            label: '$acorns',
            tooltip: 'Palamut',
            onTap: () => context.go(Routes.store),
          ),
          _TopBarItem(
            icon: PbIcon(
              energy.unlimited ? PbIcons.energyInfinite : PbIcons.energy,
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
    );
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
                  fontWeight: FontWeight.w800,
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
