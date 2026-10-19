import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pracby_mobile/core/utils/level_progress.dart';
import 'package:pracby_mobile/core/widgets/countdown.dart';
import 'package:pracby_mobile/features/profile/data/models/streak_day.dart';

void main() {
  group('LevelProgress (web: total_xp / 500 + 1)', () {
    test('starts at level 1', () {
      final p = LevelProgress.fromTotalXp(0);
      expect(p.level, 1);
      expect(p.xpInLevel, 0);
    });

    test('every 500 XP is a level', () {
      final p = LevelProgress.fromTotalXp(1234);
      expect(p.level, 3);
      expect(p.xpInLevel, 234);
      expect(p.fraction, closeTo(0.468, 1e-9));
      expect(LevelProgress.fromTotalXp(500).level, 2);
    });
  });

  test('StreakDay reads the API shape', () {
    final day = StreakDay.fromJson({
      'label': 'Pzt',
      'date': '2026-10-19',
      'done': true,
      'isToday': true,
    });
    expect(day.label, 'Pzt');
    expect(day.done, isTrue);
    expect(day.isToday, isTrue);
  });

  test('Countdown.format is m:ss', () {
    expect(Countdown.format(const Duration(minutes: 9, seconds: 5)), '9:05');
    expect(Countdown.format(const Duration(seconds: 42)), '0:42');
  });

  testWidgets('Countdown ticks and calls onDone once', (tester) async {
    var done = 0;
    Duration? shown;
    await tester.pumpWidget(
      Countdown(
        target: DateTime.now().add(const Duration(seconds: 2)),
        onDone: () => done++,
        builder: (_, remaining) {
          shown = remaining;
          return const SizedBox();
        },
      ),
    );
    expect(shown, isNotNull);

    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 2200)),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(shown, isNull);
    expect(done, 1);

    await tester.pump(const Duration(seconds: 3));
    expect(done, 1);
  });
}
