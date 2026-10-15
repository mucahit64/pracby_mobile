import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/widgets/html_text.dart';
import 'package:pracby_mobile/features/quiz/data/models/question_model.dart';
import 'package:pracby_mobile/features/quiz/data/models/quiz_answer.dart';
import 'package:pracby_mobile/features/quiz/presentation/providers/quiz_provider.dart';

/// Answer area for every question type, mirroring the web quiz page
/// (`pages/quiz/[id].vue`). Grading happens in [QuizController.answer].
class QuestionInput extends StatelessWidget {
  const QuestionInput({
    required this.question,
    required this.state,
    required this.onAnswer,
    super.key,
  });

  final QuestionModel question;
  final QuizState state;
  final ValueChanged<AnswerInputData> onAnswer;

  @override
  Widget build(BuildContext context) {
    // Keyed by question so per-question widget state resets.
    final key = ValueKey(question.id);
    return switch (question.type) {
      QuestionType.multipleChoice || QuestionType.trueFalse => _ChoiceList(
          key: key,
          question: question,
          state: state,
          onAnswer: onAnswer,
        ),
      QuestionType.fillBlank => _FillBlank(
          key: key,
          question: question,
          state: state,
          onAnswer: onAnswer,
        ),
      QuestionType.flashcard => _Flashcard(
          key: key,
          question: question,
          state: state,
          onAnswer: onAnswer,
        ),
      QuestionType.matching => _Matching(
          key: key,
          question: question,
          state: state,
          onAnswer: onAnswer,
        ),
      QuestionType.ordering => _Ordering(
          key: key,
          question: question,
          state: state,
          onAnswer: onAnswer,
        ),
      QuestionType.swipe => _Swipe(
          key: key,
          question: question,
          state: state,
          onAnswer: onAnswer,
        ),
    };
  }
}

const _letters = ['A', 'B', 'C', 'D', 'E', 'F'];

class _ChoiceList extends StatelessWidget {
  const _ChoiceList({
    required this.question,
    required this.state,
    required this.onAnswer,
    super.key,
  });

  final QuestionModel question;
  final QuizState state;
  final ValueChanged<AnswerInputData> onAnswer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final (i, option) in question.options.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _option(i, option),
          ),
      ],
    );
  }

  Widget _option(int index, AnswerOption option) {
    final answered = state.answered;
    final selected = option.id == state.selectedAnswerId;

    // Same rules as web getMcOptionClass / getMcLetterClass.
    var border = AppColors.grey200;
    var background = Colors.white;
    var letterBorder = AppColors.grey300;
    var letterColor = AppColors.grey400;
    var letterBackground = Colors.transparent;
    var opacity = 1.0;

    if (answered) {
      if (selected) {
        final c = state.lastAnswerCorrect ? AppColors.success : AppColors.error;
        border = c;
        background = c.withValues(alpha: 0.1);
        letterBorder = c;
        letterColor = c;
        letterBackground = c.withValues(alpha: 0.1);
      } else if (option.isCorrect) {
        border = AppColors.success;
        background = AppColors.success.withValues(alpha: 0.1);
        letterBorder = AppColors.success;
        letterColor = AppColors.success;
        letterBackground = AppColors.success.withValues(alpha: 0.1);
      } else {
        opacity = 0.5;
        letterBorder = AppColors.grey200;
        letterColor = AppColors.grey300;
      }
    }

    return Opacity(
      opacity: opacity,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: answered
              ? null
              : () => onAnswer(AnswerInputData(answerId: option.id)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border, width: 2),
            ),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: letterBackground,
                    border: Border.all(color: letterBorder, width: 2),
                  ),
                  child: Text(
                    index < _letters.length ? _letters[index] : '${index + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: letterColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HtmlText(
                    data: option.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.grey200,
          foregroundColor: Colors.white,
          disabledForegroundColor: AppColors.grey400,
          minimumSize: const Size.fromHeight(46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
        ),
      ),
    );
  }
}

class _FillBlank extends StatefulWidget {
  const _FillBlank({
    required this.question,
    required this.state,
    required this.onAnswer,
    super.key,
  });

