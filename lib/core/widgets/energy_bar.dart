import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';

class EnergyBar extends StatelessWidget {
  const EnergyBar({
    required this.current,
    required this.max,
    this.nextEnergyIn,
    super.key,
  });

  final int current;
  final int max;
  final Duration? nextEnergyIn;

  @override
  Widget build(BuildContext context) {
    final progress = max > 0 ? current / max : 0.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.bolt, color: AppColors.accent, size: 20),
        const SizedBox(width: 4),
        SizedBox(
          width: 48,
          height: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.grey200,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$current/$max',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
