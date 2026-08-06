import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/pb_button.dart';
import 'package:pracby_mobile/features/home/data/models/course_model.dart';

class StepPreviewSheet extends StatelessWidget {
  const StepPreviewSheet({
    required this.topic,
    required this.onStartQuiz,
    super.key,
  });

  final TopicModel topic;
  final void Function(StepModel step) onStartQuiz;

  @override
  Widget build(BuildContext context) {
    final activeStep = topic.steps.firstWhere(
      (s) => !(s.progress?.isStepCompleted ?? false) && s.progress != null,
      orElse: () => topic.steps.last,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            topic.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Adım ${activeStep.order} / ${topic.steps.length}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey500,
                ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: topic.steps.where((s) => s.progress?.isStepCompleted ?? false).length /
                topic.steps.length,
            backgroundColor: AppColors.grey200,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 24),
          ...topic.steps.map(
            (step) {
              final isCompleted = step.progress?.isStepCompleted ?? false;
              final isLocked = step.progress == null;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      isCompleted
                          ? Icons.check_circle
                          : isLocked
                              ? Icons.lock
                              : Icons.radio_button_unchecked,
                      color: isCompleted
                          ? AppColors.success
                          : isLocked
                              ? AppColors.grey300
                              : AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        step.title,
                        style: TextStyle(
                          color:
                              isLocked ? AppColors.grey400 : AppColors.grey700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          PbButton(
            text: 'Quiz Başlat',
            onPressed: () => onStartQuiz(activeStep),
          ),
        ],
      ),
    );
  }
}
