import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_icon.dart';
import 'package:pracby_mobile/features/profile/data/models/streak_day.dart';
import 'package:pracby_mobile/features/profile/presentation/widgets/profile_ui.dart';

/// The web profile's "Bu Haftaki Seri" card: a fire on days with a finished
/// quiz, a dashed purple ring around today, gray dots otherwise. The home
/// streak sheet uses the simpler `WeekStreakRow` look instead.
class ProfileWeekRow extends StatelessWidget {
  const ProfileWeekRow({required this.days, super.key});

  final List<StreakDay> days;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200, width: 2),
      ),
      child: Row(
        children: [
          for (var i = 0; i < days.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(child: _Day(days[i])),
          ],
        ],
      ),
    );
  }
}

class _Day extends StatelessWidget {
  const _Day(this.day);

  final StreakDay day;

  @override
  Widget build(BuildContext context) {
    final Widget circle = Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: day.done
            ? AppColors.warning.withValues(alpha: 0.15)
            : day.isToday
            ? null
            : AppColors.grey100,
      ),
      child: day.done
          // PbIcon is 1.2em of the 18px text.
          ? const PbIcon(PbIcons.fire, size: 22)
          : const Text(
              '·',
              style: TextStyle(
                fontSize: 18,
                height: 1,
                color: AppColors.grey800,
              ),
            ),
    );
    return Column(
      children: [
        if (day.isToday && !day.done)
          DashedBorder(color: AppColors.primary, radius: 18, child: circle)
        else
          circle,
        const SizedBox(height: 6),
        Text(
          trUpper(day.label),
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: TextStyle(
            fontSize: 10.88,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.27,
            color: day.isToday ? AppColors.primary : AppColors.grey400,
          ),
        ),
      ],
    );
  }
}
