import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';

class RewardDialog extends StatelessWidget {
  const RewardDialog({
    required this.xp,
    this.acorns,
    super.key,
  });

  final int xp;
  final int? acorns;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.card_giftcard, size: 64, color: AppColors.accent),
            const SizedBox(height: 16),
            Text(
              'Ödül Kazandın!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: AppColors.accent),
                const SizedBox(width: 4),
                Text(
                  '+$xp XP',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
                if (acorns != null && acorns! > 0) ...[
                  const SizedBox(width: 16),
                  const Icon(Icons.eco, color: AppColors.accent),
                  const SizedBox(width: 4),
                  Text(
                    '+$acorns',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Harika!'),
            ),
          ],
        ),
      ),
    );
  }
}
