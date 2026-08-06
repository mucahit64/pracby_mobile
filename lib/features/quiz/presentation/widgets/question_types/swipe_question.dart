import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/features/quiz/data/models/question_model.dart';

class SwipeQuestion extends StatefulWidget {
  const SwipeQuestion({
    required this.question,
    required this.onAnswer,
    super.key,
  });

  final QuestionModel question;
  final void Function(String answerId) onAnswer;

  @override
  State<SwipeQuestion> createState() => _SwipeQuestionState();
}

class _SwipeQuestionState extends State<SwipeQuestion> {
  final _swiperController = CardSwiperController();

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Sola kaydır: Yanlış | Sağa kaydır: Doğru',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey500,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 280,
          child: CardSwiper(
            controller: _swiperController,
            cardsCount: 1,
            numberOfCardsDisplayed: 1,
            onSwipe: (previousIndex, currentIndex, direction) {
              if (direction == CardSwiperDirection.right) {
                widget.onAnswer('true');
              } else if (direction == CardSwiperDirection.left) {
                widget.onAnswer('false');
              }
              return true;
            },
            cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.white,
                  border: Border.all(color: AppColors.grey200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      widget.question.text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              heroTag: 'swipe_false',
              onPressed: () => widget.onAnswer('false'),
              backgroundColor: AppColors.error,
              child: const Icon(Icons.close, color: AppColors.white),
            ),
            FloatingActionButton(
              heroTag: 'swipe_true',
              onPressed: () => widget.onAnswer('true'),
              backgroundColor: AppColors.success,
              child: const Icon(Icons.check, color: AppColors.white),
            ),
          ],
        ),
      ],
    );
  }
}
