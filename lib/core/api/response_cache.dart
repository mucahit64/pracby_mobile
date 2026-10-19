import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/endpoints.dart';
import 'package:pracby_mobile/core/storage/hive_storage.dart';

final responseCacheProvider = Provider<ResponseCache>((ref) {
  return ResponseCache(ref.watch(hiveStorageProvider));
});

/// Keeps the last successful response of content GETs and serves it when
/// the request fails for lack of a connection (docs 7.5.1). This keeps the
/// lesson map, energy packages and the logged-in user available offline.
///
/// Quiz questions are deliberately not cached: a quiz only starts online.
class ResponseCache {
  ResponseCache(this._storage);

  final HiveStorage _storage;

  static const _cachedPrefixes = [
    Endpoints.examGroups,
    Endpoints.modules,
    Endpoints.courses, // lists, detail and /full lesson maps
    Endpoints.storeItems,
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
      final cached = error.response == null && _isCacheable(options)
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

  /// Cached data belongs to one user (progress, balances): drop it when the
  /// account changes.
  Future<void> clear() => _storage.responseCacheBox.clear();
}
