import 'package:dart_frog/dart_frog.dart';

/// Default request handler, redirects to `/blogs`.
/// Supports GET requests.
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => await _get(context),
    _ => Response(statusCode: 405, body: 'Method Not Allowed'),
  };
}

Future<Response> _get(RequestContext context) async {
  return Response(
    statusCode: 301,
    headers: {'location': '/blogs'},
  );
}
