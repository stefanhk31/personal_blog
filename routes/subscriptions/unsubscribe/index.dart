import 'package:dart_frog/dart_frog.dart';
import 'package:subscriptions_repository/subscriptions_repository.dart';

/// Request handler for the `/subscriptions/unsubscribe` route.
/// Supports GET requests.
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => await _get(context),
    _ => Response(statusCode: 405, body: 'Method Not Allowed'),
  };
}

Future<Response> _get(RequestContext context) async {
  final email = context.request.uri.queryParameters['email'];

  if (email == null) {
    return Response(statusCode: 400, body: 'Email is required');
  }

  final response = await context
      .read<SubscriptionsRepository>()
      .unsubscribe(encodedEmail: email);

  return Response(
    statusCode: response.statusCode,
    body: response.html,
    headers: {'content-type': 'text/html'},
  );
}
