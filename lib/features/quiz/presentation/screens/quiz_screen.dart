import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/html_text.dart';
import 'package:pracby_mobile/core/widgets/pb_loading.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/quiz/data/models/question_model.dart';
import 'package:pracby_mobile/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:pracby_mobile/features/quiz/presentation/widgets/question_types/fill_blank_text_question.dart';
import 'package:pracby_mobile/features/quiz/presentation/widgets/question_types/flashcard_question.dart';
import 'package:pracby_mobile/features/quiz/presentation/widgets/question_types/matching_question.dart';
import 'package:pracby_mobile/features/quiz/presentation/widgets/question_types/ordering_question.dart';
import 'package:pracby_mobile/features/quiz/presentation/widgets/question_types/swipe_question.dart';
import 'package:pracby_mobile/features/home/presentation/providers/course_provider.dart';
import 'package:pracby_mobile/features/quiz/presentation/widgets/quiz_result_screen.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({
    required this.stepId,
    this.topicId = '',
    super.key,
  });

  final String stepId;
  final String topicId;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedAnswerId;
  bool _answered = false;
  late AnimationController _feedbackController;
  late Animation<double> _feedbackAnimation;

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _feedbackAnimation = CurvedAnimation(
      parent: _feedbackController,
      curve: Curves.easeOut,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(quizStateProvider.notifier).startQuiz(
            stepId: widget.stepId,
            topicId: widget.topicId,
          );
    });
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<bool> _confirmExit() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Çıkmak istiyor musun?'),
        content: const Text('İlerleme kaydedilmeyecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Devam Et'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Çık'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _handleAnswer(String answerId) {
    if (_answered) return;
    setState(() {
      _answered = true;
      _selectedAnswerId = answerId;
    });
    ref.read(quizStateProvider.notifier).submitAnswer(answerId);
    _feedbackController.forward(from: 0);
  }

  void _handleNext() {
    setState(() {
      _answered = false;
      _selectedAnswerId = null;
    });
    _feedbackController.reset();
    ref.read(quizStateProvider.notifier).nextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizStateProvider);
    final user = ref.watch(authStateProvider).valueOrNull;

    if (quizState.isFinished) {
      final hasFinishError = quizState.error != null;
      return Stack(
        children: [
          QuizResultScreen(
            correctCount: quizState.correctAnswers,
            totalCount: quizState.totalQuestions,
            xpEarned: quizState.xpEarned,
            onDone: () {
              ref.invalidate(courseFullProvider);
              ref.invalidate(coursesByExamProvider);
              ref.invalidate(coursesByModuleProvider);
              ref.read(authStateProvider.notifier).refreshUser();
              Navigator.of(context).pop();
            },
          ),
          if (hasFinishError)
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.error),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber, color: AppColors.error),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'İlerleme kaydedilemedi. Lütfen tekrar dene.',
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => ref
                            .read(quizStateProvider.notifier)
                            .retryFinish(),
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final should = await _confirmExit();
        if (should && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(quizState, user?.energy ?? 0),
              Expanded(child: _buildBody(quizState)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(QuizState quizState, int energy) {
    final progress = quizState.totalQuestions > 0
        ? (quizState.currentIndex) / quizState.totalQuestions
        : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
      child: Row(
        children: [
          // X button
          GestureDetector(
            onTap: () async {
              final should = await _confirmExit();
              if (should && context.mounted) Navigator.of(context).pop();
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.grey200,
              ),
              child: const Icon(Icons.close, size: 18, color: AppColors.grey600),
            ),
          ),
          const SizedBox(width: 12),
          // Progress bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: AppColors.grey200,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Energy
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.battery_charging_full,
                color: Color(0xFF22C55E),
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '$energy',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.grey800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(QuizState quizState) {
    if (quizState.isLoading) {
      return const PbLoading(message: 'Sorular yükleniyor...');
    }

    if (quizState.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                quizState.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.grey600),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(quizStateProvider.notifier)
                    .startQuiz(
                        stepId: widget.stepId, topicId: widget.topicId),
                child: const Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
      );
    }

    final session = quizState.session;
    if (session == null) return const SizedBox.shrink();

    final question = session.questions[quizState.currentIndex];

    return Column(
      children: [
        // Question counter + flag + XP row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(
            children: [
              Text(
                'Soru ${quizState.currentIndex + 1} / ${quizState.totalQuestions}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.flag_outlined,
                size: 18,
                color: AppColors.grey400,
              ),
              const SizedBox(width: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.bolt,
                    size: 16,
                    color: AppColors.accent,
                  ),
                  Text(
                    '+${quizState.xpEarned} XP',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Question + options
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HtmlText(data: question.text),
                const SizedBox(height: 24),
                _buildQuestionWidget(question),
              ],
            ),
          ),
        ),
        // Feedback + Next button
        if (_answered && quizState.lastAnswerCorrect != null)
          _buildBottomFeedback(quizState),
      ],
    );
  }

  Widget _buildQuestionWidget(QuestionModel question) {
    switch (question.type) {
      case QuestionType.multipleChoice:
      case QuestionType.trueFalse:
        return _buildOptions(question);
      case QuestionType.fillBlank:
      case QuestionType.fillBlankText:
      case QuestionType.fillBlankChip:
        return FillBlankTextQuestion(
          question: question,
          onAnswer: _handleTextAnswer,
          isAnswered: _answered,
        );
      case QuestionType.flashcard:
        return FlashcardQuestion(
          question: question,
          onAnswer: (value) => _handleFlashcardAnswer(value == 'known'),
        );
      case QuestionType.swipe:
        return SwipeQuestion(
          question: question,
          onAnswer: _handleAnswer,
        );
      case QuestionType.matching:
        return MatchingQuestion(
          question: question,
          onAnswer: _handleMatchingAnswer,
          isAnswered: _answered,
        );
      case QuestionType.ordering:
        return OrderingQuestion(
          question: question,
          onAnswer: _handleOrderingAnswer,
          isAnswered: _answered,
        );
    }
  }

  void _handleTextAnswer(String text) {
    if (_answered) return;
    setState(() => _answered = true);
    ref.read(quizStateProvider.notifier).submitTextAnswer(text);
    _feedbackController.forward(from: 0);
  }

  void _handleFlashcardAnswer(bool isCorrect) {
    if (_answered) return;
    setState(() => _answered = true);
    ref.read(quizStateProvider.notifier).submitFlashcardAnswer(isCorrect);
    _feedbackController.forward(from: 0);
  }

  void _handleMatchingAnswer(List<Map<String, int>> matchingAnswer) {
    if (_answered) return;
    setState(() => _answered = true);
    ref.read(quizStateProvider.notifier).submitMatchingAnswer(matchingAnswer);
    _feedbackController.forward(from: 0);
  }

  void _handleOrderingAnswer(List<int> orderedIndices) {
    if (_answered) return;
    setState(() => _answered = true);
    ref.read(quizStateProvider.notifier).submitOrderingAnswer(orderedIndices);
    _feedbackController.forward(from: 0);
  }

  Widget _buildOptions(QuestionModel question) {
    final options = question.options ?? [];
    const labels = ['A', 'B', 'C', 'D', 'E', 'F'];

    return Column(
      children: options.asMap().entries.map((entry) {
        final idx = entry.key;
        final opt = entry.value;
        final label = idx < labels.length ? labels[idx] : '${idx + 1}';

        var borderColor = AppColors.grey200;
        var bgColor = Colors.white;
        var labelBg = AppColors.grey100;
        var labelText = AppColors.grey600;

        if (_answered) {
          if (opt.isCorrect) {
            borderColor = AppColors.success;
            bgColor = AppColors.success.withValues(alpha: 0.06);
            labelBg = AppColors.success;
            labelText = Colors.white;
          } else if (opt.id == _selectedAnswerId && !opt.isCorrect) {
            borderColor = AppColors.error;
            bgColor = AppColors.error.withValues(alpha: 0.06);
            labelBg = AppColors.error;
            labelText = Colors.white;
          }
        } else if (opt.id == _selectedAnswerId) {
          borderColor = AppColors.primary;
          bgColor = AppColors.primary.withValues(alpha: 0.06);
          labelBg = AppColors.primary;
          labelText = Colors.white;
        }

        return GestureDetector(
          onTap: () => _handleAnswer(opt.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 1.5),
              color: bgColor,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: labelBg,
                    border: Border.all(
                      color: _answered ? Colors.transparent : AppColors.grey300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: labelText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: HtmlText(
                    data: opt.text,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomFeedback(QuizState quizState) {
    final isCorrect = quizState.lastAnswerCorrect ?? false;
    final color = isCorrect ? AppColors.success : AppColors.error;
    final question = quizState.session?.questions[quizState.currentIndex];
    final isLast =
        quizState.currentIndex >= quizState.totalQuestions - 1;

    return FadeTransition(
      opacity: _feedbackAnimation,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          border: Border(top: BorderSide(color: color.withValues(alpha: 0.3))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: color,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  isCorrect ? 'Doğru!' : 'Yanlış!',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: color,
                  ),
                ),
              ],
            ),
            if (!isCorrect && question?.explanation != null) ...[
              const SizedBox(height: 8),
              Text(
                question!.explanation!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.grey700,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isLast ? 'Bitir' : 'Devam Et',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


