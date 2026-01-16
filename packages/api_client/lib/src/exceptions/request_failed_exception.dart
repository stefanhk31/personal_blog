/// {@template request_failed_exception}
/// Exception thrown when a request fails.
/// {@endtemplate}
class RequestFailedException implements Exception {
  /// {@macro request_failed_exception}
  RequestFailedException({
    required this.message,
    required this.statusCode,
  });

  /// Message describing the error.
  final String message;

  /// Status code of the response.
  final int statusCode;

  @override
  String toString() =>
      RequestFailedException.getErrorMessage(message, statusCode);

  /// Default error message with [message] and [statusCode].
  static String getErrorMessage(String message, int statusCode) {
    return 'Request Failed. status code: $statusCode; message: $message';
  }
}
