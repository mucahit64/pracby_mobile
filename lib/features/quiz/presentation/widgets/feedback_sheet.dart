import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/html_text.dart';

/// Answer feedback panel at the bottom of the quiz (docs 8.5, web quiz page
/// mobile layout): title, correct option, collapsible explanation, report
/// button and "DEVAM ET".
class FeedbackSheet extends StatefulWidget {
  const FeedbackSheet({
    required this.isCorrect,
    required this.onContinue,
    required this.onReport,
    this.correctAnswerText,
    this.explanation,
    super.key,
  });

  final bool isCorrect;
  final String? correctAnswerText;
  final String? explanation;
  final VoidCallback onContinue;
  final VoidCallback onReport;

  @override
  State<FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<FeedbackSheet> {
  // Collapsed by default on mobile (web: explanationOpen = false).
  bool _explanationOpen = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isCorrect ? AppColors.success : AppColors.error;
    final hasExplanation =
        widget.explanation != null && widget.explanation!.isNotEmpty;
    final showCorrect = !widget.isCorrect &&
        widget.correctAnswerText != null &&
        widget.correctAnswerText!.isNotEmpty;
    final title = widget.isCorrect
        ? 'Harika!'
        : (showCorrect ? 'Doğru cevap:' : 'Yanlış!');

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: 0),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      builder: (context, t, child) => FractionalTranslation(
        translation: Offset(0, t),
        child: Opacity(opacity: 1 - t, child: child),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + MediaQuery.paddingOf(context).bottom,
        ),
        decoration: BoxDecoration(
          color: widget.isCorrect
              ? AppColors.successSurface
              : AppColors.errorSurface,
          border: Border(
            top: BorderSide(color: color.withValues(alpha: 0.3), width: 2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                ),
                if (hasExplanation)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: _explanationOpen
                        ? 'Açıklamayı Gizle'
                        : 'Açıklamayı Göster',
                    onPressed: () =>
                        setState(() => _explanationOpen = !_explanationOpen),
                    icon: AnimatedRotation(
                      turns: _explanationOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        size: 20,
                        color: color,
                      ),
                    ),
                  ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Soruyu Bildir',
                  onPressed: widget.onReport,
                  icon: Icon(Icons.flag_outlined, size: 18, color: color),
                ),
              ],
            ),
            if (showCorrect)
              HtmlText(
                data: widget.correctAnswerText!,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            if (hasExplanation && _explanationOpen)
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.25,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 6),
                  child: HtmlText(
                    data: widget.explanation!,
                    isExplanation: true,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey700,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'DEVAM ET',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
