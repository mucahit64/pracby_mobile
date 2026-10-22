import 'dart:math';

import 'package:flutter/painting.dart';

/// [color] made [amount] lighter in OKLCH (0…1), keeping its hue and chroma:
/// the same step looks equally lighter on every colour, unlike mixing in
/// white. The web does the same with CSS `oklch(from c calc(l + x) c h)`.
/// Out-of-gamut results are clipped to sRGB.
Color lightenOklch(Color color, double amount) {
  final (l, a, b) = _toOklab(color);
  return _fromOklab((l + amount).clamp(0, 1), a, b, color.a);
}

double _toLinear(double c) =>
    c <= 0.04045 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4).toDouble();

double _toGamma(double c) =>
    c <= 0.0031308 ? 12.92 * c : 1.055 * pow(c, 1 / 2.4) - 0.055;

double _cbrt(double x) =>
    x < 0 ? -pow(-x, 1 / 3).toDouble() : pow(x, 1 / 3).toDouble();

// OKLab (Björn Ottosson): linear sRGB → LMS → cube root → Lab, and back.
(double, double, double) _toOklab(Color c) {
  final r = _toLinear(c.r);
  final g = _toLinear(c.g);
  final b = _toLinear(c.b);
  final l = _cbrt(0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b);
  final m = _cbrt(0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b);
  final s = _cbrt(0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b);
  return (
    0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s,
    1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s,
    0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s,
  );
}

Color _fromOklab(double lightness, double a, double b, double alpha) {
  final l = pow(lightness + 0.3963377774 * a + 0.2158037573 * b, 3).toDouble();
  final m = pow(lightness - 0.1055613458 * a - 0.0638541728 * b, 3).toDouble();
  final s = pow(lightness - 0.0894841775 * a - 1.2914855480 * b, 3).toDouble();
  double channel(double v) => _toGamma(v).clamp(0.0, 1.0);
  return Color.from(
    alpha: alpha,
    red: channel(4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s),
    green: channel(-1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s),
    blue: channel(-0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s),
  );
}
