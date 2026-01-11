// ignore_for_file: avoid_relative_lib_imports

import 'dart:io';

import 'package:blog_models/blog_models.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:subscriptions_repository/subscriptions_repository.dart';
import 'package:test/test.dart';

import '../../../../routes/subscriptions/unsubscribe/index.dart' as route;
import '../../../helpers/method_not_allowed.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockSubscriptionsRepository extends Mock
    implements SubscriptionsRepository {}

void main() {
  group('subscriptions/unsubscribe', () {
    group('GET /', () {
      late SubscriptionsRepository subscriptionsRepository;
      const unSubscribeUrl =
          'http://127.0.0.1/subscriptions/unsubscribe?email=test%40example.com';

      setUp(() {
        subscriptionsRepository = _MockSubscriptionsRepository();
      });

      test(
          'responds with a 200 when email is provided and unsubscribe succeeds',
          () async {
        final context = _MockRequestContext();
        final request = Request(
          'GET',
          Uri.parse(unSubscribeUrl),
        );
        const htmlContent = '<html>Success</html>';

        when(() => context.request).thenReturn(request);
        when(() => context.read<SubscriptionsRepository>())
            .thenReturn(subscriptionsRepository);
        when(
          () => subscriptionsRepository.getUnsubscribeHtml(
            email: any(named: 'email'),
          ),
        ).thenAnswer(
          (_) async => const HtmlResponse(statusCode: 200, html: htmlContent),
        );

        final response = await route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(
          response.body(),
          completion(equals(htmlContent)),
        );
        expect(
          response.headers['content-type'],
          equals('text/html'),
        );

        verify(
          () => subscriptionsRepository.getUnsubscribeHtml(
            email: 'test@example.com',
          ),
        ).called(1);
      });

      test('responds with error status when repository returns error',
          () async {
        final context = _MockRequestContext();
        final request = Request('GET', Uri.parse(unSubscribeUrl));
        const htmlContent = '<html>Error</html>';

        when(() => context.request).thenReturn(request);
        when(() => context.read<SubscriptionsRepository>())
            .thenReturn(subscriptionsRepository);
        when(
          () => subscriptionsRepository.getUnsubscribeHtml(
            email: any(named: 'email'),
          ),
        ).thenAnswer(
          (_) async => const HtmlResponse(statusCode: 500, html: htmlContent),
        );

        final response = await route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.internalServerError));
        expect(
          response.body(),
          completion(equals(htmlContent)),
        );
      });

      test('responds with 400 when email query parameter is missing', () async {
        final context = _MockRequestContext();
        final request = Request(
          'GET',
          Uri.parse('http://127.0.0.1/subscriptions/unsubscribe'),
        );

        when(() => context.request).thenReturn(request);

        final response = await route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.badRequest));
        expect(
          response.body(),
          completion(equals('Email is required')),
        );

        verifyNever(
          () => subscriptionsRepository.getUnsubscribeHtml(
            email: any(named: 'email'),
          ),
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
