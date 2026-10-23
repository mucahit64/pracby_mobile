import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pracby_mobile/core/api/endpoints.dart';
import 'package:pracby_mobile/core/api/response_cache.dart';
import 'package:pracby_mobile/core/storage/hive_storage.dart';

/// Answers with [body] while [online], otherwise fails like a dropped
/// connection.
class _Adapter implements HttpClientAdapter {
  bool online = true;
  Object body = const <String, dynamic>{};

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (!online) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      );
    }
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late Directory dir;
  late ResponseCache cache;
  late _Adapter adapter;
  late Dio dio;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('response_cache_test');
    final storage = HiveStorage();
    await storage.init(path: dir.path);
    cache = ResponseCache(storage);
    adapter = _Adapter();
    dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
      ..httpClientAdapter = adapter
      ..interceptors.add(cache.interceptor);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await Hive.close();
    await dir.delete(recursive: true);
  });

  test('serves the last lesson map when offline', () async {
    adapter.body = {'id': 'c1', 'topics': <Object>[]};
    await dio.get<dynamic>(Endpoints.courseFull('c1'));

    adapter.online = false;
    final res = await dio.get<dynamic>(Endpoints.courseFull('c1'));
    expect(res.data, {'id': 'c1', 'topics': <Object>[]});
    expect(res.extra['fromCache'], isTrue);
  });

  test('never caches quiz questions (they are kept as quiz packages)', () async {
    adapter.body = {'questions': <Object>[]};
    await dio.get<dynamic>('${Endpoints.quizGuestStart}?topicId=t1');

    adapter.online = false;
    expect(
      dio.get<dynamic>('${Endpoints.quizGuestStart}?topicId=t1'),
      throwsA(isA<DioException>()),
    );
  });

  test('offline balance changes are kept in the cached profile', () async {
    adapter.body = {'id': 'u1', 'energy': 3, 'acorn_balance': 100};
    await dio.get<dynamic>(Endpoints.me);

    cache.patchUser(energy: 8, acorns: 85);
    adapter.online = false;
    final res = await dio.get<dynamic>(Endpoints.me);
    expect(res.data, {'id': 'u1', 'energy': 8, 'acorn_balance': 85});
  });

  test("serves the user's exams offline, so the map opens", () async {
    adapter.body = [
      {'exam_type_id': 'e1'},
    ];
    await dio.get<dynamic>(Endpoints.myEnrollments);

    adapter.online = false;
    final res = await dio.get<dynamic>(Endpoints.myEnrollments);
    expect(res.data, [
      {'exam_type_id': 'e1'},
    ]);
  });

  test('a quiz played offline today shows in the cached streak', () async {
    final now = DateTime.now().toUtc();
    String day(DateTime d) => d.toIso8601String().substring(0, 10);
    final yesterday = day(now.subtract(const Duration(days: 1)));
    adapter.body = {
      'current_streak': 4,
      'max_streak': 4,
      'last_active_date': '${yesterday}T00:00:00.000Z',
    };
    await dio.get<dynamic>(Endpoints.myStats);
    adapter.body = [
      {'date': day(now), 'done': false, 'frozen': false, 'isToday': true},
    ];
    await dio.get<dynamic>(Endpoints.myStreakHistory);

    cache
      ..markPlayedToday()
      ..markPlayedToday(); // a second quiz the same day changes nothing
    adapter.online = false;
    final stats = (await dio.get<dynamic>(Endpoints.myStats)).data as Map;
    expect(stats['current_streak'], 5);
    expect(stats['max_streak'], 5);
    expect(stats['last_active_date'], day(now));
    final week = (await dio.get<dynamic>(Endpoints.myStreakHistory)).data as List;
    expect((week.single as Map)['done'], isTrue);
  });
}
