import 'package:blog_models/blog_models.dart';
import 'package:blog_newsletter_client/blog_newsletter_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:subscriptions_repository/subscriptions_repository.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

class MockBlogNewsletterClient extends Mock implements BlogNewsletterClient {}

class MockTemplateEngine extends Mock implements TemplateEngine {}

void main() {
  group('SubscriptionsRepository', () {
    late BlogNewsletterClient blogNewsletterClient;
    late TemplateEngine templateEngine;
    late SubscriptionsRepository subscriptionsRepository;

    setUp(() {
      blogNewsletterClient = MockBlogNewsletterClient();
      templateEngine = MockTemplateEngine();
      subscriptionsRepository = SubscriptionsRepository(
        blogNewsletterClient: blogNewsletterClient,
        templateEngine: templateEngine,
      );
    });

    test('can be instantiated', () {
      expect(subscriptionsRepository, isNotNull);
    });

    group('unsubscribe', () {
      const encodedEmail = 'test%40example.com';

      test(
        'returns success HtmlResponse when removeSubscriber succeeds',
        () async {
          const mockResponse = RemoveSubscriberResponse(statusCode: 200);
          when(
            () => blogNewsletterClient.removeSubscriber(
              subscriberEmail: encodedEmail,
            ),
          ).thenAnswer((_) async => mockResponse);

          when(
            () => templateEngine.render(
              filePath: 'unsubscribe_success_page.html',
              context: any(named: 'context'),
            ),
          ).thenAnswer((_) async => '<html>Success</html>');

          final result = await subscriptionsRepository.unsubscribe(
            email: encodedEmail,
          );

          expect(result.statusCode, equals(200));
          expect(result.html, contains('Success'));
          verify(
            () => blogNewsletterClient.removeSubscriber(
              subscriberEmail: encodedEmail,
            ),
          ).called(1);
          verify(
            () => templateEngine.render(
              filePath: 'unsubscribe_success_page.html',
              context: any(named: 'context'),
            ),
          ).called(1);
        },
      );

      test(
        'returns error HtmlResponse when removeSubscriber fails with 400',
        () async {
          final exception = RequestFailedException(
            message: 'Bad Request',
            statusCode: 400,
          );
          when(
            () => blogNewsletterClient.removeSubscriber(
              subscriberEmail: encodedEmail,
            ),
          ).thenThrow(exception);

          when(
            () => templateEngine.renderErrorPage(
              message: any(named: 'message'),
              statusCode: any(named: 'statusCode'),
            ),
          ).thenAnswer(
            (_) async => const HtmlResponse(
              statusCode: 400,
              html: '<html>Error</html>',
            ),
          );

          final result = await subscriptionsRepository.unsubscribe(
            email: encodedEmail,
          );

          expect(result.statusCode, equals(400));
          expect(result.html, contains('Error'));

          verify(
            () => blogNewsletterClient.removeSubscriber(
              subscriberEmail: encodedEmail,
            ),
          ).called(1);
          verify(
            () => templateEngine.renderErrorPage(
              message: any(named: 'message'),
              statusCode: any(named: 'statusCode'),
            ),
          ).called(1);
        },
      );

      test(
        'returns error HtmlResponse when removeSubscriber fails with 500',
        () async {
          final exception = RequestFailedException(
            message: 'Internal Server Error',
            statusCode: 500,
          );
          when(
            () => blogNewsletterClient.removeSubscriber(
              subscriberEmail: encodedEmail,
            ),
          ).thenThrow(exception);

          when(
            () => templateEngine.renderErrorPage(
              message: any(named: 'message'),
              statusCode: any(named: 'statusCode'),
            ),
          ).thenAnswer(
            (_) async => const HtmlResponse(
              statusCode: 500,
              html: '<html>Error</html>',
            ),
          );

          final result = await subscriptionsRepository.unsubscribe(
            email: encodedEmail,
          );

          expect(result.statusCode, equals(500));
          expect(result.html, contains('Error'));

          verify(
            () => blogNewsletterClient.removeSubscriber(
              subscriberEmail: encodedEmail,
            ),
          ).called(1);
          verify(
            () => templateEngine.renderErrorPage(
              message: any(named: 'message'),
              statusCode: any(named: 'statusCode'),
            ),
          ).called(1);
        },
      );
    });
  });
}
