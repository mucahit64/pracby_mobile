abstract final class XpUtils {
  /// XP thresholds per level. Level N requires xpForLevel(N) total XP.
  static int xpForLevel(int level) {
    if (level <= 1) return 0;
    // Formula: each level requires 100 * level XP from previous level
    return 100 * level;
  }

  /// Calculate current level from total XP.
  static int levelFromXp(int totalXp) {
    var level = 1;
    var accumulated = 0;
    while (true) {
      final required = xpForLevel(level + 1);
      if (accumulated + required > totalXp) break;
      accumulated += required;
      level++;
    }
    return level;
  }

  /// Progress (0.0 to 1.0) towards next level.
  static double progressToNextLevel(int totalXp) {
    final currentLevel = levelFromXp(totalXp);
    var accumulated = 0;
    for (var i = 2; i <= currentLevel; i++) {
      accumulated += xpForLevel(i);
    }
    final xpInCurrentLevel = totalXp - accumulated;
    final xpNeeded = xpForLevel(currentLevel + 1);
    if (xpNeeded == 0) return 1;
    return xpInCurrentLevel / xpNeeded;
  }

  /// XP remaining to reach next level.
  static int xpToNextLevel(int totalXp) {
    final currentLevel = levelFromXp(totalXp);
    var accumulated = 0;
    for (var i = 2; i <= currentLevel; i++) {
      accumulated += xpForLevel(i);
    }
    final xpInCurrentLevel = totalXp - accumulated;
    return xpForLevel(currentLevel + 1) - xpInCurrentLevel;
  }
}
