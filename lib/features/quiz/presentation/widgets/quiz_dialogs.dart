import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_icon.dart';
import 'package:pracby_mobile/features/store/data/models/store_item.dart';

/// Dimmed backdrop with a card that slides up from the bottom, like the web
/// dialogs (`components/dialogs/*.vue`).
class BottomOverlay extends StatelessWidget {
  const BottomOverlay({required this.child, this.onBackdropTap, super.key});

  final Widget child;
  final VoidCallback? onBackdropTap;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onBackdropTap,
        child: ColoredBox(
          color: Colors.black.withValues(alpha: 0.6),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {}, // Taps on the card don't reach the backdrop.
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 1, end: 0),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                builder: (context, t, child) => FractionalTranslation(
                  translation: Offset(0, t),
                  child: child,
                ),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 480),
                  padding: EdgeInsets.fromLTRB(
                    28,
                    28,
                    28,
                    28 + MediaQuery.paddingOf(context).bottom,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Web `EnergyEmptyDialog.vue`.
class EnergyEmptySheet extends StatelessWidget {
  const EnergyEmptySheet({
    required this.packages,
    required this.acornBalance,
    required this.loading,
    required this.onBuy,
    required this.onDecline,
    this.purchasingId,
    this.error,
    super.key,
  });

  final List<StoreItem> packages;
  final int acornBalance;
  final bool loading;
  final String? purchasingId;
  final String? error;
  final ValueChanged<StoreItem> onBuy;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    return BottomOverlay(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PbIcon(PbIcons.energyEmpty, size: 56),
          const SizedBox(height: 14),
          const Text(
            'Enerjin Bitti!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Devam etmek için enerji satın al.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.grey400,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.grey200, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const PbIcon(PbIcons.acorn, size: 22),
                const SizedBox(width: 8),
                Text(
                  '$acornBalance',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.acorn,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'PALAMUT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            )
          else if (packages.isEmpty)
            // The list comes from the API, so it is empty when offline.
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Enerji paketleri yüklenemedi. İnternet bağlantını kontrol et.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey400,
                ),
              ),
            )
          else
            for (final pkg in packages) _package(pkg),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          TextButton(
            onPressed: onDecline,
            child: const Text(
              'Hayır, teşekkürler',
              style: TextStyle(
                color: AppColors.grey400,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _package(StoreItem pkg) {
    final disabled = acornBalance < pkg.price || purchasingId != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Opacity(
        opacity: disabled ? 0.4 : 1,
        child: Material(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: disabled ? null : () => onBuy(pkg),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200, width: 2),
              ),
              child: Row(
                children: [
                  if (pkg.iconUrl case final iconUrl?)
                    Text(iconUrl, style: const TextStyle(fontSize: 24))
                  else
                    const PbIcon(PbIcons.energy, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      pkg.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.grey800,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(minWidth: 64),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: purchasingId == pkg.id
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const PbIcon(PbIcons.acorn, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${pkg.price}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.acorn,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Web `ExitWarningDialog.vue`.
class ExitWarningSheet extends StatelessWidget {
  const ExitWarningSheet({
    required this.onContinue,
    required this.onExit,
    super.key,
  });

  final VoidCallback onContinue;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return BottomOverlay(
      onBackdropTap: onContinue,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PbIcon(PbIcons.warning, size: 56),
          const SizedBox(height: 14),
          const Text(
            'Bekle!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Şimdi çıkarsan tüm ilerlemeni kaybedeceksin!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.grey400,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Öğrenmeye Devam',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onExit,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                foregroundColor: AppColors.grey400,
                side: const BorderSide(color: AppColors.grey200, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PbIcon(PbIcons.door, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Testten Çık',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
