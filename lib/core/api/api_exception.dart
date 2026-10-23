class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.message,
    this.fieldErrors = const {},
  });

  /// HTTP status code. 0 means the request never reached the server.
  final int statusCode;

  /// Human readable message: backend `error`, first Zod field error,
  /// or a Turkish fallback for network failures.
  final String message;

  /// Zod validation errors keyed by field (`errors.properties.<field>`).
  final Map<String, List<String>> fieldErrors;

  bool get isNetworkError => statusCode == 0;

  @override
  String toString() => message;
}

/// What to show the user for [error]: the Turkish network message when the
/// request never reached the server, otherwise [fallback]. The API's own
/// messages are mostly English, so they aren't shown as they are.
String userErrorMessage(Object error, String fallback) =>
    error is ApiException && error.isNetworkError ? error.message : fallback;
