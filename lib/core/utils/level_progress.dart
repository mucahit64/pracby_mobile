import 'dart:math';

/// Level from total XP, computed like the web profile: the API's `level`
/// column is never updated (always 1), so every 500 XP is one level.
class LevelProgress {
  const LevelProgress._(this.level, this.xpInLevel);

  factory LevelProgress.fromTotalXp(int totalXp) {
    final xp = max(0, totalXp);
    return LevelProgress._(xp ~/ xpPerLevel + 1, xp % xpPerLevel);
  }

  static const xpPerLevel = 500;

  final int level;

  /// XP earned since the current level started (0..499).
  final int xpInLevel;

  double get fraction => xpInLevel / xpPerLevel;
}
