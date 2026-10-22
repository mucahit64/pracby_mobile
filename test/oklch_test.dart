import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pracby_mobile/core/utils/oklch.dart';

int _channel(double c) => (c * 255).round();

void main() {
  // Chrome's result for CSS `oklch(from <colour> calc(l + 0.06) c h)`, the
  // web's map button rim.
  const cases = {
    0xFF3B82F6: 0xFF4E95FF,
    0xFF10B981: 0xFF37CD93,
    0xFFF59E0B: 0xFFFFB133,
    0xFFFFC800: 0xFFFFDC36,
    0xFFE5E7EB: 0xFFF9FBFF,
    0xFFFF4B4B: 0xFFFF615D,
  };

  for (final MapEntry(key: from, value: web) in cases.entries) {
    test('lightens ${from.toRadixString(16)} like the web', () {
      final got = lightenOklch(Color(from), 0.06);
      final want = Color(web);
      expect(_channel(got.r), closeTo(_channel(want.r), 2));
      expect(_channel(got.g), closeTo(_channel(want.g), 2));
      expect(_channel(got.b), closeTo(_channel(want.b), 2));
    });
  }
}
