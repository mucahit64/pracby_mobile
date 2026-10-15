import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pracby_mobile/core/api/api_exception.dart';
import 'package:pracby_mobile/core/storage/secure_storage.dart';

String get _apiBaseUrl {
  const envUrl = String.fromEnvironment('API_BASE_URL');
  if (envUrl.isNotEmpty) return envUrl;
  if (kIsWeb) return 'http://127.0.0.1:3001';
  if (Platform.isAndroid) return 'http://10.0.2.2:3001';
  return 'http://127.0.0.1:3001';
}

/// Question images are served by the web (Nuxt) server, not the API.
/// See MOBILE_APP_DOCS.md 8.3.
String get webBaseUrl {
  const envUrl = String.fromEnvironment('WEB_BASE_URL');
  if (envUrl.isNotEmpty) return envUrl;
  if (kIsWeb) return 'http://127.0.0.1:3000';
  if (Platform.isAndroid) return 'http://10.0.2.2:3000';
  return 'http://127.0.0.1:3000';
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final client = ApiClient(secureStorage: secureStorage);
  ref.onDispose(client.dispose);
  return client;
});

class ApiClient {
  ApiClient({required SecureStorage secureStorage})
      : _secureStorage = secureStorage {
    _dio = Dio(
      BaseOptions(
        baseUrl: _apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    _dio.interceptors.add(_authInterceptor());
  }

  late final Dio _dio;
  final SecureStorage _secureStorage;
  final _unauthorizedController = StreamController<void>.broadcast();

  Dio get dio => _dio;

  /// Fires when an authenticated request is rejected with 401 and the stored
  /// token has been deleted. The auth layer listens and ends the session.
  Stream<void> get onUnauthorized => _unauthorizedController.stream;

  void dispose() => _unauthorizedController.close();

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        final sentToken =
            error.requestOptions.headers.containsKey('Authorization');
        if (error.response?.statusCode == 401 && sentToken) {
          await _secureStorage.deleteToken();
          _unauthorizedController.add(null);
        }
        handler.next(error);
      },
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
  }) async {
    try {
      return await _dio.post<T>(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
  }) async {
    try {
      return await _dio.patch<T>(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> delete<T>(String path) async {
    try {
      return await _dio.delete<T>(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Parses the two backend error formats (MOBILE_APP_DOCS.md 18):
  /// `{ "error": "..." }` and Zod's `{ "errors": { "errors": [],
  /// "properties": { "<field>": { "errors": [] } } } }`.
  ApiException _handleError(DioException e) {
    final response = e.response;
    if (response == null) {
      return const ApiException(
        statusCode: 0,
        message: 'Sunucuya bağlanılamadı. İnternet bağlantını kontrol et.',
      );
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;
    final fieldErrors = <String, List<String>>{};
    String? message;

    if (data is Map<String, dynamic>) {
      message = data['error'] as String?;
      final errors = data['errors'];
      if (errors is Map<String, dynamic>) {
        final formErrors = (errors['errors'] as List?)?.cast<String>() ?? [];
        final properties = errors['properties'];
        if (properties is Map<String, dynamic>) {
          for (final entry in properties.entries) {
            final list = (entry.value as Map?)?['errors'] as List?;
            if (list != null && list.isNotEmpty) {
              fieldErrors[entry.key] = list.cast<String>();
            }
          }
        }
        message ??= formErrors.isNotEmpty
            ? formErrors.first
            : fieldErrors.values.firstOrNull?.first;
      }
    }

    message ??= switch (statusCode) {
      429 => 'Çok fazla istek gönderildi, biraz sonra tekrar dene.',
      >= 500 => 'Sunucuda bir hata oluştu. Lütfen tekrar dene.',
      _ => 'Bir hata oluştu.',
    };

    return ApiException(
      statusCode: statusCode,
      message: message,
      fieldErrors: fieldErrors,
    );
  }
}
