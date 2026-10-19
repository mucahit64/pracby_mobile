import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/features/profile/data/models/streak_day.dart';

/// Mon–Sun dots: green when a quiz was finished that day, ringed purple for
/// today (web PbRightPanel / profile "Bu Haftaki Seri").
class WeekStreakRow extends StatelessWidget {
  const WeekStreakRow({required this.days, super.key});

  final List<StreakDay> days;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final day in days)
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: day.isToday
                        ? AppColors.primary
                        : day.done
                        ? AppColors.success
                        : AppColors.grey200,
                    border: day.isToday
                        ? Border.all(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            width: 3,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          )
                        : null,
                  ),
                  child: day.done
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                const SizedBox(height: 6),
                Text(
                  day.label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey400,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
