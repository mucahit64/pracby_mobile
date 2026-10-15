import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Quiz sessions whose `finish-bulk` request failed, keyed by session ID.
/// Web equivalent: localStorage `pb_pending_quiz`.
const _pendingQuizBox = 'pending_quiz';

/// Guest-mode state (docs 10.3). Web equivalent: localStorage `guestState`
/// and `guestId`.
const _guestBox = 'guest';

/// Small UI preferences, e.g. the selected module / course on the lesson map
/// (web: localStorage `pb_selectedModuleId`, `pb_selectedCourseId`).
const _prefsBox = 'prefs';

final hiveStorageProvider = Provider<HiveStorage>((ref) {
  throw UnimplementedError('Override hiveStorageProvider in main().');
});

class HiveStorage {
  Box<String>? _pendingQuiz;
  Box<String>? _guest;
  Box<String>? _prefs;

  Future<void> init() async {
    await Hive.initFlutter();
    _pendingQuiz = await Hive.openBox<String>(_pendingQuizBox);
    _guest = await Hive.openBox<String>(_guestBox);
    _prefs = await Hive.openBox<String>(_prefsBox);
  }

  Box<String> get prefsBox {
    assert(_prefs != null, 'HiveStorage not initialized.');
    return _prefs!;
  }

  Box<String> get guestBox {
    assert(_guest != null, 'HiveStorage not initialized.');
    return _guest!;
  }

  Box<String> get pendingQuizBox {
    assert(_pendingQuiz != null, 'HiveStorage not initialized.');
    return _pendingQuiz!;
  }
}
