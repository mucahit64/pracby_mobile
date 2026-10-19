import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pracby_mobile/core/api/api_client.dart';
import 'package:pracby_mobile/core/api/endpoints.dart';
import 'package:pracby_mobile/features/profile/data/user_repository.dart';

/// Records the PATCH body instead of sending it.
class _RecordingApiClient implements ApiClient {
  String? path;
  Object? body;

  @override
  Future<Response<T>> patch<T>(String path, {Object? data}) async {
    this.path = path;
    body = data;
    return Response<T>(requestOptions: RequestOptions(path: path));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _RecordingApiClient api;
  late UserRepository repo;

  setUp(() {
    api = _RecordingApiClient();
    repo = UserRepository(apiClient: api);
  });

  test('sends the camelCase fields the API accepts (docs 11.5)', () async {
    // The API silently drops unknown keys, so snake_case would make a
    // password change "succeed" without changing anything.
    await repo.updateProfile(
      email: 'yeni@mail.com',
      currentPassword: 'eski123',
      newPassword: 'yeni123',
      avatarUrl: 'https://example.com/a.png',
      dailyGoalXp: 50,
    );
    expect(api.path, Endpoints.me);
    expect(api.body, {
      'email': 'yeni@mail.com',
      'currentPassword': 'eski123',
      'newPassword': 'yeni123',
      'avatarUrl': 'https://example.com/a.png',
      'dailyGoalXp': '50', // a string enum in the API
    });
  });

  test('sends only the changed fields', () async {
    await repo.updateProfile(username: 'yeniad');
    expect(api.body, {'username': 'yeniad'});
  });
}
