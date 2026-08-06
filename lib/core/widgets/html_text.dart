import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';

/// Renders an HTML string using [flutter_html].
///
/// Use [style] to override default font properties.
class HtmlText extends StatelessWidget {
  const HtmlText({
    required this.data,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign,
    super.key,
  });

  final String data;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: data,
      style: {
        'body': Style(
          fontSize: FontSize(fontSize),
          fontWeight: fontWeight,
          color: color ?? AppColors.grey900,
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          lineHeight: const LineHeight(1.5),
          textAlign: textAlign != null
              ? _toTextAlignEnum(textAlign!)
              : TextAlign.start,
        ),
        'p': Style(margin: Margins.zero, padding: HtmlPaddings.zero),
      },
    );
  }

  TextAlign _toTextAlignEnum(TextAlign align) => align;
}
