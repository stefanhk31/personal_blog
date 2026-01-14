import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:blog_models/blog_models.dart';
import 'package:blog_newsletter_client/blog_newsletter_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group('BlogNewsletterClient', () {
    late ApiClient apiClient;
    late BlogNewsletterClient blogNewsletterClient;
    const baseUrl = 'test';

    setUp(() {
      apiClient = _MockApiClient();
      blogNewsletterClient = BlogNewsletterClient(
        apiClient: apiClient,
        baseUrl: baseUrl,
      );
    });

    setUpAll(() {
      registerFallbackValue(Uri());
      registerFallbackValue(HttpMethod.post);
    });

    test('can be instantiated', () {
      expect(blogNewsletterClient, isNotNull);
    });

    group('confirmSubscriber', () {
      const token = '12345';
      const path = '/subscriptions/confirm';
      const queryParameters = {'subscription_token': token};

      test(
        'returns ConfirmSubscriberResponse when call completes successfully',
        () async {
          const expectedResponse = ConfirmSubscriberResponse(
            statusCode: 200,
            message: 'Confirmation Successful',
          );

          when(
            () => apiClient.sendRequest<ConfirmSubscriberResponse>(
              any(
                that: isA<Uri>()
                    .having(
                      (uri) => uri.path,
                      'path',
                      path,
                    )
                    .having(
                      (uri) => uri.queryParameters,
                      'queryParameters',
                      queryParameters,
                    ),
              ),
              method: HttpMethod.get,
              headers: any(named: 'headers'),
              fromJson: ConfirmSubscriberResponse.fromJson,
            ),
          ).thenAnswer((_) async => expectedResponse);

          final result = await blogNewsletterClient.confirmSubscriber(
            subscriptionToken: token,
          );

          expect(result, equals(expectedResponse));
          expect(result.statusCode, equals(HttpStatus.ok));
          expect(result.message, equals('Confirmation Successful'));
        },
      );

      test('throws RequestFailedException when call fails', () async {
        const errorMessage = 'error';
        final exception = RequestFailedException(
          message: errorMessage,
          statusCode: HttpStatus.notFound,
        );

        when(
          () => apiClient.sendRequest<ConfirmSubscriberResponse>(
            any(
              that: isA<Uri>()
                  .having(
                    (uri) => uri.path,
                    'path',
                    path,
                  )
                  .having(
                    (uri) => uri.queryParameters,
                    'queryParameters',
                    queryParameters,
                  ),
            ),
            method: HttpMethod.get,
            headers: any(named: 'headers'),
            fromJson: ConfirmSubscriberResponse.fromJson,
          ),
        ).thenThrow(exception);

        expect(
          () =>
              blogNewsletterClient.confirmSubscriber(subscriptionToken: token),
          throwsA(
            isA<RequestFailedException>()
                .having((e) => e.statusCode, 'statusCode', HttpStatus.notFound)
                .having((e) => e.message, 'message', errorMessage),
          ),
        );
      });
    });

    group('publishNewsletter', () {
      const path = '/newsletters';
      const request = BlogNewsletterPublishRequest(
        title: newsletterTitle,
        content: newsletterContent,
        idempotencyKey: newsletterIdempotencyKey,
      );

      test('returns PublishNewsletterResponse '
          'when the call completes successfully', () async {
        const expectedResponse = PublishNewsletterResponse(
          statusCode: 200,
          message: 'Publish successful',
        );

        when(
          () => apiClient.sendRequest<PublishNewsletterResponse>(
            any(
              that: isA<Uri>().having(
                (uri) => uri.path,
                'path',
                path,
              ),
            ),
            method: HttpMethod.post,
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            fromJson: PublishNewsletterResponse.fromJson,
          ),
        ).thenAnswer((_) async => expectedResponse);

        final result = await blogNewsletterClient.publishNewsletter(
          request: request,
        );

        expect(result, equals(expectedResponse));
        expect(result.statusCode, equals(HttpStatus.ok));
        expect(result.message, equals('Publish successful'));
      });

      test('throws RequestFailedException when call fails', () async {
        const errorMessage = 'error';
        final exception = RequestFailedException(
          message: errorMessage,
          statusCode: HttpStatus.notFound,
        );

        when(
          () => apiClient.sendRequest<PublishNewsletterResponse>(
            any(
              that: isA<Uri>().having(
                (uri) => uri.path,
                'path',
                path,
              ),
            ),
            method: HttpMethod.post,
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            fromJson: PublishNewsletterResponse.fromJson,
          ),
        ).thenThrow(exception);

        expect(
          () => blogNewsletterClient.publishNewsletter(request: request),
          throwsA(
            isA<RequestFailedException>()
                .having((e) => e.statusCode, 'statusCode', HttpStatus.notFound)
                .having((e) => e.message, 'message', errorMessage),
          ),
        );
      });
    });

    group('removeSubscriber', () {
      const path = '/subscriptions/unsubscribe';
      const subscriberEmail = 'test@example.com';

      test('returns RemoveSubscriberResponse '
          'when the call completes successfully', () async {
        const expectedResponse = RemoveSubscriberResponse(
          statusCode: 200,
          message: '{"success": true}',
        );

        when(
          () => apiClient.sendRequest<RemoveSubscriberResponse>(
            any(
              that: isA<Uri>().having(
                (uri) => uri.path,
                'path',
                path,
              ),
            ),
            method: HttpMethod.delete,
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            fromJson: RemoveSubscriberResponse.fromJson,
          ),
        ).thenAnswer((_) async => expectedResponse);

        final result = await blogNewsletterClient.removeSubscriber(
          subscriberEmail: subscriberEmail,
        );

        expect(result, equals(expectedResponse));
        expect(result.statusCode, equals(HttpStatus.ok));
        expect(result.message, equals('{"success": true}'));
      });

      test('throws RequestFailedException when call fails', () async {
        const errorMessage = 'error';
        final exception = RequestFailedException(
          message: errorMessage,
          statusCode: HttpStatus.notFound,
        );

        when(
          () => apiClient.sendRequest<RemoveSubscriberResponse>(
            any(
              that: isA<Uri>().having(
                (uri) => uri.path,
                'path',
                path,
              ),
            ),
            method: HttpMethod.delete,
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            fromJson: RemoveSubscriberResponse.fromJson,
          ),
        ).thenThrow(exception);

        expect(
          () => blogNewsletterClient.removeSubscriber(
            subscriberEmail: subscriberEmail,
          ),
          throwsA(
            isA<RequestFailedException>()
                .having((e) => e.statusCode, 'statusCode', HttpStatus.notFound)
                .having((e) => e.message, 'message', errorMessage),
          ),
        );
      });

      test('encodes email in request body', () async {
        const expectedResponse = RemoveSubscriberResponse(statusCode: 200);

        when(
          () => apiClient.sendRequest<RemoveSubscriberResponse>(
            any(),
            method: HttpMethod.delete,
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            fromJson: RemoveSubscriberResponse.fromJson,
          ),
        ).thenAnswer((_) async => expectedResponse);

        await blogNewsletterClient.removeSubscriber(
          subscriberEmail: subscriberEmail,
        );

        verify(
          () => apiClient.sendRequest<RemoveSubscriberResponse>(
            any(),
            method: HttpMethod.delete,
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'email=test%40example.com',
            fromJson: RemoveSubscriberResponse.fromJson,
          ),
        ).called(1);
      });
    });
  });
}
