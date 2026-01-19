import 'package:blog_repository/blog_repository.dart';
import 'package:dart_frog/dart_frog.dart';

/// Request handler for the `/about` route.
/// Supports GET requests.
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => await _get(context),
    _ => Response(statusCode: 405, body: 'Method Not Allowed'),
  };
}

Future<Response> _get(RequestContext context) async {
  final response = await context.read<BlogRepository>().getAboutMeHtml();

  return Response(
    statusCode: response.statusCode,
    body: response.html,
    headers: {'content-type': 'text/html'},
  );
}
