import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/api/api_exception.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_icon.dart';
import 'package:pracby_mobile/core/widgets/pb_loading.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';
import 'package:pracby_mobile/features/offline/offline_queue.dart';
import 'package:pracby_mobile/features/store/data/models/store_item.dart';
import 'package:pracby_mobile/features/store/data/store_repository.dart';
import 'package:pracby_mobile/features/store/presentation/providers/store_provider.dart';
import 'package:pracby_mobile/features/store/presentation/widgets/inventory_section.dart';

class StoreScreen extends ConsumerWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(storeItemsProvider);
    final effectsAsync = ref.watch(activeEffectsProvider);
    final user = ref.watch(authStateProvider).valueOrNull;
    final guest = ref.watch(guestProvider);
    final isGuest = user == null;
    final acorns = user?.acorns ?? guest.acornBalance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mağaza'),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const PbIcon(PbIcons.acorn, size: 22),
                  const SizedBox(width: 4),
                  Text(
                    '$acorns',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: itemsAsync.when(
        loading: () => const PbLoading(),
        error: (error, _) => Center(child: Text('Hata: $error')),
        data: (items) {
          final effects = effectsAsync.valueOrNull ?? [];

          return CustomScrollView(
            slivers: [
              if (isGuest) SliverToBoxAdapter(child: _GuestBanner(acorns)),
              if (effects.isNotEmpty)
                SliverToBoxAdapter(
                  child: ActiveEffectsSection(effects: effects),
                ),
              if (!isGuest)
                const SliverToBoxAdapter(child: InventorySection()),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _StoreItemCard(
                      item: items[index],
                      userAcorns: acorns,
                      // Guests can only buy energy, with local acorns.
                      enabled: !isGuest ||
                          items[index].category == 'energy_refill',
                      onPurchase: () => _handlePurchase(context, ref, items[index]),
                    ),
                    childCount: items.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                ),
              ),
            ],
          );
        },
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

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      builder: (ctx) => _PurchaseConfirmSheet(item: item),
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
          final ok = item.category == 'energy_refill' &&
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

/// Web store.vue guest banner.
class _GuestBanner extends StatelessWidget {
  const _GuestBanner(this.acorns);

  final int acorns;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          const PbIcon(PbIcons.acorn, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey800,
                ),
                children: [
                  TextSpan(
                    text: '$acorns palamut kazandın! ',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const TextSpan(
                    text: 'Mağazada harcamak için bir profil oluştur!',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => context.push(Routes.register),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            child: const Text('Profil Oluştur'),
          ),
        ],
      ),
    );
  }
}

class _StoreItemCard extends StatelessWidget {
  const _StoreItemCard({
    required this.item,
    required this.userAcorns,
    required this.onPurchase,
    this.enabled = true,
  });

  final StoreItem item;
  final int userAcorns;
  final VoidCallback onPurchase;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final canAfford = userAcorns >= item.price;

    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: IgnorePointer(
        ignoring: !enabled,
        child: _card(canAfford),
      ),
    );
  }

  Widget _card(bool canAfford) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _getItemColor(item.category).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: PbIcon(_getItemIcon(item.category), size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            item.name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            item.description,
            style: const TextStyle(fontSize: 11, color: AppColors.grey500),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onPurchase,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: canAfford ? AppColors.primary : AppColors.grey300,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const PbIcon(PbIcons.acorn, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${item.price}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PbIcons _getItemIcon(String category) {
    return switch (category) {
      'streak_freeze' => PbIcons.freeze,
      'unlimited_energy' => PbIcons.energyInfinite,
      'xp_boost' => PbIcons.xp,
      'energy_refill' => PbIcons.energy,
      _ => PbIcons.gift,
    };
  }

  Color _getItemColor(String category) {
    return switch (category) {
      'streak_freeze' => const Color(0xFF3B82F6),
      'unlimited_energy' => const Color(0xFF22C55E),
      'xp_boost' => AppColors.accent,
      'energy_refill' => const Color(0xFF22C55E),
      _ => AppColors.primary,
    };
  }
}

class _PurchaseConfirmSheet extends StatelessWidget {
  const _PurchaseConfirmSheet({required this.item});

  final StoreItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Satın Al',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          Text('${item.name} için ${item.price} palamut harcamak istiyor musun?'),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('İptal'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Satın Al'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
