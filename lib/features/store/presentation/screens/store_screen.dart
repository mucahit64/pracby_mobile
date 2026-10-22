import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/api/api_exception.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_icon.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';
import 'package:pracby_mobile/features/home/presentation/widgets/status_sheets.dart';
import 'package:pracby_mobile/features/home/presentation/widgets/status_top_bar.dart';
import 'package:pracby_mobile/features/offline/offline_queue.dart';
import 'package:pracby_mobile/features/store/data/models/store_item.dart';
import 'package:pracby_mobile/features/store/data/store_repository.dart';
import 'package:pracby_mobile/features/store/presentation/providers/store_provider.dart';
import 'package:pracby_mobile/features/store/presentation/widgets/inventory_section.dart';
import 'package:pracby_mobile/features/store/presentation/widgets/store_widgets.dart';

/// Buying acorns with money isn't built yet, so the section stays hidden: a
/// button that does nothing gets the app rejected. It must use the stores'
/// in-app purchases when it comes.
const _acornPurchaseEnabled = false;

class StoreScreen extends ConsumerWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(storeItemsProvider);
    final effects = ref.watch(activeEffectsProvider).valueOrNull ?? [];
    final unlimitedEnergy = ref.watch(unlimitedEnergyProvider);
    final user = ref.watch(authStateProvider).valueOrNull;
    final guest = ref.watch(guestProvider);
    final isGuest = user == null;
    final acorns = user?.acorns ?? guest.acornBalance;
    final energyFull = ref.watch(energyStatusProvider).isFull;

    final items = itemsAsync.valueOrNull ?? const <StoreItem>[];
    final regularItems = items
        .where((i) => i.category != 'energy_refill')
        .toList();
    final energyItems = items
        .where((i) => i.category == 'energy_refill')
        .toList();

    Widget itemCard(StoreItem item, {bool dimmed = false}) => _StoreItemCard(
      item: item,
      dimmed: dimmed,
      // Guests can only buy energy, with local acorns.
      onPurchase: (!dimmed && acorns >= item.price)
          ? () => _handlePurchase(context, ref, item)
          : null,
    );

    // Web store.vue: sections 28px apart (gap-7) in a 600px column.
    final sections = <Widget>[
      const _Heading(),
      StoreSection(
        title: 'Ürünler',
        children: [
          if (isGuest) ...[_GuestBanner(acorns), const SizedBox(height: 12)],
          itemsAsync.when(
            loading: () => const StoreHint('Yükleniyor…'),
            error: (error, _) => StoreHint('Hata: $error'),
            data: (_) => StoreList(
              children: [
                for (final item in regularItems)
                  itemCard(item, dimmed: isGuest),
              ],
            ),
          ),
        ],
      ),
      if (energyItems.isNotEmpty)
        StoreSection(
          icon: PbIcons.energy,
          title: 'Enerji Doldur',
          children: [
            if (unlimitedEnergy)
              const _UnlimitedEnergyBanner()
            else
              StoreList(
                children: [
                  for (final item in energyItems)
                    // A refill can't add anything to full energy.
                    energyFull
                        ? _StoreItemCard(
                            item: item,
                            onPurchase: null,
                            energyFull: true,
                          )
                        : itemCard(item),
                ],
              ),
          ],
        ),
      if (effects.isNotEmpty) ActiveEffectsSection(effects: effects),
      if (!isGuest) const InventorySection(),
      if (!isGuest && _acornPurchaseEnabled) const _AcornPackagesSection(),
    ];

    return Scaffold(
      appBar: const StatusTopBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 40),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: StoreList(gap: 28, children: sections),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePurchase(
    BuildContext context,
    WidgetRef ref,
    StoreItem item,
  ) async {
    final user = ref.read(authStateProvider).valueOrNull;
    final acorns = user?.acorns ?? ref.read(guestProvider).acornBalance;
    if (user == null && item.category != 'energy_refill') return;

    if (acorns < item.price) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yeterli palamut yok! Quiz yaparak kazan.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (ctx) => _PurchaseDialog(item: item),
    );

    if (confirmed ?? false) {
      if (user == null) {
        _buyEnergyAsGuest(ref, item);
        return;
      }
      try {
        if (!await _purchaseOnline(ref, user.id, item)) {
          // Energy works offline (docs 7.5.1): paid locally and queued.
          // Balance was checked above, so this only fails on a race.
          final ok =
              item.category == 'energy_refill' &&
              await ref.read(authStateProvider.notifier).buyEnergyOffline(item);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  ok
                      ? 'Satın alındı! İnternet gelince hesabına işlenecek.'
                      : 'Bu ürün için internet bağlantısı gerekli.',
                ),
                backgroundColor: ok ? AppColors.success : AppColors.error,
              ),
            );
          }
          return;
        }
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              // Timed items go to the inventory and must be activated there.
              content: Text(
                item.durationHours != null
                    ? 'Satın alındı! Envanterinden kullanabilirsin.'
                    : 'Satın alma başarılı!',
              ),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hata: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  /// Buys [item] on the server. Returns false without buying when offline or
  /// when energy can't go first because earlier actions are still queued
  /// (keeps the server's order of events). Other errors are rethrown.
  Future<bool> _purchaseOnline(
    WidgetRef ref,
    String userId,
    StoreItem item,
  ) async {
    final isEnergy = item.category == 'energy_refill';
    if (isEnergy && !await ref.read(offlineQueueProvider).flush(userId)) {
      return false;
    }
    try {
      await ref.read(storeRepositoryProvider).purchase(itemId: item.id);
    } on ApiException catch (e) {
      if (e.isNetworkError) return false;
      rethrow;
    }
    ref
      ..invalidate(storeItemsProvider)
      ..invalidate(activeEffectsProvider)
      ..invalidate(storeInventoryProvider);
    await ref.read(authStateProvider.notifier).refreshUser();
    return true;
  }

  /// Docs 10.4: spend local acorns, then add `metadata.energy_count`.
  void _buyEnergyAsGuest(WidgetRef ref, StoreItem item) {
    final guest = ref.read(guestProvider.notifier);
    if (!guest.spendAcorns(item.price)) return;
    final count = (item.metadata?['energy_count'] as num?)?.toInt() ?? 1;
    guest.setEnergy(ref.read(guestProvider).energyCount + count);
  }
}

