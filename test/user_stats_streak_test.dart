import 'package:flutter_test/flutter_test.dart';
import 'package:pracby_mobile/features/profile/data/models/user_stats.dart';

void main() {
  group('UserStats.utcDay (last_active_date from the API)', () {
    test('UTC server: midnight UTC is that day', () {
      expect(
        UserStats.utcDay('2026-10-15T00:00:00.000Z'),
        DateTime.utc(2026, 10, 15),
      );
    });

    test('UTC+3 server: 21:00Z the day before is the stored day', () {
      expect(
        UserStats.utcDay('2026-10-14T21:00:00.000Z'),
        DateTime.utc(2026, 10, 15),
      );
    });

    test('plain YYYY-MM-DD', () {
      expect(UserStats.utcDay('2026-10-15'), DateTime.utc(2026, 10, 15));
    });

    test('null or invalid', () {
      expect(UserStats.utcDay(null), isNull);
      expect(UserStats.utcDay('nope'), isNull);
    });
  });

  group('UserStats.displayStreak (docs 16.4)', () {
    String day(int daysAgo) {
      final now = DateTime.now().toUtc();
      final d = DateTime.utc(now.year, now.month, now.day - daysAgo);
      return '${d.toIso8601String().split('T').first}T00:00:00.000Z';
    }

    UserStats stats(String? last) =>
        UserStats(currentStreak: 5, lastActiveDate: last);

    test('active today or yesterday keeps the streak', () {
      expect(stats(day(0)).displayStreak, 5);
      expect(stats(day(1)).displayStreak, 5);
    });

    test('last active before yesterday shows 0', () {
      expect(stats(day(2)).displayStreak, 0);
      expect(stats(day(30)).displayStreak, 0);
    });

    test('never active shows 0', () {
      expect(stats(null).displayStreak, 0);
    });
  });
}
