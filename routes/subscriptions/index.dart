import 'package:dart_frog/dart_frog.dart';
import 'package:subscriptions_repository/subscriptions_repository.dart';

/// Request handler for the `/subscriptions` route.
/// Supports POST and DELETE requests.
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => await _post(context),
    HttpMethod.delete => await _delete(context),
    _ => Response(statusCode: 405, body: 'Method Not Allowed'),
  };
}

Future<Response> _post(RequestContext context) async {
  throw UnimplementedError(
    'POST has not yet been implemented for subscriptions',
  );
}

Future<Response> _delete(RequestContext context) async {
  final formData = await context.request.formData();
  final email = formData.fields['email'];

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
