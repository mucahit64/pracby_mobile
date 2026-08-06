import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_loading.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/store/data/models/store_item.dart';
import 'package:pracby_mobile/features/store/data/store_repository.dart';
import 'package:pracby_mobile/features/store/presentation/providers/store_provider.dart';

class StoreScreen extends ConsumerWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(storeItemsProvider);
    final effectsAsync = ref.watch(activeEffectsProvider);
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mağaza'),
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.eco, color: AppColors.accent, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${user.acorns}',
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
              if (effects.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aktif Efektler',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: effects.map((effect) {
                            final remaining = effect.expiresAt
                                .difference(DateTime.now());
                            return Chip(
                              avatar: const Icon(Icons.auto_awesome,
                                  size: 16, color: AppColors.accent),
                              label: Text(
                                '${effect.itemType}: ${remaining.inHours}sa ${remaining.inMinutes.remainder(60)}dk',
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _StoreItemCard(
                      item: items[index],
                      userAcorns: user?.acorns ?? 0,
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
    if (user == null) return;

    if (user.acorns < item.price) {
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
      try {
        await ref.read(storeRepositoryProvider).purchase(itemId: item.id);
        ref
          ..invalidate(storeItemsProvider)
          ..invalidate(activeEffectsProvider);
        await ref.read(authStateProvider.notifier).refreshUser();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Satın alma başarılı!'),
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
}

class _StoreItemCard extends StatelessWidget {
  const _StoreItemCard({
    required this.item,
    required this.userAcorns,
    required this.onPurchase,
  });

  final StoreItem item;
  final int userAcorns;
  final VoidCallback onPurchase;

  @override
  Widget build(BuildContext context) {
    final canAfford = userAcorns >= item.price;

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
            child: Icon(
              _getItemIcon(item.category),
              color: _getItemColor(item.category),
              size: 28,
            ),
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
                  const Icon(Icons.eco, color: AppColors.white, size: 14),
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

  IconData _getItemIcon(String category) {
    return switch (category) {
      'streak_freeze' => Icons.ac_unit,
      'unlimited_energy' => Icons.flash_on,
      'xp_boost' => Icons.rocket_launch,
      'energy_refill' => Icons.battery_charging_full,
      _ => Icons.auto_awesome,
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
