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
