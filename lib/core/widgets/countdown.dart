import 'dart:async';

import 'package:flutter/widgets.dart';

/// Rebuilds every second with the time left until [target]. [builder] gets
/// null once the target has passed (or when there is none); [onDone] is
/// called once per target when it is reached.
class Countdown extends StatefulWidget {
  const Countdown({
    required this.target,
    required this.builder,
    this.onDone,
    super.key,
  });

  final DateTime? target;
  final Widget Function(BuildContext context, Duration? remaining) builder;
  final VoidCallback? onDone;

  /// "m:ss", like the web energy countdown.
  static String format(Duration d) {
    final secs = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${d.inMinutes}:$secs';
  }

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  Timer? _timer;
  DateTime? _doneFor;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(Countdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target) _sync();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Duration? get _remaining {
    final target = widget.target;
    if (target == null) return null;
    final left = target.difference(DateTime.now());
    return left > Duration.zero ? left : null;
  }

  void _sync() {
    _timer?.cancel();
    if (widget.target == null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    // Called from initState/didUpdateWidget: a build follows anyway.
    _tick(rebuild: false);
  }

  void _tick({bool rebuild = true}) {
    if (_remaining == null) {
      _timer?.cancel();
      // Once per target: a failed refresh (offline) must not loop.
      if (_doneFor != widget.target) {
        _doneFor = widget.target;
        // After the current build, as it may change providers.
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => widget.onDone?.call(),
        );
      }
    }
    if (rebuild && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _remaining);
}