  final QuestionModel question;
  final QuizState state;
  final ValueChanged<AnswerInputData> onAnswer;

  @override
  State<_FillBlank> createState() => _FillBlankState();
}

class _FillBlankState extends State<_FillBlank> {
  final _controller = TextEditingController();
  String _selectedWord = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> get _wordOptions =>
      ((widget.question.typeData?['word_options'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList();

  @override
  Widget build(BuildContext context) {
    final answered = widget.state.answered;
    if (_wordOptions.isEmpty) {
      return Column(
        children: [
          TextField(
            controller: _controller,
            enabled: !answered,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _submitText(),
            decoration: const InputDecoration(hintText: 'Cevabınızı yazın…'),
          ),
          const SizedBox(height: 12),
          if (!answered)
            _PrimaryButton(
              label: 'GÖNDER',
              onPressed: _controller.text.trim().isEmpty ? null : _submitText,
            ),
        ],
      );
    }

    // Word chip mode: blanks are "__" runs inside question_text.
    final blankColor = answered
        ? (widget.state.lastAnswerCorrect ? AppColors.success : AppColors.error)
        : (_selectedWord.isNotEmpty ? AppColors.primary : AppColors.grey300);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.grey800,
            ),
            children: [
              for (final part in _splitKeepingBlanks(widget.question.text))
                if (RegExp(r'^_+$').hasMatch(part))
                  WidgetSpan(
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 80),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: blankColor, width: 4),
                        ),
                      ),
                      child: Text(
                        _selectedWord.isEmpty ? '______' : _selectedWord,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: _selectedWord.isEmpty
                              ? AppColors.grey400
                              : blankColor,
                        ),
                      ),
                    ),
                  )
                else
                  TextSpan(text: part),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final word in _wordOptions)
              Opacity(
                opacity: _selectedWord.isNotEmpty && _selectedWord != word
                    ? 0.4
                    : 1,
                child: OutlinedButton(
                  onPressed: answered ||
                          (_selectedWord.isNotEmpty && _selectedWord != word)
                      ? null
                      : () => setState(
                            () => _selectedWord =
                                _selectedWord == word ? '' : word,
                          ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    side: BorderSide(
                      color: _selectedWord == word
                          ? AppColors.primary
                          : AppColors.grey200,
                      width: 2,
                    ),
                    backgroundColor: _selectedWord == word
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : null,
                    foregroundColor: _selectedWord == word
                        ? AppColors.primary
                        : AppColors.grey800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    word,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (!answered)
          _PrimaryButton(
            label: 'KONTROL ET',
            onPressed: _selectedWord.isEmpty
                ? null
                : () => widget.onAnswer(
                      AnswerInputData(textAnswer: _selectedWord),
                    ),
          ),
      ],
    );
  }

  List<String> _splitKeepingBlanks(String text) {
    final result = <String>[];
    var last = 0;
    for (final m in RegExp('_{2,}').allMatches(text)) {
      if (m.start > last) result.add(text.substring(last, m.start));
      result.add(m.group(0)!);
      last = m.end;
    }
    if (last < text.length) result.add(text.substring(last));
    return result;
  }

  void _submitText() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onAnswer(AnswerInputData(textAnswer: text));
  }
}

class _Flashcard extends StatefulWidget {
  const _Flashcard({
    required this.question,
    required this.state,
    required this.onAnswer,
    super.key,
  });

  final QuestionModel question;
  final QuizState state;
  final ValueChanged<AnswerInputData> onAnswer;

