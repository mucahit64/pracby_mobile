import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/core/utils/html_utils.dart';

/// Renders question / answer HTML with the web client's tag whitelist
/// (MOBILE_APP_DOCS.md 8.1).
class HtmlText extends StatelessWidget {
  const HtmlText({
    required this.data,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign,
    this.isExplanation = false,
    super.key,
  });

  final String data;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;

  /// Explanations are plain text with only <sup>/<sub> (docs 8.4).
  final bool isExplanation;

  @override
  Widget build(BuildContext context) {
    final html = isExplanation
        ? HtmlUtils.formatExplanation(data)
        : HtmlUtils.sanitize(data);
    return Html(
      data: html,
      style: {
        'body': Style(
          fontSize: FontSize(fontSize),
          fontWeight: fontWeight,
          color: color ?? AppColors.grey800,
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          lineHeight: const LineHeight(1.35),
          textAlign: textAlign ?? TextAlign.start,
        ),
        'p': Style(margin: Margins.only(bottom: 6)),
        'ul': Style(
          margin: Margins.only(bottom: 6),
          padding: HtmlPaddings.only(left: 20),
        ),
        'ol': Style(
          margin: Margins.only(bottom: 6),
          padding: HtmlPaddings.only(left: 20),
        ),
        'li': Style(margin: Margins.only(bottom: 2)),
      },
    );
  }
}
