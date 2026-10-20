import 'package:flutter_test/flutter_test.dart';
import 'package:pracby_mobile/features/leaderboard/data/models/leaderboard_entry.dart';

void main() {
  test('parses the GET /api/leaderboard row shape, rank can be null', () {
    // Exactly the columns the backend selects (leaderboard.service.ts).
    final entry = LeaderboardEntry.fromJson({
      'username': 'ayse',
      'avatar_url': null,
      'xp_earned': 42,
      'rank': null,
    });
    expect(entry.username, 'ayse');
    expect(entry.xpEarned, 42);
    expect(entry.rank, isNull);
    expect(entry.avatarUrl, isNull);
  });
}
