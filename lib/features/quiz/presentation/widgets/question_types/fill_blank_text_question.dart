import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_button.dart';
import 'package:pracby_mobile/features/quiz/data/models/question_model.dart';

class FillBlankTextQuestion extends StatefulWidget {
  const FillBlankTextQuestion({
    required this.question,
    required this.onAnswer,
    this.isAnswered = false,
    super.key,
  });

  final QuestionModel question;
  final void Function(String answerId) onAnswer;
  final bool isAnswered;

  @override
  State<FillBlankTextQuestion> createState() => _FillBlankTextQuestionState();
}

class _FillBlankTextQuestionState extends State<FillBlankTextQuestion> {
  final _controller = TextEditingController();

  @override
  void didUpdateWidget(covariant FillBlankTextQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        const SizedBox(height: 32),
        TextField(
          controller: _controller,
          enabled: !widget.isAnswered,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'Cevabını yaz...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          onSubmitted: widget.isAnswered
              ? null
              : (value) {
                  if (value.trim().isNotEmpty) {
                    widget.onAnswer(value.trim());
                  }
                },
        ),
        const SizedBox(height: 24),
        PbButton(
          text: 'Kontrol Et',
          onPressed: widget.isAnswered || _controller.text.trim().isEmpty
              ? null
              : () => widget.onAnswer(_controller.text.trim()),
        ),
      ],
    );
  }
}
