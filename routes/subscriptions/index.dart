import 'package:blog_newsletter_client/blog_newsletter_client.dart';
import 'package:dart_frog/dart_frog.dart';

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
  //TODO: should this be in a repo?
  final formData = await context.request.formData();
  final email = formData.fields['email'];

  if (email == null) {
    return Response(
      statusCode: 400,
      body: '<p>Invalid email</p>',
    );
  }

  final result = await context
      .read<BlogNewsletterClient>()
      .removeSubscriber(encodedSubscriberEmail: email);

  return Response(
    statusCode: result.statusCode,
    body: result.body,
    headers: {'content-type': 'text/html'},
  );
}
