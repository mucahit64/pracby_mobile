import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/features/quiz/data/models/question_model.dart';

class MatchingQuestion extends StatefulWidget {
  const MatchingQuestion({
    required this.question,
    required this.onAnswer,
    required this.isAnswered,
    super.key,
  });

  final QuestionModel question;
  final void Function(List<Map<String, int>> matchingAnswer) onAnswer;
  final bool isAnswered;

  @override
  State<MatchingQuestion> createState() => _MatchingQuestionState();
}

class _MatchingQuestionState extends State<MatchingQuestion> {
  final Map<int, int?> _matches = {};
  int? _selectedLeftIndex;

  List<MatchingPair> get _pairs {
    final typeData = widget.question.typeData;
    if (typeData == null || typeData['pairs'] == null) return [];
    return (typeData['pairs'] as List<dynamic>)
        .map((e) => MatchingPair.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<String> get _leftItems => _pairs.map((p) => p.left).toList();

  List<String> get _rightItems {
    // Shuffle right items for display
    final rights = _pairs.map((p) => p.right).toList();
    return rights;
  }

  @override
  Widget build(BuildContext context) {
    final pairs = _pairs;
    if (pairs.isEmpty) {
      return const Center(child: Text('Eşleştirme verisi bulunamadı'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Eşleştirme yapın',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.grey500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column
            Expanded(
              child: Column(
                children: List.generate(pairs.length, (index) {
                  final isSelected = _selectedLeftIndex == index;
                  final isMatched = _matches.containsKey(index);

                  return GestureDetector(
                    onTap: widget.isAnswered
                        ? null
                        : () => _selectLeft(index),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : isMatched
                                  ? AppColors.success
                                  : AppColors.grey200,
                          width: isSelected ? 2 : 1.5,
                        ),
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.06)
                            : isMatched
                                ? AppColors.success.withValues(alpha: 0.06)
                                : Colors.white,
                      ),
                      child: Text(
                        _leftItems[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.grey800,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(width: 12),
            // Right column
            Expanded(
              child: Column(
                children: List.generate(pairs.length, (index) {
                  final isMatchedTo = _matches.values.contains(index);

                  return GestureDetector(
                    onTap: widget.isAnswered
                        ? null
                        : () => _selectRight(index),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isMatchedTo
                              ? AppColors.success
                              : AppColors.grey200,
                          width: 1.5,
                        ),
                        color: isMatchedTo
                            ? AppColors.success.withValues(alpha: 0.06)
                            : Colors.white,
                      ),
                      child: Text(
                        _rightItems[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isMatchedTo
                              ? AppColors.success
                              : AppColors.grey800,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
        if (!widget.isAnswered && _matches.length == pairs.length)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submitAnswer,
                child: const Text('Onayla'),
              ),
            ),
          ),
      ],
    );
  }

  void _selectLeft(int index) {
    setState(() {
      _selectedLeftIndex = index;
    });
  }

  void _selectRight(int rightIndex) {
    if (_selectedLeftIndex == null) return;

    setState(() {
      // Remove any existing match for this left index
      _matches[_selectedLeftIndex!] = rightIndex;
      _selectedLeftIndex = null;
    });
  }

  void _submitAnswer() {
    final answer = _matches.entries
        .map((e) => {'leftIndex': e.key, 'rightIndex': e.value!})
        .toList();
    widget.onAnswer(answer);
  }
}
