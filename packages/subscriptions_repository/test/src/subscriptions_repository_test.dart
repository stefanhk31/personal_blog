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

    group('getSubscribeHtml', () {
      const name = 'John Doe';
      const email = 'john.doe@example.com';
      const emailId = 'email-123';
      const htmlContent = '<p>Test</p>';
      const textContent = 'test';

      test(
        'returns success HtmlResponse when confirmSubscriber succeeds',
        () async {
          const mockResponse = AddSubscriberResponse(
            id: emailId,
            htmlContent: htmlContent,
            textContent: textContent,
          );
          when(
            () => blogNewsletterClient.addSubscriber(
              name: name,
              email: email,
            ),
          ).thenAnswer((_) async => mockResponse);

          when(
            () => templateEngine.render(
              filePath: 'subscribe_success_message.html',
              context: any(named: 'context'),
            ),
          ).thenAnswer((_) async => '<html>Success</html>');

          final result = await subscriptionsRepository.getSubscribeHtml(
            name: name,
            email: email,
          );

          expect(result.statusCode, equals(200));
          expect(result.html, contains('Success'));
          verify(
            () => blogNewsletterClient.addSubscriber(
              name: name,
              email: email,
            ),
          ).called(1);
          verify(
            () => templateEngine.render(
              filePath: 'subscribe_success_message.html',
              context: any(named: 'context'),
            ),
          ).called(1);
        },
      );

      test(
        'returns error HtmlResponse when confirmSubscriber fails with 400',
        () async {
          final exception = RequestFailedException(
            message: 'Bad Request',
            statusCode: 400,
          );
          when(
            () => blogNewsletterClient.addSubscriber(
              name: name,
              email: email,
            ),
          ).thenThrow(exception);

          when(
            () => templateEngine.render(
              filePath: 'subscribe_error_message.html',
              context: any(named: 'context'),
            ),
          ).thenAnswer(
            (_) async => '<html>Error</html>',
          );

          final result = await subscriptionsRepository.getSubscribeHtml(
            name: name,
            email: email,
          );

          expect(result.statusCode, equals(400));
          expect(result.html, contains('Error'));

          verify(
            () => blogNewsletterClient.addSubscriber(
              name: name,
              email: email,
            ),
          ).called(1);
          verify(
            () => templateEngine.render(
              filePath: 'subscribe_error_message.html',
              context: any(named: 'context'),
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
            () => blogNewsletterClient.addSubscriber(
              name: name,
              email: email,
            ),
          ).thenThrow(exception);

          when(
            () => templateEngine.render(
              filePath: 'subscribe_error_message.html',
              context: any(named: 'context'),
            ),
          ).thenAnswer(
            (_) async => '<html>Error</html>',
          );

          final result = await subscriptionsRepository.getSubscribeHtml(
            name: name,
            email: email,
          );

          expect(result.statusCode, equals(500));
          expect(result.html, contains('Error'));

          verify(
            () => blogNewsletterClient.addSubscriber(name: name, email: email),
          ).called(1);
          verify(
            () => templateEngine.render(
              filePath: 'subscribe_error_message.html',
              context: any(named: 'context'),
            ),
          ).called(1);
        },
      );
    });

    group('getConfirmHtml', () {
      const token = '12345';

      test(
        'returns success HtmlResponse when confirmSubscriber succeeds',
        () async {
          const mockResponse = ConfirmSubscriberResponse(statusCode: 200);
          when(
            () => blogNewsletterClient.confirmSubscriber(
              subscriptionToken: token,
            ),
          ).thenAnswer((_) async => mockResponse);

          when(
            () => templateEngine.render(
              filePath: 'confirm_success_page.html',
              context: any(named: 'context'),
            ),
          ).thenAnswer((_) async => '<html>Success</html>');

          final result = await subscriptionsRepository.getConfirmHtml(
            subscriptionToken: token,
          );

          expect(result.statusCode, equals(200));
          expect(result.html, contains('Success'));
          verify(
            () => blogNewsletterClient.confirmSubscriber(
              subscriptionToken: token,
            ),
          ).called(1);
          verify(
            () => templateEngine.render(
              filePath: 'confirm_success_page.html',
              context: any(named: 'context'),
            ),
          ).called(1);
        },
      );

      test(
        'returns error HtmlResponse when confirmSubscriber fails with 400',
        () async {
          final exception = RequestFailedException(
            message: 'Bad Request',
            statusCode: 400,
          );
          when(
            () => blogNewsletterClient.confirmSubscriber(
              subscriptionToken: token,
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

          final result = await subscriptionsRepository.getConfirmHtml(
            subscriptionToken: token,
          );

          expect(result.statusCode, equals(400));
          expect(result.html, contains('Error'));

          verify(
            () => blogNewsletterClient.confirmSubscriber(
              subscriptionToken: token,
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
            () => blogNewsletterClient.confirmSubscriber(
              subscriptionToken: token,
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

          final result = await subscriptionsRepository.getConfirmHtml(
            subscriptionToken: token,
          );

          expect(result.statusCode, equals(500));
          expect(result.html, contains('Error'));

          verify(
            () => blogNewsletterClient.confirmSubscriber(
              subscriptionToken: token,
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

    group('getUnsubscribeHtml', () {
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

          final result = await subscriptionsRepository.getUnsubscribeHtml(
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

          final result = await subscriptionsRepository.getUnsubscribeHtml(
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

          final result = await subscriptionsRepository.getUnsubscribeHtml(
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
