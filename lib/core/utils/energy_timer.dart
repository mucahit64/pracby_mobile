import 'dart:async';

class EnergyTimer {
  EnergyTimer({
    required this.maxEnergy,
    required this.refillInterval,
  });

  final int maxEnergy;
  final Duration refillInterval; // typically 6 hours per energy

  Timer? _timer;
  DateTime? _nextEnergyAt;
  void Function(Duration remaining)? onTick;
  void Function()? onEnergyGained;

  Duration? get remainingTime {
    if (_nextEnergyAt == null) return null;
    final diff = _nextEnergyAt!.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  void start({required DateTime nextEnergyAt}) {
    _nextEnergyAt = nextEnergyAt;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = remainingTime;
      if (remaining == null) return;
      if (remaining == Duration.zero) {
        onEnergyGained?.call();
        _timer?.cancel();
      } else {
        onTick?.call(remaining);
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    stop();
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${hours}sa ${minutes}dk';
    }
    return '${minutes}dk ${seconds}sn';
  }
}
