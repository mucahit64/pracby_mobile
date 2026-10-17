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

  test('never caches quiz questions: a quiz only starts online', () async {
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
}
