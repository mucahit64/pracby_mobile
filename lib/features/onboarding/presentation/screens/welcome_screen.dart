import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_button.dart';
import 'package:pracby_mobile/core/widgets/pb_icon.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Icon(
                  Icons.school,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Pracby'ye Hoş Geldin!",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Sınavlara hazırlanmanın en eğlenceli ve etkili yolu. '
                'Her gün kısa quizlerle öğren, seviye atla!',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _buildFeatureRow(
                icon: PbIcons.xp,
                color: AppColors.accent,
                text: 'Günlük kısa quizlerle çalış',
              ),
              const SizedBox(height: 16),
              _buildFeatureRow(
                icon: PbIcons.trophy,
                color: AppColors.primary,
                text: 'Sıralamada yarış, ödüller kazan',
              ),
              const SizedBox(height: 16),
              _buildFeatureRow(
                icon: PbIcons.fire,
                color: AppColors.error,
                text: "Streak'ini koru, motivasyonunu artır",
              ),
              const Spacer(flex: 2),
              PbButton(
                text: 'Başla',
                onPressed: () => context.go(Routes.examSelect),
              ),
              const SizedBox(height: 12),
              PbButton(
                text: 'Zaten hesabım var',
                onPressed: () => context.go(Routes.login),
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow({
    required PbIcons icon,
    required Color color,
    required String text,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: PbIcon(icon),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
      ],
    );
  }
}
