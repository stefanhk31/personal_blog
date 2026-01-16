import 'package:dart_frog/dart_frog.dart';
import 'package:subscriptions_repository/subscriptions_repository.dart';

import '../../utils/utils.dart';

/// Request handler for the `/subscriptions` route.
/// Supports POST requests.
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => await _post(context),
    _ => Response(statusCode: 405, body: 'Method Not Allowed'),
  };
}

Future<Response> _post(RequestContext context) async {
  final formData = await context.request.formData();
  final name = formData.fields['name'];
  final email = formData.fields['email'];

  final nameMissing = name == null || name.isEmpty;
  final emailMissing = email == null || email.isEmpty;

  if (nameMissing && emailMissing) {
    return badRequestMessage('Name and Email are required');
  } else if (nameMissing) {
    return badRequestMessage('Name is required');
  } else if (emailMissing) {
    return badRequestMessage('Email is required');
  }

  final response = await context
      .read<SubscriptionsRepository>()
      .getSubscribeHtml(email: email, name: name);

  return Response(
    statusCode: response.statusCode,
    body: response.html,
    headers: {'content-type': 'text/html'},
  );
}
