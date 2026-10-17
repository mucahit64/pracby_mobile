import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/api/api_client.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/utils/html_utils.dart';
import 'package:pracby_mobile/core/widgets/html_text.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';
import 'package:pracby_mobile/features/home/presentation/providers/course_provider.dart';
import 'package:pracby_mobile/features/quiz/data/models/question_model.dart';
import 'package:pracby_mobile/features/quiz/data/quiz_repository.dart';
import 'package:pracby_mobile/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:pracby_mobile/features/quiz/presentation/widgets/feedback_sheet.dart';
import 'package:pracby_mobile/features/quiz/presentation/widgets/question_inputs.dart';
import 'package:pracby_mobile/features/quiz/presentation/widgets/quiz_dialogs.dart';
import 'package:pracby_mobile/features/quiz/presentation/widgets/quiz_result_screen.dart';
import 'package:pracby_mobile/features/quiz/presentation/widgets/report_question_dialog.dart';

/// Quiz page, mirroring the web client's `pages/quiz/[id].vue`.
class QuizScreen extends ConsumerWidget {
  const QuizScreen({required this.params, super.key});

  final QuizParams params;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = quizControllerProvider(params);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    ref.listen(provider.select((s) => s.exitRequested), (_, exit) {
      if (exit) _leave(context, ref);
    });

    final Widget body;
    if (state.loading) {
      body = const _Loading();
    } else if (state.error != null) {
      body = _Error(message: state.error!, onBack: () => _leave(context, ref));
    } else if (state.finished) {
      body = QuizResultScreen(
        state: state,
        isBoss: params.sessionType == 'topic_final',
        onRetry: controller.restart,
        // Guests see the register wall after each quiz (docs 10.8).
        onContinue: state.isGuest
            ? () => context.go(Routes.registerWall)
            : () => _leave(context, ref),
      );
    } else if (state.questions.isNotEmpty) {
      body = _QuizInProgress(state: state, controller: controller);
    } else {
      body = const SizedBox.shrink();
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (state.finished || state.questions.isEmpty) {
          _leave(context, ref);
        } else {
          controller.handleClose();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(bottom: false, child: body),
            if (state.dialog == QuizDialog.energyEmpty)
              EnergyEmptySheet(
                packages: state.energyPackages,
                acornBalance: state.acornBalanceForDialog,
                loading: state.loadingPackages,
                purchasingId: state.purchasingId,
                error: state.purchaseError,
                onBuy: controller.buyEnergy,
                onDecline: controller.declineEnergyPurchase,
              ),
            if (state.dialog == QuizDialog.exitWarning)
              ExitWarningSheet(
                onContinue: controller.continueFromWarning,
                onExit: controller.exit,
              ),
          ],
        ),
      ),
    );
  }

  /// Back to the page the quiz was opened from — the lesson map keeps its
  /// module / course — with fresh progress.
  void _leave(BuildContext context, WidgetRef ref) {
    ref.invalidate(courseFullProvider);
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.home);
    }
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(strokeWidth: 4),
          ),
          SizedBox(height: 12),
          Text(
            'Sorular yükleniyor…',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.grey400,
            ),
          ),
        ],
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.message, required this.onBack});

  final String message;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.grey400,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onBack,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 46),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: const Text(
                'Öğrenmeye Dön',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizInProgress extends ConsumerWidget {
  const _QuizInProgress({required this.state, required this.controller});

  final QuizState state;
  final QuizController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final question = state.currentQuestion!;
    return Column(
      children: [
        _TopBar(state: state, onClose: controller.handleClose),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (question.examSource?.isNotEmpty ?? false) ...[
                  _MetaRow(question: question),
                  const SizedBox(height: 16),
                ],
                _QuestionBody(question: question),
                QuestionInput(
                  question: question,
                  state: state,
                  onAnswer: controller.answer,
                ),
              ],
            ),
          ),
        ),
        if (state.answered)
          FeedbackSheet(
            key: ValueKey('feedback-${question.id}'),
            isCorrect: state.lastAnswerCorrect,
            correctAnswerText: state.correctAnswerText,
            explanation: question.explanation,
            onContinue: controller.next,
            onReport: () => _report(context, ref, question),
          ),
      ],
    );
  }

  void _report(BuildContext context, WidgetRef ref, QuestionModel question) {
    showReportQuestionDialog(
      context,
      questionId: question.id,
      // Guests report with their device UUID (docs 9.2).
      guestId: state.isGuest ? ref.read(guestProvider.notifier).guestId : null,
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.state, required this.onClose});

  final QuizState state;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final total = state.questions.length;
    final done =
        state.answeredCount + (state.answered && state.isLastQuestion ? 1 : 0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.grey100)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onClose,
            customBorder: const CircleBorder(),
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.grey100,
                border: Border.all(color: AppColors.grey200),
              ),
              child: const Text(
                '✕',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: total == 0 ? 0 : done / total),
                duration: const Duration(milliseconds: 500),
                builder: (_, value, __) => LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: AppColors.grey100,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${state.currentIndex + 1} / $total',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.grey400,
            ),
          ),
          const SizedBox(width: 12),
          if (state.unlimitedEnergy)
            const Text(
              '♾️🔋',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.success,
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFFEE2E2)),
              ),
              child: Text(
                '🔋 ${state.energy}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Past-exam source badge; only built when the question has one.
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.question});

  final QuestionModel question;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: _Pill(
            text: '📚 ${question.examSource}',
            color: const Color(0xFF2563EB),
            background: const Color(0xFFEFF6FF),
            border: const Color(0xFFDBEAFE),
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.text,
    required this.color,
    required this.background,
    required this.border,
  });

  final String text;
  final Color color;
  final Color background;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

/// Question text with the image at the `<!--img-->` marker (docs 8.2).
/// Swipe and fill-blank questions render their own text.
class _QuestionBody extends StatelessWidget {
  const _QuestionBody({required this.question});

  final QuestionModel question;

  @override
  Widget build(BuildContext context) {
    final showText =
        question.type != QuestionType.swipe &&
        question.type != QuestionType.fillBlank;
    final parts = HtmlUtils.splitAtImage(question.text);

    Widget text(String html) => Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: HtmlText(data: html, fontSize: 16),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showText && parts.before.trim().isNotEmpty) text(parts.before),
        if (question.imageUrl != null && question.imageUrl!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _QuestionImage(path: question.imageUrl!),
          ),
        if (showText && parts.after.trim().isNotEmpty) text(parts.after),
      ],
    );
  }
}

class _QuestionImage extends StatelessWidget {
  const _QuestionImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    // Web: block mx-auto w-auto max-w-full max-h-56 object-contain rounded-lg
    // — natural size, at most 224px tall, centered, no fade.
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 224),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            // Served by the web server, not the API (docs 8.3).
            imageUrl: '$webBaseUrl/$path',
            fit: BoxFit.contain,
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
            errorWidget: (_, __, ___) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: Color(0xFFD97706),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Bu sorunun görseli yüklenemedi veya eksik.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD97706),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
