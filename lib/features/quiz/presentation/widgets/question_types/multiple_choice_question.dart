import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/html_text.dart';
import 'package:pracby_mobile/features/quiz/data/models/question_model.dart';

class MultipleChoiceQuestion extends StatefulWidget {
  const MultipleChoiceQuestion({
    required this.question,
    required this.onAnswer,
    this.isAnswered = false,
    this.selectedAnswerId,
    this.isCorrect,
    super.key,
  });

  final QuestionModel question;
  final void Function(String answerId) onAnswer;
  final bool isAnswered;
  final String? selectedAnswerId;
  final bool? isCorrect;

  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  String? _selected;

  @override
  void didUpdateWidget(covariant MultipleChoiceQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      _selected = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.question.options ?? [];
    final labels = ['A', 'B', 'C', 'D'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HtmlText(
          data: widget.question.text,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 24),
        ...options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final label = index < labels.length ? labels[index] : '';
          final isSelected = _selected == option.id ||
              widget.selectedAnswerId == option.id;
          final isCorrectOption =
              widget.isAnswered && option.isCorrect;
          final isWrong = widget.isAnswered &&
              isSelected &&
              !option.isCorrect;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: widget.isAnswered
                  ? null
                  : () {
                      setState(() => _selected = option.id);
                      widget.onAnswer(option.id);
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCorrectOption
                        ? AppColors.success
                        : isWrong
                            ? AppColors.error
                            : isSelected
                                ? AppColors.primary
                                : AppColors.grey200,
                    width: isSelected || isCorrectOption ? 2 : 1,
                  ),
                  color: isCorrectOption
                      ? AppColors.success.withValues(alpha: 0.1)
                      : isWrong
                          ? AppColors.error.withValues(alpha: 0.1)
                          : isSelected
                              ? AppColors.primary.withValues(alpha: 0.05)
                              : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.grey100,
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.grey600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: HtmlText(
                        data: option.text,
                        fontSize: 13,
                      ),
                    ),
                    if (isCorrectOption)
                      const Icon(Icons.check_circle, color: AppColors.success)
                    else if (isWrong)
                      const Icon(Icons.cancel, color: AppColors.error),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
