import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_exception.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_icon.dart';
import 'package:pracby_mobile/features/store/data/models/inventory_item.dart';
import 'package:pracby_mobile/features/store/data/models/store_item.dart';
import 'package:pracby_mobile/features/store/data/store_repository.dart';
import 'package:pracby_mobile/features/store/presentation/providers/store_provider.dart';

/// Effect names, same as the web store (`effectLabel`).
String effectLabel(String itemType) => switch (itemType) {
  'streak_freeze' => 'Seri Dondurma',
  'unlimited_energy' => 'Sınırsız Enerji',
  'xp_boost' => 'XP Boost',
  _ => itemType,
};

PbIcons? _effectIcon(String itemType) => switch (itemType) {
  'streak_freeze' => PbIcons.freeze,
  'unlimited_energy' => PbIcons.energyInfinite,
  'xp_boost' => PbIcons.xp,
  _ => null,
};

/// Time left until [expiresAt], e.g. "7s 42dk" or "15dk".
String formatRemaining(DateTime expiresAt) {
  final left = expiresAt.difference(DateTime.now());
  if (left.isNegative) return 'Bitti';
  final hours = left.inHours;
  final minutes = left.inMinutes.remainder(60);
  return hours > 0 ? '${hours}s ${minutes}dk' : '${minutes}dk';
}

/// "Aktif Etkiler": running effects with the time left (web store.vue).
class ActiveEffectsSection extends StatelessWidget {
  const ActiveEffectsSection({required this.effects, super.key});

  final List<ActiveEffect> effects;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Aktif Etkiler',
      children: [
        for (final effect in effects)
          _Row(
            highlighted: true,
            leading: Row(
              children: [
                if (_effectIcon(effect.itemType) case final icon?) ...[
                  PbIcon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    effectLabel(effect.itemType),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.grey800,
                    ),
                  ),
                ),
              ],
            ),
            trailing: Text(
              '${formatRemaining(effect.expiresAt)} kaldı',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.grey400,
              ),
            ),
          ),
      ],
    );
  }
}

/// "Envanter": owned items; timed ones can be activated (docs 12.2, 12.5).
class InventorySection extends ConsumerStatefulWidget {
  const InventorySection({super.key});

  @override
  ConsumerState<InventorySection> createState() => _InventorySectionState();
}

class _InventorySectionState extends ConsumerState<InventorySection> {
  /// The item being activated; blocks double taps.
  String? _activatingId;

  @override
  Widget build(BuildContext context) {
    final inventoryAsync = ref.watch(storeInventoryProvider);

    return _Section(
      title: 'Envanter',
      children: [
        inventoryAsync.when(
          loading: () => const _Hint('Yükleniyor…'),
          // The inventory isn't cached for offline use.
          error: (_, __) => const _Hint(
            'Envanter yüklenemedi. İnternet bağlantını kontrol et.',
          ),
          data: (items) => items.isEmpty
              ? const _Hint('Henüz hiç ürün almadın.')
              : Column(children: [for (final item in items) _itemRow(item)]),
        ),
      ],
    );
  }

  Widget _itemRow(InventoryItem item) {
    final busy = _activatingId == item.itemId;
    return _Row(
      leading: Row(
        children: [
          Text(item.iconUrl ?? '📦', style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.grey800,
              ),
            ),
          ),
          Text(
            'x${item.quantity}',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.grey400,
            ),
          ),
        ],
      ),
      trailing: item.canActivate
          ? Padding(
              padding: const EdgeInsets.only(left: 12),
              child: ElevatedButton(
                onPressed: _activatingId == null ? () => _activate(item) : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(72, 34),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: busy
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Kullan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            )
          : null,
    );
  }

  Future<void> _activate(InventoryItem item) async {
    final messenger = ScaffoldMessenger.of(context);
    // The server replaces a running effect of the same type: warn first,
    // since its remaining time is lost.
    final now = DateTime.now();
    final running = (ref.read(activeEffectsProvider).valueOrNull ?? [])
        .where((e) => e.itemType == item.itemType && e.expiresAt.isAfter(now))
        .firstOrNull;
    if (running != null && !await _confirmReplace(item, running)) return;
    if (!mounted) return;

    setState(() => _activatingId = item.itemId);
    try {
      final effect = await ref
          .read(storeRepositoryProvider)
          .activate(itemId: item.itemId);
      ref
        ..invalidate(storeInventoryProvider)
        ..invalidate(activeEffectsProvider);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            '${effectLabel(effect.itemType)} etkinleştirildi! '
            '${formatRemaining(effect.expiresAt)} boyunca aktif.',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    } on ApiException catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            e.isNetworkError
                ? 'Bu işlem için internet bağlantısı gerekli.'
                : e.message,
          ),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _activatingId = null);
    }
  }

  Future<bool> _confirmReplace(InventoryItem item, ActiveEffect running) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${effectLabel(item.itemType)} zaten aktif'),
        content: Text(
          'Şimdi kullanırsan süre baştan başlar ve kalan '
          '${formatRemaining(running.expiresAt)} eklenmez. Yine de kullanmak '
          'istiyor musun?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Kullan'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.leading, this.trailing, this.highlighted = false});

  final Widget leading;
  final Widget? trailing;

  /// Active effects use the purple outline of the web store.
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.primary.withValues(alpha: 0.05)
            : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlighted ? AppColors.primary : AppColors.grey200,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(child: leading),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.grey400,
        ),
      ),
    );
  }
}
