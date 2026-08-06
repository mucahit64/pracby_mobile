import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_button.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({
    required this.correctCount,
    required this.totalCount,
    required this.xpEarned,
    required this.onDone,
    super.key,
  });

  final int correctCount;
  final int totalCount;
  final int xpEarned;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final accuracy = totalCount > 0 ? correctCount / totalCount : 0.0;
    final incorrectCount = totalCount - correctCount;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Icon(
                accuracy >= 0.7 ? Icons.emoji_events : Icons.replay,
                size: 80,
                color: accuracy >= 0.7 ? AppColors.accent : AppColors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                accuracy >= 0.7 ? 'Harika!' : 'Devam Et!',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 32),
              _StatRow(
                icon: Icons.check_circle,
                color: AppColors.success,
                label: 'Doğru',
                value: '$correctCount',
              ),
              const SizedBox(height: 12),
              _StatRow(
                icon: Icons.cancel,
                color: AppColors.error,
                label: 'Yanlış',
                value: '$incorrectCount',
              ),
              const SizedBox(height: 12),
              _StatRow(
                icon: Icons.percent,
                color: AppColors.primary,
                label: 'Başarı',
                value: '${(accuracy * 100).round()}%',
              ),
              const SizedBox(height: 12),
              _StatRow(
                icon: Icons.star,
                color: AppColors.accent,
                label: 'XP Kazanıldı',
                value: '+$xpEarned',
              ),
              const Spacer(flex: 2),
              PbButton(
                text: 'Devam Et',
                onPressed: onDone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withValues(alpha: 0.1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
