// ignore_for_file: avoid_relative_lib_imports

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../routes/index.dart' as route;
import '../helpers/method_not_allowed.dart';

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('index', () {
    group('GET /', () {
      test('responds with a 301', () async {
        final context = _MockRequestContext();
        final request = Request('GET', Uri.parse('http://127.0.0.1/'));

        when(() => context.request).thenReturn(request);
        final response = await route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.movedPermanently));
        expect(
          response.headers['location'],
          equals('/blogs'),
        );
      });
    });

    test('returns 405 for unsupported methods', () async {
      final context = _MockRequestContext();
      Future<Response> action() async => route.onRequest(context);

      await testMethodNotAllowed(
        context,
        () => route.onRequest(context),
        'POST',
      );
      await testMethodNotAllowed(
        context,
        () => route.onRequest(context),
        'PUT',
      );
      await testMethodNotAllowed(
        context,
        () => route.onRequest(context),
        'DELETE',
      );
      await testMethodNotAllowed(
        context,
        action,
        'PATCH',
      );
      await testMethodNotAllowed(
        context,
        action,
        'HEAD',
      );
      await testMethodNotAllowed(
        context,
        action,
        'OPTIONS',
      );
    });
  });
}
