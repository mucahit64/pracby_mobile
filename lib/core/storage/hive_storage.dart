import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Legacy queue of unsent `finish-bulk` requests, keyed by session ID
/// (web: localStorage `pb_pending_quiz`). Migrated into [_offlineQueueBox].
const _pendingQuizBox = 'pending_quiz';

/// Actions done offline (quiz results, energy purchases, chest claims,
/// question reports), sent in order once online (docs 7.5.1).
const _offlineQueueBox = 'offline_queue';

/// Last successful responses of content GETs, served when offline.
const _responseCacheBox = 'response_cache';

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
  Box<String>? _offlineQueue;
  Box<String>? _responseCache;
  Box<String>? _guest;
  Box<String>? _prefs;

  /// [path] is for tests: plain Hive in that directory instead of the app's
  /// documents directory.
  Future<void> init({String? path}) async {
    if (path != null) {
      Hive.init(path);
    } else {
      await Hive.initFlutter();
    }
    _pendingQuiz = await Hive.openBox<String>(_pendingQuizBox);
    _offlineQueue = await Hive.openBox<String>(_offlineQueueBox);
    _responseCache = await Hive.openBox<String>(_responseCacheBox);
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

  Box<String> get offlineQueueBox {
    assert(_offlineQueue != null, 'HiveStorage not initialized.');
    return _offlineQueue!;
  }

  Box<String> get responseCacheBox {
    assert(_responseCache != null, 'HiveStorage not initialized.');
    return _responseCache!;
  }

  Box<String> get pendingQuizBox {
    assert(_pendingQuiz != null, 'HiveStorage not initialized.');
    return _pendingQuiz!;
  }
}
