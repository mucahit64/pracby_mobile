import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:pracby_mobile/features/auth/presentation/availability_check.dart';

void main() {
  late List<String> calls;
  late Map<String, Completer<bool>> pending;
  late AvailabilityCheck check;

  setUp(() {
    calls = [];
    pending = {};
    check = AvailabilityCheck(
      (value) {
        calls.add(value);
        return (pending[value] = Completer<bool>()).future;
      },
      debounce: const Duration(milliseconds: 20),
    );
  });

  tearDown(() => check.dispose());

  Future<void> afterDebounce() =>
      Future<void>.delayed(const Duration(milliseconds: 40));

  test('checks only after typing stops, once per value', () async {
    check
      ..onChanged('ali', formatValid: true)
      ..onChanged('alic', formatValid: true)
      ..onChanged('alice', formatValid: true);
    await afterDebounce();
    expect(calls, ['alice']);
    expect(check.status, Availability.checking);

    pending['alice']!.complete(false);
    await Future<void>.delayed(Duration.zero);
    expect(check.status, Availability.taken);

    // Back to the same value: answered from the cache. "alic" was only
    // passed through, so it is never requested either.
    check
      ..onChanged('alic', formatValid: true)
      ..onChanged('alice', formatValid: true);
    expect(check.status, Availability.taken);
    await afterDebounce();
    expect(calls, ['alice']);
  });

  test('does not check an invalid format', () async {
    check.onChanged('a', formatValid: false);
    await afterDebounce();
    expect(calls, isEmpty);
    expect(check.status, Availability.idle);
  });

  test('ignores an answer for a value the user has changed', () async {
    check.onChanged('bob', formatValid: true);
    await afterDebounce();
    check.onChanged('bobby', formatValid: true);
    pending['bob']!.complete(false); // "taken", but for the old value
    await Future<void>.delayed(Duration.zero);
    expect(check.status, isNot(Availability.taken));
  });

  test('a failed check (offline, 429) is unknown, not taken', () async {
    check.onChanged('carol', formatValid: true);
    await afterDebounce();
    pending['carol']!.completeError(Exception('429'));
    await Future<void>.delayed(Duration.zero);
    expect(check.status, Availability.unknown);
  });

  test('ensure() checks right away before submitting', () async {
    final result = check.ensure('dave');
    expect(calls, ['dave']);
    pending['dave']!.complete(true);
    expect(await result, Availability.available);
  });
}
