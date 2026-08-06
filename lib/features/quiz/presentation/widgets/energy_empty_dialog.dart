import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';

class EnergyEmptyDialog extends StatelessWidget {
  const EnergyEmptyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bolt, size: 64, color: AppColors.grey400),
            const SizedBox(height: 16),
            Text(
              'Enerjin Bitti!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Quiz yapmak için enerji gerekiyor. '
              'Mağazadan enerji satın alabilir veya dolmasını bekleyebilirsin.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Bekle'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, 'store');
                    },
                    child: const Text('Mağaza'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
