import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';

/// Lesson-map dialogs, mirroring the web client's `components/dialogs`
/// (StepPreviewDialog, RewardStepDialog, EnergyOutDialog).

class _MapDialog extends StatelessWidget {
  const _MapDialog({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.grey200, width: 2),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        ),
      ),
    );
  }
}

Widget _title(String text) => Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: AppColors.grey800,
      ),
    );

Widget _subtitle(String text) => Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.grey500,
      ),
    );

Widget _filledButton(
  String label,
  VoidCallback onPressed, {
  Color color = AppColors.primary,
}) =>
    SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );

Widget _outlinedButton(
  String label,
  VoidCallback onPressed, {
  Color color = AppColors.primary,
  Color border = AppColors.primary,
}) =>
    SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          minimumSize: const Size.fromHeight(46),
          side: BorderSide(color: border, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );

/// "Teste Hazır mısın?" — returns true when the user taps BAŞLAT.
Future<bool> showStepPreviewDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => _MapDialog(
      children: [
        const Text('📝', style: TextStyle(fontSize: 36)),
        const SizedBox(height: 6),
        _title('Teste Hazır mısın?'),
        const SizedBox(height: 14),
        _subtitle('Bu testi tamamladığında bir sonraki adıma geçeceksin.'),
        const SizedBox(height: 18),
        _filledButton('BAŞLAT', () => Navigator.pop(ctx, true)),
        const SizedBox(height: 10),
        _outlinedButton('Kapat', () => Navigator.pop(ctx, false)),
      ],
    ),
  );
  return result ?? false;
}

/// Chest dialog — returns true when the user taps ÖDÜLÜ AL.
Future<bool> showRewardStepDialog(
  BuildContext context, {
  required int rewardAmount,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => _MapDialog(
      children: [
        Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFFBEB),
            border: Border.all(color: const Color(0xFFFCD34D), width: 4),
          ),
          child: const Text('🎁', style: TextStyle(fontSize: 36)),
        ),
        const SizedBox(height: 16),
        _title('Tebrikler! 🎉'),
        const SizedBox(height: 6),
        _subtitle('Bu bölümü tamamladın. Ödülünü almaya hazır mısın?'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFDE68A), width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🌰', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                '+$rewardAmount',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.acorn,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _filledButton(
          'ÖDÜLÜ AL',
          () => Navigator.pop(ctx, true),
          color: AppColors.warning,
        ),
        const SizedBox(height: 10),
        _outlinedButton(
          'Kapat',
          () => Navigator.pop(ctx, false),
          color: AppColors.grey500,
          border: AppColors.grey200,
        ),
      ],
    ),
  );
  return result ?? false;
}

/// "Enerjin Bitti!" on the map — returns true for "🛒 Markete Git".
Future<bool> showEnergyOutDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => _MapDialog(
      children: [
        const Text('🪫', style: TextStyle(fontSize: 36)),
        const SizedBox(height: 14),
        _title('Enerjin Bitti!'),
        const SizedBox(height: 14),
        _subtitle('Enerjinin yenilenmesini bekle veya marketten satın al.'),
        const SizedBox(height: 18),
        _filledButton('🛒 Markete Git', () => Navigator.pop(ctx, true)),
        const SizedBox(height: 10),
        _outlinedButton('Kapat', () => Navigator.pop(ctx, false)),
      ],
    ),
  );
  return result ?? false;
}
