import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pracby_mobile/core/utils/html_utils.dart';
import 'package:pracby_mobile/features/quiz/data/models/quiz_answer.dart';

void main() {
  group('QuizAnswer JSON (finish-bulk AnswerInput)', () {
    test('omits null fields, which the backend Zod schema rejects', () {
      final json = const QuizAnswer(
        questionId: 'q1',
        answeredAt: '2026-10-15T19:30:12.123456Z',
        answerId: 'a1',
      ).toJson();

      expect(json.containsKey('textAnswer'), isFalse);
      expect(json.containsKey('matchingAnswer'), isFalse);
      expect(json.containsKey('orderedIndices'), isFalse);
      expect(json.containsKey('isCorrect'), isFalse);
      expect(json.containsKey('timeSpent'), isFalse);
      expect(json.values, isNot(contains(null)));
    });

    test('serializes matching pairs as plain maps', () {
      final json = const QuizAnswer(
        questionId: 'q1',
        answeredAt: '2026-10-15T19:30:12Z',
        matchingAnswer: [MatchingAnswerPair(leftIndex: 0, rightIndex: 0)],
      ).toJson();

      expect(jsonDecode(jsonEncode(json))['matchingAnswer'], [
        {'leftIndex': 0, 'rightIndex': 0},
      ]);
    });

    test('UTC timestamps end with Z (Zod datetime requires it)', () {
      expect(DateTime.now().toUtc().toIso8601String(), endsWith('Z'));
    });
  });

  group('HtmlUtils (web useSanitizedHtml)', () {
    test('keeps allowed tags and drops others but keeps their text', () {
      expect(
        HtmlUtils.sanitize('<p>a <b>b</b> <div>c</div><script>x</script></p>'),
        '<p>a <b>b</b> c</p>',
      );
    });

    test('drops attributes except style', () {
      expect(
        HtmlUtils.sanitize(
          '<span class="x" style="color:red" onclick="y">t'
          '</span>',
        ),
        '<span style="color:red">t</span>',
      );
    });

    test('formatExplanation keeps sup/sub and escapes comparisons', () {
      expect(
        HtmlUtils.formatExplanation('x<sup>2</sup> &lt; y <b>z</b>'),
        'x<sup>2</sup> &lt; y &lt;b&gt;z&lt;/b&gt;',
      );
    });

    test('splitAtImage splits at the first marker', () {
      final parts = HtmlUtils.splitAtImage('<p>a</p><!--img--><p>b</p>');
      expect(parts.before, '<p>a</p>');
      expect(parts.after, '<p>b</p>');
    });

    test('splitAtImage without marker puts the image above the text', () {
      final parts = HtmlUtils.splitAtImage('<p>a</p>');
      expect(parts.before, '');
      expect(parts.after, '<p>a</p>');
    });
  });
}
