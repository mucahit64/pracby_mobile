import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/countdown.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';
import 'package:pracby_mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:pracby_mobile/features/profile/presentation/widgets/week_streak_row.dart';
import 'package:pracby_mobile/features/store/presentation/providers/store_provider.dart';

/// Energy shown in the header, for a member or a guest (docs 10.4).
class EnergyStatus {
  const EnergyStatus({
    required this.count,
    required this.nextEnergyAt,
    required this.unlimited,
  });

  final int count;
  final DateTime? nextEnergyAt;
  final bool unlimited;

  bool get isFull => count >= maxEnergy;
}

final energyStatusProvider = Provider<EnergyStatus>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user != null) {
    return EnergyStatus(
      count: user.energy,
      nextEnergyAt: user.nextEnergyAt,
      unlimited: ref.watch(unlimitedEnergyProvider),
    );
  }
  final guest = ref.watch(guestProvider);
  return EnergyStatus(
    count: guest.energyCount,
    nextEnergyAt: guest.nextEnergyAt,
    unlimited: false,
  );
});

/// Called when the countdown reaches zero: picks up the regenerated energy.
void refreshEnergy(WidgetRef ref) {
  if (ref.read(authStateProvider).valueOrNull != null) {
    ref.read(authStateProvider.notifier).refreshUser();
  } else {
    ref.read(guestProvider.notifier).refreshEnergy();
  }
}

Future<void> showEnergySheet(BuildContext context) =>
    _show(context, const _EnergySheet());

Future<void> showStreakSheet(BuildContext context) =>
    _show(context, const _StreakSheet());

Future<void> _show(BuildContext context, Widget sheet) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: sheet,
      ),
    ),
  );
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.2,
      color: AppColors.grey400,
    ),
  );
}

/// Web LayoutMobileHeader energy tooltip.
class _EnergySheet extends ConsumerWidget {
  const _EnergySheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final energy = ref.watch(energyStatusProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SheetTitle('Enerjin'),
        const SizedBox(height: 12),
        if (energy.unlimited) ...[
          const Row(
            children: [
              Icon(Icons.all_inclusive, color: AppColors.success, size: 32),
              SizedBox(width: 8),
              Text(
                'Sınırsız enerji aktif!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Icon(
                Icons.battery_charging_full,
                color: Color(0xFF22C55E),
                size: 28,
              ),
              const SizedBox(width: 6),
              Text(
                '${energy.count}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.grey800,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '/ $maxEnergy',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: energy.count / maxEnergy,
              minHeight: 8,
              backgroundColor: AppColors.grey100,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          if (energy.isFull)
            const Text(
              'Enerjin dolu! 🎉',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.success,
              ),
            )
          else
            Countdown(
              target: energy.nextEnergyAt,
              onDone: () => refreshEnergy(ref),
              builder: (context, remaining) => remaining == null
                  ? const SizedBox.shrink()
                  : Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.errorSurface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Sonraki enerji',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.grey500,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: AppColors.error,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            Countdown.format(remaining),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.error,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(Routes.store);
            },
            child: const Text('Enerji Satın Al'),
          ),
        ],
      ],
    );
  }
}

/// Web LayoutMobileHeader streak tooltip.
class _StreakSheet extends ConsumerWidget {
  const _StreakSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(userStatsProvider).valueOrNull?.displayStreak ?? 0;
    final days = ref.watch(streakHistoryProvider).valueOrNull ?? const [];
    final isGuest = ref.watch(authStateProvider).valueOrNull == null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SheetTitle('Bu Haftaki Serin'),
        const SizedBox(height: 16),
        if (days.isNotEmpty) ...[
          WeekStreakRow(days: days),
          const SizedBox(height: 16),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const Icon(
              Icons.local_fire_department,
              color: Color(0xFFEF4444),
              size: 26,
            ),
            const SizedBox(width: 6),
            Text(
              '$streak',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.grey800,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'günlük seri',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.grey400,
              ),
            ),
          ],
        ),
        if (isGuest) ...[
          const SizedBox(height: 8),
          const Text(
            'Serin hesabına kaydedilir. Profil oluşturarak serini başlat.',
            style: TextStyle(fontSize: 13, color: AppColors.grey500),
          ),
        ],
      ],
    );
  }
}