  @override
  State<_Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<_Flashcard> {
  bool _flipped = false;

  @override
  Widget build(BuildContext context) {
    final back = widget.question.explanation ??
        widget.question.typeData?['back'] as String? ??
        'Açıklama yok';
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _flipped = !_flipped),
          child: Container(
            width: double.infinity,
            height: 220,
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _flipped
                  ? AppColors.primary.withValues(alpha: 0.05)
                  : AppColors.grey50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _flipped ? AppColors.primary : AppColors.grey200,
                width: 2,
              ),
            ),
            child: _flipped
                ? HtmlText(
                    data: back,
                    isExplanation: true,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  )
                : const Text(
                    'Kartı çevirmek için tıkla',
                    style: TextStyle(
                      color: AppColors.grey400,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        if (!widget.state.answered)
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => widget.onAnswer(
                    const AnswerInputData(flashcardKnown: false),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error, width: 2),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text(
                    '✗ Bilmiyorum',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => widget.onAnswer(
                    const AnswerInputData(flashcardKnown: true),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text(
                    '✓ Biliyorum',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _Matching extends StatefulWidget {
  const _Matching({
    required this.question,
    required this.state,
    required this.onAnswer,
    super.key,
  });

  final QuestionModel question;
  final QuizState state;
  final ValueChanged<AnswerInputData> onAnswer;

  @override
  State<_Matching> createState() => _MatchingState();
}

class _MatchingState extends State<_Matching> {
  late final List<({String left, String right})> _pairs;
  late final List<({String right, int originalIndex})> _shuffledRight;
  int _selectedLeft = -1;
  int _selectedRight = -1;
  final Set<int> _matchedLeft = {};
  final Set<int> _matchedRight = {};
  int _wrongLeft = -1;
  int _wrongRight = -1;
  final List<MatchingAnswerPair> _userPairs = [];

  @override
  void initState() {
    super.initState();
    _pairs = ((widget.question.typeData?['pairs'] as List?) ?? const [])
        .map((p) {
      final m = p as Map<String, dynamic>;
      return (left: m['left'].toString(), right: m['right'].toString());
    }).toList();
    _shuffledRight = [
      for (final (i, p) in _pairs.indexed) (right: p.right, originalIndex: i),
    ]..shuffle(Random());
  }

  void _tryMatch() {
    if (_selectedLeft == -1 || _selectedRight == -1) return;
    final left = _selectedLeft;
    final right = _selectedRight;
    if (left == _shuffledRight[right].originalIndex) {
      _matchedLeft.add(left);
      _matchedRight.add(right);
      _userPairs.add(MatchingAnswerPair(leftIndex: left, rightIndex: left));
    } else {
      _wrongLeft = left;
      _wrongRight = right;
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _wrongLeft = -1;
            _wrongRight = -1;
          });
        }
      });
    }
    _selectedLeft = -1;
    _selectedRight = -1;
  }

  Widget _cell({
    required String text,
    required bool selected,
    required bool matched,
    required bool wrong,
    required VoidCallback? onTap,
  }) {
    final color = matched
        ? AppColors.success
        : wrong
            ? AppColors.error
            : selected
                ? AppColors.primary
                : null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          backgroundColor: color?.withValues(alpha: 0.1),
          foregroundColor: color ?? AppColors.grey800,
          disabledForegroundColor: color ?? AppColors.grey800,
          side: BorderSide(color: color ?? AppColors.grey200, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final answered = widget.state.answered;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  for (final (i, p) in _pairs.indexed)
                    _cell(
                      text: p.left,
                      selected: _selectedLeft == i,
                      matched: _matchedLeft.contains(i),
                      wrong: _wrongLeft == i,
                      onTap: answered || _matchedLeft.contains(i)
                          ? null
                          : () => setState(() {
                                _wrongLeft = _wrongRight = -1;
                                _selectedLeft = i;
                                _tryMatch();
                              }),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  for (final (i, p) in _shuffledRight.indexed)
                    _cell(
                      text: p.right,
                      selected: _selectedRight == i,
                      matched: _matchedRight.contains(i),
                      wrong: _wrongRight == i,
                      onTap: answered || _matchedRight.contains(i)
                          ? null
                          : () => setState(() {
                                _wrongLeft = _wrongRight = -1;
                                _selectedRight = i;
                                _tryMatch();
                              }),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (!answered && _matchedLeft.length == _pairs.length) ...[
          const SizedBox(height: 8),
          _PrimaryButton(
            label: 'ONAYLA',
            onPressed: () => widget.onAnswer(
              AnswerInputData(matchingAnswer: List.of(_userPairs)),
            ),
          ),
        ],
      ],
    );
  }
}

class _Ordering extends StatefulWidget {
  const _Ordering({
    required this.question,
    required this.state,
    required this.onAnswer,
    super.key,
  });

  final QuestionModel question;
  final QuizState state;
  final ValueChanged<AnswerInputData> onAnswer;

  @override
  State<_Ordering> createState() => _OrderingState();
}

class _OrderingState extends State<_Ordering> {
  late List<({String text, int originalIndex})> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      for (final (i, it)
          in ((widget.question.typeData?['items'] as List?) ?? const [])
              .indexed)
        (
          text: (it as Map<String, dynamic>)['text'].toString(),
          originalIndex: i,
        ),
    ]..shuffle(Random());
  }

