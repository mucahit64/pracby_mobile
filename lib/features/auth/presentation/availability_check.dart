import 'dart:async';

import 'package:flutter/foundation.dart';

enum Availability {
  /// Nothing to check yet (empty or invalid format).
  idle,
  checking,
  available,
  taken,

  /// The check failed (offline, rate limit): not known, so don't block —
  /// the server still rejects a taken value on register.
  unknown,
}

/// Live "is this email/username free?" check for the register form
/// (web register.vue, docs 3.4).
///
/// `/auth/check-*` shares the auth rate limit (10 requests/minute/IP) with
/// login and register, so a value is checked only once the user stops
/// typing, only if its format is valid, and only once (results are cached).
/// A response for a value the user has since changed is ignored.
class AvailabilityCheck extends ChangeNotifier {
  AvailabilityCheck(
    this._check, {
    this.debounce = const Duration(milliseconds: 600),
  });

  /// Returns true when the value is free.
  final Future<bool> Function(String value) _check;
  final Duration debounce;

  final _cache = <String, bool>{};
  Timer? _timer;
  String _value = '';
  Availability _status = Availability.idle;

  Availability get status => _status;

  /// Call on every edit with the trimmed value.
  void onChanged(String value, {required bool formatValid}) {
    _timer?.cancel();
    _value = value;
    if (!formatValid) return _set(Availability.idle);
    final cached = _cache[value];
    if (cached != null) return _set(_fromResult(cached));
    _set(Availability.idle);
    _timer = Timer(debounce, () => unawaited(_run(value)));
  }

  /// Checks [value] now unless already known; used before submitting.
  Future<Availability> ensure(String value) async {
    _timer?.cancel();
    _value = value;
    final cached = _cache[value];
    if (cached != null) {
      _set(_fromResult(cached));
    } else {
      await _run(value);
    }
    return _status;
  }

  Future<void> _run(String value) async {
    _set(Availability.checking);
    Availability result;
    try {
      final free = await _check(value);
      _cache[value] = free;
      result = _fromResult(free);
    } catch (_) {
      result = Availability.unknown;
    }
    // The user kept typing: this answer is for an old value.
    if (value == _value) _set(result);
  }

  Availability _fromResult(bool free) =>
      free ? Availability.available : Availability.taken;

  void _set(Availability status) {
    if (_status == status) return;
    _status = status;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
