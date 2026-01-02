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
    return _httpClient.post(uri, body: jsonEncode(request.toJson()));
  }
}
