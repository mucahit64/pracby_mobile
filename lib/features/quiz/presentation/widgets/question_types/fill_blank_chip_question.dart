import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/features/quiz/data/models/question_model.dart';

class FillBlankChipQuestion extends StatefulWidget {
  const FillBlankChipQuestion({
    required this.question,
    required this.onAnswer,
    this.isAnswered = false,
    super.key,
  });

  final QuestionModel question;
  final void Function(String answerId) onAnswer;
  final bool isAnswered;

  @override
  State<FillBlankChipQuestion> createState() => _FillBlankChipQuestionState();
}

class _FillBlankChipQuestionState extends State<FillBlankChipQuestion> {
  final List<String> _selectedChips = [];
  final List<String> _availableChips = [];

  @override
  void initState() {
    super.initState();
    _availableChips.addAll(widget.question.chips ?? []);
  }

  @override
  void didUpdateWidget(covariant FillBlankChipQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      _selectedChips.clear();
      _availableChips
        ..clear()
        ..addAll(widget.question.chips ?? []);
    }
  }

  void _selectChip(String chip) {
    if (widget.isAnswered) return;
    setState(() {
      _availableChips.remove(chip);
      _selectedChips.add(chip);
    });

    final blanksCount = widget.question.blanks?.length ?? 1;
    if (_selectedChips.length >= blanksCount) {
      widget.onAnswer(_selectedChips.join(','));
    }
  }

  void _removeChip(int index) {
    if (widget.isAnswered) return;
    setState(() {
      final chip = _selectedChips.removeAt(index);
      _availableChips.add(chip);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.question.text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 24),
        // Blank slots
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            widget.question.blanks?.length ?? 1,
            (index) {
              final hasChip = index < _selectedChips.length;
              return GestureDetector(
                onTap: hasChip ? () => _removeChip(index) : null,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 80),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: hasChip ? AppColors.primary : AppColors.grey300,
                      style:
                          hasChip ? BorderStyle.solid : BorderStyle.solid,
                    ),
                    color: hasChip
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.grey100,
                  ),
                  child: Text(
                    hasChip ? _selectedChips[index] : '______',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: hasChip ? AppColors.primary : AppColors.grey400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 32),
        // Available chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableChips.map((chip) {
            return GestureDetector(
              onTap: () => _selectChip(chip),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.grey300),
                  color: AppColors.white,
                ),
                child: Text(
                  chip,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
