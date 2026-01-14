import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:blog_newsletter_client/blog_newsletter_client.dart';
import 'package:blog_update_handler/blog_update_handler.dart';
import 'package:butter_cms_client/butter_cms_client.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final butterCmsApiKey = Platform.environment['BUTTER_CMS_API_KEY'];
  final newsletterBaseUrl = Platform.environment['NEWSLETTER_BASE_URL'];
  final publishDurationMinutes = Platform.environment['PUBLISH_DURATION'];

  if (butterCmsApiKey == null || butterCmsApiKey.isEmpty) {
    print('Error: BUTTER_CMS_API_KEY environment variable not set');
    exit(1);
  }
  if (newsletterBaseUrl == null || newsletterBaseUrl.isEmpty) {
    print('Error: NEWSLETTER_BASE_URL environment variable not set');
    exit(1);
  }
  if (publishDurationMinutes == null || publishDurationMinutes.isEmpty) {
    print('Error: PUBLISH_DURATION environment variable not set');
    exit(1);
  }

  final durationMinutes = int.tryParse(publishDurationMinutes);
  if (durationMinutes == null || durationMinutes <= 0) {
    print('Error: PUBLISH_DURATION must be a positive integer (minutes)');
    exit(1);
  }

  final httpClient = http.Client();

  final apiClient = ApiClient(client: httpClient);

  final butterCmsClient = ButterCmsClient(
    apiKey: butterCmsApiKey,
    apiClient: ApiClient(client: httpClient),
  );

  final blogNewsletterClient = BlogNewsletterClient(
    baseUrl: newsletterBaseUrl,
    apiClient: apiClient,
  );

  final handler = BlogUpdateHandler(
    butterCmsClient: butterCmsClient,
    blogNewsletterClient: blogNewsletterClient,
    publishDuration: Duration(minutes: durationMinutes),
  );

  await handler.publishRecentPosts();

  httpClient.close();
}