  void _move(int index, int direction) {
    final target = index + direction;
    if (target < 0 || target >= _items.length) return;
    setState(() {
      final tmp = _items[index];
      _items[index] = _items[target];
      _items[target] = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final answered = widget.state.answered;
    return Column(
      children: [
        for (final (i, item) in _items.indexed)
          Opacity(
            opacity: answered ? 0.6 : 1,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey200, width: 2),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.text,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  if (!answered)
                    Column(
                      children: [
                        InkWell(
                          onTap: i == 0 ? null : () => _move(i, -1),
                          child: const Text('▲'),
                        ),
                        InkWell(
                          onTap: i == _items.length - 1
                              ? null
                              : () => _move(i, 1),
                          child: const Text('▼'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        if (!answered)
          _PrimaryButton(
            label: 'ONAYLA',
            onPressed: () => widget.onAnswer(
              AnswerInputData(
                orderedIndices: _items.map((e) => e.originalIndex).toList(),
              ),
            ),
          ),
      ],
    );
  }
}

class _Swipe extends StatefulWidget {
  const _Swipe({
    required this.question,
    required this.state,
    required this.onAnswer,
    super.key,
  });

  final QuestionModel question;
  final QuizState state;
  final ValueChanged<AnswerInputData> onAnswer;

  @override
  State<_Swipe> createState() => _SwipeState();
}

class _SwipeState extends State<_Swipe> {
  static const _threshold = 100.0;
  double _dragX = 0;
  bool _exiting = false;

  void _answer(bool isTrue) {
    final options = widget.question.options;
    final target = isTrue ? 'Doğru' : 'Yanlış';
    AnswerOption? answer;
    for (final o in options) {
      if (o.text == target) answer = o;
    }
    final fallback = isTrue ? 0 : 1;
    answer ??= options.length > fallback ? options[fallback] : null;
    if (answer != null) widget.onAnswer(AnswerInputData(answerId: answer.id));
  }

  @override
  Widget build(BuildContext context) {
    final answered = widget.state.answered;
    final width = MediaQuery.sizeOf(context).width;
    final dx = _exiting ? (_dragX.sign * width * 1.2) : _dragX;
    return Column(
      children: [
        GestureDetector(
          onHorizontalDragUpdate: answered || _exiting
              ? null
              : (d) => setState(() => _dragX += d.delta.dx),
          onHorizontalDragEnd: answered || _exiting
              ? null
              : (_) {
                  if (_dragX.abs() >= _threshold) {
                    setState(() => _exiting = true);
                    _answer(_dragX > 0);
                  } else {
                    setState(() => _dragX = 0);
                  }
                },
          child: AnimatedContainer(
            duration: Duration(milliseconds: _exiting ? 400 : 0),
            transform: Matrix4.identity()
              ..translateByDouble(dx, 0, 0, 1)
              ..rotateZ(dx * 0.001),
            child: Opacity(
              opacity: _exiting ? 0 : 1,
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 200),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.grey200, width: 2),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Opacity(
                        opacity: (_dragX / _threshold).clamp(0, 1),
                        child: const Text(
                          'DOĞRU ✓',
                          style: TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Opacity(
                        opacity: (-_dragX / _threshold).clamp(0, 1),
                        child: const Text(
                          'YANLIŞ ✗',
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 28),
                      child: Center(
                        child: HtmlText(
                          data: widget.question.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (!answered)
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '← YANLIŞ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.grey400,
                  ),
                ),
                Text(
                  'DOĞRU →',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.grey400,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