/// "Market" page heading (web `text-2xl font-black`).
class _Heading extends StatelessWidget {
  const _Heading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          PbIcon(PbIcons.acorn, size: 29),
          SizedBox(width: 6),
          Text(
            'Market',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.grey800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Web store.vue guest banner.
class _GuestBanner extends StatelessWidget {
  const _GuestBanner(this.acorns);

  final int acorns;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: storeAmber50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: storeAmber200, width: 2),
      ),
      child: Row(
        children: [
          const PbIcon(PbIcons.acorn, size: 29),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey800,
                  height: 1.375,
                ),
                children: [
                  TextSpan(
                    text: '$acorns palamut kazandın!',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(
                    text: ' Mağazada harcamak için bir profil oluştur!',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          StorePrimaryButton(
            onPressed: () => context.push(Routes.register),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            edge: 3,
            child: const Text(
              'Profil Oluştur',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

/// A store item row: emoji, name, description, duration and price button.
class _StoreItemCard extends StatelessWidget {
  const _StoreItemCard({
    required this.item,
    required this.onPurchase,
    this.dimmed = false,
    this.energyFull = false,
  });

  final StoreItem item;

  /// An energy refill while energy is full: a grey "Enerji dolu" button.
  final bool energyFull;

  /// Null when the item can't be bought (too few acorns, or a guest).
  final VoidCallback? onPurchase;

  /// Members-only items fade out for guests.
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final hours = item.durationHours;
    return Opacity(
      opacity: dimmed ? 0.5 : 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey200, width: 2),
        ),
        child: Row(
          children: [
            StoreItemIcon(
              iconUrl: item.iconUrl,
              itemType: item.category,
              size: 30,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.grey800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey400,
                    ),
                  ),
                  if (hours != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 12,
                          color: AppColors.grey400,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${hours}s süre',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 14),
            if (energyFull)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey200, width: 2),
                ),
                child: const Text(
                  'Enerji dolu',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.grey400,
                  ),
                ),
              )
            else
              AcornButton(
                onPressed: onPurchase,
                child: AcornAmount(item.price, fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }
}

/// Shown instead of the energy items while unlimited energy runs.
class _UnlimitedEnergyBanner extends StatelessWidget {
  const _UnlimitedEnergyBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: const Row(
        children: [
          PbIcon(PbIcons.energyInfinite), // 24px, text-xl at 1.2em
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Sınırsız enerji aktif — enerji doldurmanıza gerek yok!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Buy Acorn": acorn packages in two columns. Payment isn't built yet;
/// the web shows the same notice.
class _AcornPackagesSection extends ConsumerWidget {
  const _AcornPackagesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packages = ref.watch(acornPackagesProvider).valueOrNull ?? [];
    return StoreSection(
      icon: PbIcons.acorn,
      title: 'Buy Acorn',
      children: [
        StoreList(
          gap: 12,
          children: [
            for (var i = 0; i < packages.length; i += 2)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _packageCard(context, packages[i])),
                    const SizedBox(width: 12),
                    Expanded(
                      child: i + 1 < packages.length
                          ? _packageCard(context, packages[i + 1])
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _packageCard(BuildContext context, AcornPackage pkg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200, width: 2),
      ),
      child: Column(
        children: [
          AcornAmount(pkg.amount, fontSize: 20, fontWeight: FontWeight.w900),
          const SizedBox(height: 8),
          Text(
            pkg.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.grey400,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: AcornButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment system coming soon!')),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Text(
                'Satın Al',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Purchase confirmation, like the web's purchase modal.
class _PurchaseDialog extends StatelessWidget {
  const _PurchaseDialog({required this.item});

  final StoreItem item;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.grey200, width: 2),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StoreItemIcon(
                iconUrl: item.iconUrl,
                itemType: item.category,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.grey800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey400,
                ),
              ),
              const SizedBox(height: 12),
              AcornAmount(
                item.price,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: StorePrimaryButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'Satın Al',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.grey400,
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: const BorderSide(color: AppColors.grey200, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('İptal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
