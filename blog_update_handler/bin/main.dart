import 'dart:io';

import 'package:blog_newsletter_client/blog_newsletter_client.dart';
import 'package:blog_update_handler/blog_update_handler.dart';
import 'package:butter_cms_client/butter_cms_client.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  // Load environment variables
  final butterCmsApiKey = Platform.environment['BUTTER_CMS_API_KEY'];
  final newsletterBaseUrl = Platform.environment['NEWSLETTER_BASE_URL'];
  final publishDurationMinutes = Platform.environment['PUBLISH_DURATION'];

  // Validate environment variables
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

  // Parse duration
  final durationMinutes = int.tryParse(publishDurationMinutes);
  if (durationMinutes == null || durationMinutes <= 0) {
    print('Error: PUBLISH_DURATION must be a positive integer (minutes)');
    exit(1);
  }

  // Create HTTP client
  final httpClient = http.Client();

  // Instantiate dependencies
  final butterCmsClient = ButterCmsClient(
    apiKey: butterCmsApiKey,
    httpClient: httpClient,
  );

  final blogNewsletterClient = BlogNewsletterClient(
    baseUrl: newsletterBaseUrl,
    httpClient: httpClient,
  );

  final handler = BlogUpdateHandler(
    butterCmsClient: butterCmsClient,
    blogNewsletterClient: blogNewsletterClient,
    publishDuration: Duration(minutes: durationMinutes),
  );

  // Execute handler
  await handler.publishRecentPosts();

  // Clean up
  httpClient.close();
}
