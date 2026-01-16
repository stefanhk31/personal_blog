import 'package:dart_frog/dart_frog.dart';

/// Returns a 400 Bad Request response with the given message.
Response badRequestMessage(String message) {
  return Response(
    statusCode: 400,
    body: '<p class="text-red-600 dark:text-red-300">$message</p>',
    headers: {'content-type': 'text/html'},
  );
}
