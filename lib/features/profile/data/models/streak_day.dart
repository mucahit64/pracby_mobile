/// One day of the current week (Mon–Sun) from
/// `GET /users/me/streak-history`.
class StreakDay {
  const StreakDay({
    required this.label,
    required this.date,
    required this.done,
    required this.isToday,
  });

  factory StreakDay.fromJson(Map<String, dynamic> json) => StreakDay(
    label: json['label'] as String,
    date: json['date'] as String,
    done: json['done'] as bool? ?? false,
    isToday: json['isToday'] as bool? ?? false,
  );

  /// Short Turkish day name ("Pzt" … "Paz").
  final String label;

  /// `YYYY-MM-DD`.
  final String date;

  /// At least one quiz finished that day.
  final bool done;
  final bool isToday;
}
