import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/features/quiz/presentation/providers/quiz_provider.dart';

/// Quiz result, mirroring the "Quiz finished" block of the web quiz page.
class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({
    required this.state,
    required this.isBoss,
    required this.onRetry,
    required this.onContinue,
    super.key,
  });

  final QuizState state;

  /// Boss (topic final) session. It has no step, so the API never reports
  /// `step_completed`; finishing it is enough (same as the web).
  final bool isBoss;
  final VoidCallback onRetry;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final depleted = state.energyDepleted;
    final bossPassed = isBoss && !state.energyDepleted;
    final total = state.questions.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            children: [
              Text(
                depleted ? '🔋' : (bossPassed ? '⚔️' : '🎊'),
                style: const TextStyle(fontSize: 72, height: 1),
              ),
              const SizedBox(height: 20),
              Text(
                depleted
                    ? 'Enerjin Bitti! 🔋'
                    : (bossPassed ? '⚔️ Boss Testi Geçildi!' : 'Tebrikler! 🎊'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.grey800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                depleted
                    ? 'Enerjin tükendi, test sonlandırıldı.'
                    : (isBoss ? 'Adım finali tamamlandı!' : 'Quiz tamamlandı!'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey400,
                ),
              ),
              const SizedBox(height: 20),
              _scoreCard(total),
              if (state.stepCompleted) ...[
                const SizedBox(height: 20),
                _pill('🎉 Adım tamamlandı!', AppColors.success),
              ],
              if (state.topicCompleted) ...[
                const SizedBox(height: 20),
                _pill('🏆 Konu tamamlandı!', AppColors.warning),
              ],
              if (state.pendingSync) ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFFDE68A),
                      width: 2,
                    ),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFB45309),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Sonuçlar internete bağlanınca otomatik '
                          'kaydedilecek.',
                          style: TextStyle(
                            color: Color(0xFFB45309),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onRetry,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        foregroundColor: AppColors.grey500,
                        side: const BorderSide(
                          color: AppColors.grey200,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        '🔄 Tekrar Dene',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onContinue,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Devam Et →',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scoreCard(int total) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.primary.withValues(alpha: 0.05),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                Text(
                  'SINAV PUANI',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.examScore}',
                  style: const TextStyle(
                    fontSize: 60,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${state.correctCount} doğru / $total soru',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey400,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.grey100),
          IntrinsicHeight(
            child: Row(
              children: [
                _stat('${state.correctCount}', 'DOĞRU', AppColors.success),
                const VerticalDivider(width: 1, color: AppColors.grey100),
                _stat(
                  '${total - state.correctCount}',
                  'YANLIŞ',
                  AppColors.error,
                ),
                const VerticalDivider(width: 1, color: AppColors.grey100),
                _stat(
                  '+${state.acornEarned}',
                  'ACORN',
                  const Color(0xFFD97706),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.grey400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w800, color: color),
      ),
    );
  }
}
