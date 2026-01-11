/// {@template request_failed_exception}
/// Exception thrown when a request fails to decode a json body.
/// {@endtemplate}
class JsonDecodeException implements Exception {
  /// {@macro request_failed_exception}
  const JsonDecodeException({required this.message});

  /// Message describing the error.
  final String message;

  @override
  String toString() => 'JsonDecodeException: $message';
}
