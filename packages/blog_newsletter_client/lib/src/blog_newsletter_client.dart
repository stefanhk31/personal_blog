import 'dart:convert';

import 'package:blog_models/blog_models.dart';
import 'package:http/http.dart';

/// {@template blog_newsletter_client}
/// Client to interact with the blog's newsletter service.
/// {@endtemplate}
class BlogNewsletterClient {
  /// {@macro blog_newsletter_client}
  const BlogNewsletterClient({
    required Client httpClient,
    required String baseUrl,
  }) : _httpClient = httpClient,
       _baseUrl = baseUrl;

  final Client _httpClient;
  final String _baseUrl;

  /// Publishes a newsletter to the blog's newsletter service.
  ///
  /// Takes a [request] containing the newsletter content to be published.
  ///
  /// Returns the [Response] from the newsletter service.
  Future<Response> publishNewsletter({
    required BlogNewsletterPublishRequest request,
  }) async {
    final uri = Uri.http(_baseUrl, '/newsletters');
    final body = jsonEncode(request.toJson());
    return _httpClient.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  /// Deletes a subscriber from the blog newsletter service's database
  /// of email subscribers.
  ///
  /// Takes an encoded [String] of the subscriber's email.
  ///
  /// Returns  the [Response] from the newsletter service.
  Future<Response> removeSubscriber({
    required String encodedSubscriberEmail,
  }) async {
    final uri = Uri.http(_baseUrl, '/subscriptions');
    return _httpClient.delete(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: encodedSubscriberEmail,
    );
  }
}
