import 'dart:io';

import 'package:blog_models/blog_models.dart';
import 'package:blog_newsletter_client/blog_newsletter_client.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockHttpClient extends Mock implements Client {}

void main() {
  group('BlogNewsletterClient', () {
    late Client httpClient;
    late BlogNewsletterClient blogNewsletterClient;
    const baseUrl = 'test';

    setUp(() {
      httpClient = _MockHttpClient();
      blogNewsletterClient = BlogNewsletterClient(
        httpClient: httpClient,
        baseUrl: baseUrl,
      );
    });

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    test('can be instantiated', () {
      expect(blogNewsletterClient, isNotNull);
    });

    group('publishNewsletter', () {
      const path = '/newsletters';
      const request = BlogNewsletterPublishRequest(
        title: newsletterTitle,
        content: newsletterContent,
        idempotencyKey: newsletterIdempotencyKey,
      );
      const errorMessage = 'error';

      test(
          'returns 200 with response body '
          'when the call completes successfully', () async {
        when(
          () => httpClient.post(
            any(
              that: isA<Uri>().having(
                (uri) => uri.path,
                'path',
                path,
              ),
            ),
            body: any(named: 'body'),
          ),
        ).thenAnswer(
          (_) async => Response(
            '{"success": true}',
            200,
            headers: {'content-type': 'application/json'},
          ),
        );

        final result = await blogNewsletterClient.publishNewsletter(
          request: request,
        );
        expect(result.statusCode, equals(HttpStatus.ok));
      });

      test('returns failure with body when call fails', () async {
        when(
          () => httpClient.post(
            any(
              that: isA<Uri>().having(
                (uri) => uri.path,
                'path',
                path,
              ),
            ),
            body: any(named: 'body'),
          ),
        ).thenAnswer(
          (_) async => Response(
            errorMessage,
            HttpStatus.notFound,
          ),
        );

        final result = await blogNewsletterClient.publishNewsletter(
          request: request,
        );
        expect(result.statusCode, equals(HttpStatus.notFound));
        expect(result.body, equals(errorMessage));
      });
    });
  });
}
