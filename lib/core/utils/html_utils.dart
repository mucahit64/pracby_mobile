/// HTML helpers that mirror the web client's `composables/useSanitizedHtml.ts`
/// and the question layout rules in MOBILE_APP_DOCS.md section 8.
abstract final class HtmlUtils {
  /// Tags the web client keeps (DOMPurify ALLOWED_TAGS). Other tags are
  /// dropped but their text content is kept.
  static const allowedTags = {
    'p', 'ul', 'ol', 'li', 'b', 'strong', 'i', 'em', 'u', 'br', 'sup', 'sub',
    'span', //
  };

  /// Marks where the question image sits inside `question_text` (docs 8.2).
  static const imageMarker = '<!--img-->';

  static final _dangerousBlock = RegExp(
    r'<(script|style|iframe|object|embed|template)\b[^>]*>[\s\S]*?</\1\s*>',
    caseSensitive: false,
  );
  static final _comment = RegExp(r'<!--[\s\S]*?-->');
  static final _tag = RegExp(r'<\s*(/?)\s*([a-zA-Z0-9]+)([^>]*)>');
  static final _styleAttr = RegExp(
    r'''\sstyle\s*=\s*("[^"]*"|'[^']*')''',
    caseSensitive: false,
  );

  /// Keeps only [allowedTags]; attributes other than `style` are removed.
  static String sanitize(String? html) {
    if (html == null || html.isEmpty) return '';
    final cleaned =
        html.replaceAll(_dangerousBlock, '').replaceAll(_comment, '');
    return cleaned.replaceAllMapped(_tag, (m) {
      final closing = m.group(1)!;
      final name = m.group(2)!.toLowerCase();
      if (!allowedTags.contains(name)) return '';
      if (closing.isNotEmpty) return '</$name>';
      final style = _styleAttr.firstMatch(m.group(3)!)?.group(0) ?? '';
      return '<$name$style>';
    });
  }

  /// Explanations are plain text that may contain `<sup>`/`<sub>` and bare
  /// comparisons such as `a < b` (docs 8.4, web `formatExplanation`).
  static String formatExplanation(String? text) {
    if (text == null || text.isEmpty) return '';
    final escaped = text
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAllMapped(
          RegExp('&lt;(/?)(sup|sub)&gt;'),
          (m) => '<${m.group(1)}${m.group(2)}>',
        );
    return sanitize(escaped);
  }

  /// Splits `question_text` at the first [imageMarker]. Without a marker the
  /// image goes above the whole text. Must run before [sanitize], which
  /// strips comments.
  static ({String before, String after}) splitAtImage(String text) {
    final index = text.indexOf(imageMarker);
    if (index == -1) return (before: '', after: text);
    return (
      before: text.substring(0, index),
      after: text.substring(index + imageMarker.length),
    );
  }
}
