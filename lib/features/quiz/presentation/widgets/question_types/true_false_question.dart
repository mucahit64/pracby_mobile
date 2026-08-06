import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/html_text.dart';
import 'package:pracby_mobile/features/quiz/data/models/question_model.dart';

class TrueFalseQuestion extends StatelessWidget {
  const TrueFalseQuestion({
    required this.question,
    required this.onAnswer,
    this.isAnswered = false,
    this.selectedAnswerId,
    super.key,
  });

  final QuestionModel question;
  final void Function(String answerId) onAnswer;
  final bool isAnswered;
  final String? selectedAnswerId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HtmlText(
          data: question.text,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        Row(
          children: [
            Expanded(
              child: _buildOptionButton(
                context,
                label: 'Doğru',
                answerId: 'true',
                color: AppColors.success,
                icon: Icons.check,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildOptionButton(
                context,
                label: 'Yanlış',
                answerId: 'false',
                color: AppColors.error,
                icon: Icons.close,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionButton(
    BuildContext context, {
    required String label,
    required String answerId,
    required Color color,
    required IconData icon,
  }) {
    final isSelected = selectedAnswerId == answerId;
    final isCorrect = isAnswered &&
        (question.options?.any((o) => o.id == answerId && o.isCorrect) ?? false);
    final isWrong = isAnswered && isSelected && !isCorrect;

    return GestureDetector(
      onTap: isAnswered ? null : () => onAnswer(answerId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCorrect
                ? AppColors.success
                : isWrong
                    ? AppColors.error
                    : isSelected
                        ? color
                        : AppColors.grey200,
            width: isSelected || isCorrect ? 3 : 1,
          ),
          color: isCorrect
              ? AppColors.success.withValues(alpha: 0.1)
              : isWrong
                  ? AppColors.error.withValues(alpha: 0.1)
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
