/// User-facing error message to display for HTTP failures.
/// Displays the [statusCode] and [body] of the HTTP request.
String httpErrorMessage(int statusCode, String body) {
  return 'Http call failed: \n '
      'Status Code: $statusCode \n '
      'Body: $body';
}
