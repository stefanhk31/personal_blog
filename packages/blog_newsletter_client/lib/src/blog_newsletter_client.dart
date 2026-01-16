import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:blog_models/blog_models.dart';

/// {@template blog_newsletter_client}
/// Client to interact with the blog's newsletter service.
/// {@endtemplate}
class BlogNewsletterClient {
  /// {@macro blog_newsletter_client}
  const BlogNewsletterClient({
    required ApiClient apiClient,
    required String baseUrl,
  }) : _apiClient = apiClient,
       _baseUrl = baseUrl;

  final ApiClient _apiClient;
  final String _baseUrl;

  /// Adds a subscriber to the blog's newsletter service.
  ///
  /// Takes a [name] and [email] as parameters.
  ///
  /// Returns a [AddSubscriberResponse] with id and content
  /// of the confirmation email sent.
  Future<AddSubscriberResponse> addSubscriber({
    required String name,
    required String email,
  }) async {
    final uri = Uri.http(
      _baseUrl,
      '/subscriptions',
    );
    final encodedName = Uri.encodeComponent(name);
    final encodedEmail = Uri.encodeComponent(email);
    return _apiClient.sendRequest<AddSubscriberResponse>(
      uri,
      method: HttpMethod.post,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'name=$encodedName&email=$encodedEmail',
      fromJson: AddSubscriberResponse.fromJson,
    );
  }

  /// Confirms a subscription to the blog's newsletter service.
  ///
  /// Takes a [subscriptionToken] to confirm the subscription.
  ///
  /// Returns a [ConfirmSubscriberResponse].
  Future<ConfirmSubscriberResponse> confirmSubscriber({
    required String subscriptionToken,
  }) async {
    final uri = Uri.http(
      _baseUrl,
      '/subscriptions/confirm',
      {'subscription_token': subscriptionToken},
    );
    return _apiClient.sendRequest<ConfirmSubscriberResponse>(
      uri,
      method: HttpMethod.get,
      fromJson: ConfirmSubscriberResponse.fromJson,
    );
  }

  /// Publishes a newsletter to the blog's newsletter service.
  ///
  /// Takes a [request] containing the newsletter content to be published.
  ///
  /// Returns a [PublishNewsletterResponse] with status code and optional body.
  Future<PublishNewsletterResponse> publishNewsletter({
    required BlogNewsletterPublishRequest request,
  }) async {
    final uri = Uri.http(_baseUrl, '/newsletters');
    final body = jsonEncode(request.toJson());

    return _apiClient.sendRequest<PublishNewsletterResponse>(
      uri,
      method: HttpMethod.post,
      headers: {'Content-Type': 'application/json'},
      body: body,
      fromJson: PublishNewsletterResponse.fromJson,
    );
  }

  /// Deletes a subscriber from the blog newsletter service's database
  /// of email subscribers.
  ///
  /// Takes an encoded [String] of the subscriber's email.
  ///
  /// Returns a [RemoveSubscriberResponse] with status code and optional body.
  Future<RemoveSubscriberResponse> removeSubscriber({
    required String subscriberEmail,
  }) async {
    final uri = Uri.http(_baseUrl, '/subscriptions/unsubscribe');
    final encodedEmail = Uri.encodeComponent(subscriberEmail);

    return _apiClient.sendRequest<RemoveSubscriberResponse>(
      uri,
      method: HttpMethod.delete,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'email=$encodedEmail',
      fromJson: RemoveSubscriberResponse.fromJson,
    );
  }
}
