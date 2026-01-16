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

  /// Adds a new subscriber to the newsletter with the given [name] and [email].
  ///
  /// Returns an [HtmlResponse] with:
  /// - Success message (200) if subscribe succeeds
  /// - Error page (with appropriate status code) if it fails
  Future<HtmlResponse> getSubscribeHtml({
    required String name,
    required String email,
  }) async {
    try {
      await _blogNewsletterClient.addSubscriber(
        name: name,
        email: email,
      );
      final html = await _templateEngine.render(
        filePath: 'subscribe_success_message.html',
        context: {
          ...defaultMetaContext,
        },
      );
      return HtmlResponse(
        statusCode: 200,
        html: html,
      );
    } on Exception catch (e) {
      final html = await _templateEngine.render(
        filePath: 'subscribe_error_message.html',
        context: {
          ...defaultMetaContext,
          'message': e.toString(),
        },
      );
      return HtmlResponse(
        statusCode: e is RequestFailedException ? e.statusCode : 500,
        html: html,
      );
    }
  }

  /// Confirms a subscription using the provided [subscriptionToken].
  ///
  /// Returns an [HtmlResponse] with:
  /// - Success page (200) if unsubscribe succeeds
  /// - Error page (with appropriate status code) if it fails
  Future<HtmlResponse> getConfirmHtml({
    required String subscriptionToken,
  }) async {
    try {
      await _blogNewsletterClient.confirmSubscriber(
        subscriptionToken: subscriptionToken,
      );

      final successHtml = await _templateEngine.render(
        filePath: 'confirm_success_page.html',
        context: {
          ...defaultMetaContext,
          ...globalContext,
        },
      );

      return HtmlResponse(statusCode: 200, html: successHtml);
    } on RequestFailedException catch (e) {
      return _templateEngine.renderErrorPage(
        message: 'Failed to confirm subscription: $e. Please try again later.',
        statusCode: e.statusCode,
      );
    }
  }

  /// Unsubscribes a user from the email newsletter.
  ///
  /// Takes an [email] and attempts to remove the subscriber
  /// from the newsletter service.
  ///
  /// Returns an [HtmlResponse] with:
  /// - Success page (200) if unsubscribe succeeds
  /// - Error page (with appropriate status code) if it fails
  Future<HtmlResponse> getUnsubscribeHtml({required String email}) async {
    try {
      await _blogNewsletterClient.removeSubscriber(
        subscriberEmail: email,
      );
      final successHtml = await _templateEngine.render(
        filePath: 'unsubscribe_success_page.html',
        context: {
          ...defaultMetaContext,
          ...globalContext,
        },
      );
      return HtmlResponse(statusCode: 200, html: successHtml);
    } on RequestFailedException catch (e) {
      return _templateEngine.renderErrorPage(
        message: 'Failed to unsubscribe: $e. Please try again later.',
        statusCode: e.statusCode,
      );
    }
  }
}
