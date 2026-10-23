import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/endpoints.dart';
import 'package:pracby_mobile/core/storage/hive_storage.dart';

final responseCacheProvider = Provider<ResponseCache>((ref) {
  return ResponseCache(ref.watch(hiveStorageProvider));
});

/// Keeps the last successful response of content GETs and serves it when
/// the request fails for lack of a connection or because the server is
/// briefly unavailable (docs 7.5.1). This keeps the
/// lesson map, energy packages, the logged-in user with their exams, stats
/// and streak week, and active effects available offline.
///
/// Quiz questions aren't cached here: the next lessons are downloaded as
/// quiz packages (`features/offline/quiz_packages.dart`).
class ResponseCache {
  ResponseCache(this._storage);

  final HiveStorage _storage;

  static const _cachedPrefixes = [
    Endpoints.examGroups,
    Endpoints.modules,
    Endpoints.courses, // lists, detail and /full lesson maps
    Endpoints.storeItems,
    Endpoints.storeEffects,
    Endpoints.myEnrollments,
    Endpoints.myStats,
    Endpoints.myStreakHistory,
  ];

  static bool _isCacheable(RequestOptions options) =>
      options.method == 'GET' &&
      (_key(options) == Endpoints.me ||
          _cachedPrefixes.any(_key(options).startsWith));

  /// Path and query, e.g. `/api/courses?module_id=…`.
  static String _key(RequestOptions options) {
    final uri = options.uri;
    return uri.hasQuery ? '${uri.path}?${uri.query}' : uri.path;
  }

  Interceptor get interceptor => InterceptorsWrapper(
    onResponse: (response, handler) {
      final options = response.requestOptions;
      if (_isCacheable(options) && response.data != null) {
        _storage.responseCacheBox.put(_key(options), jsonEncode(response.data));
      }
      handler.next(response);
    },
    onError: (error, handler) {
      final options = error.requestOptions;
      // No response (offline) or the server is temporarily unavailable
      // (e.g. 502/503/504 during a deploy): serve the last good copy.
      final status = error.response?.statusCode;
      final unavailable =
          error.response == null ||
          status == 502 ||
          status == 503 ||
          status == 504;
      final cached = unavailable && _isCacheable(options)
          ? _storage.responseCacheBox.get(_key(options))
          : null;
      if (cached == null) return handler.next(error);
      handler.resolve(
        Response<dynamic>(
          requestOptions: options,
          data: jsonDecode(cached),
          statusCode: 200,
          extra: {'fromCache': true},
        ),
      );
    },
  );

  /// Applies local balance changes to the cached `/users/me`, so they survive
  /// an app restart while offline.
  void patchUser({int? energy, int? acorns, String? activeExamId}) {
    final box = _storage.responseCacheBox;
    final raw = box.get(Endpoints.me);
    if (raw == null) return;
    final user = jsonDecode(raw) as Map<String, dynamic>;
    if (energy != null) user['energy'] = energy;
    if (acorns != null) user['acorn_balance'] = acorns;
    if (activeExamId != null) user['active_exam_type_id'] = activeExamId;
    box.put(Endpoints.me, jsonEncode(user));
  }

  /// Whether a response for [path] (path and query) is cached, e.g. a
  /// course's lesson map, so it can be opened offline.
  bool has(String path) => _storage.responseCacheBox.containsKey(path);

  /// Shows a rewarded quiz played today in the cached stats and streak week
  /// until the server's values arrive (an offline quiz, docs 7.5.1). Same
  /// rule as the server: played yesterday +1, today unchanged, else 1.
  void markPlayedToday() {
    final box = _storage.responseCacheBox;
    final now = DateTime.now().toUtc();
    String day(DateTime d) => d.toIso8601String().substring(0, 10);
    final today = day(now);
    final yesterday = day(now.subtract(const Duration(days: 1)));

    final rawStats = box.get(Endpoints.myStats);
    if (rawStats != null) {
      final stats = jsonDecode(rawStats) as Map<String, dynamic>;
      final last = _utcDay(stats['last_active_date'] as String?);
      if (last == null || last.compareTo(today) < 0) {
        final current = (stats['current_streak'] as num?)?.toInt() ?? 0;
        final streak = last == yesterday ? current + 1 : 1;
        final best = (stats['max_streak'] as num?)?.toInt() ?? 0;
        stats
          ..['current_streak'] = streak
          ..['max_streak'] = streak > best ? streak : best
          ..['last_active_date'] = today;
        box.put(Endpoints.myStats, jsonEncode(stats));
      }
    }

    final rawWeek = box.get(Endpoints.myStreakHistory);
    if (rawWeek != null) {
      final week = (jsonDecode(rawWeek) as List).cast<Map<String, dynamic>>();
      for (final d in week) {
        if (d['date'] == today) d['done'] = true;
      }
      box.put(Endpoints.myStreakHistory, jsonEncode(week));
    }
  }

  /// The UTC day of a `last_active_date`, sent as midnight in the server's
  /// time zone; +12h recovers the day for any zone within ±12h (UserStats).
  static String? _utcDay(String? value) {
    if (value == null) return null;
    if (!value.contains('T')) return value.substring(0, 10);
    final time = DateTime.tryParse(value);
    if (time == null) return null;
    return time
        .toUtc()
        .add(const Duration(hours: 12))
        .toIso8601String()
        .substring(0, 10);
  }

  /// Cached data belongs to one user (progress, balances): drop it when the
  /// account changes.
  Future<void> clear() => _storage.responseCacheBox.clear();
}
