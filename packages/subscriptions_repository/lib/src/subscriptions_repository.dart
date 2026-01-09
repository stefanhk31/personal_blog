import 'package:blog_models/blog_models.dart';
import 'package:blog_newsletter_client/blog_newsletter_client.dart';
import 'package:template_engine/template_engine.dart';

/// {@template subscriptions_repository}
/// A repository to encapsulate logic managing email subscriptions.
/// {@endtemplate}
class SubscriptionsRepository {
  /// {@macro subscriptions_repository}
  const SubscriptionsRepository({
    required BlogNewsletterClient blogNewsletterClient,
    required TemplateEngine templateEngine,
  }) : _blogNewsletterClient = blogNewsletterClient,
       _templateEngine = templateEngine;

  final BlogNewsletterClient _blogNewsletterClient;
  final TemplateEngine _templateEngine;

  /// Unsubscribes a user from the email newsletter.
  ///
  /// Takes an [encodedEmail] and attempts to remove the subscriber
  /// from the newsletter service.
  ///
  /// Returns an [HtmlResponse] with:
  /// - Success page (200) if unsubscribe succeeds
  /// - Error page (with appropriate status code) if it fails
  Future<HtmlResponse> unsubscribe({required String email}) async {
    final response = await _blogNewsletterClient.removeSubscriber(
      subscriberEmail: email,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final successHtml = await _templateEngine.render(
        filePath: 'unsubscribe_success_page.html',
        context: {
          ...defaultMetaContext,
          ...globalContext,
        },
      );
      return HtmlResponse(statusCode: 200, html: successHtml);
    }

    return _templateEngine.renderErrorPage(
      message: 'Failed to unsubscribe. Please try again later.',
      statusCode: response.statusCode,
    );
  }
}
