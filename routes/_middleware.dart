import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:blog_newsletter_client/blog_newsletter_client.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:butter_cms_client/butter_cms_client.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:http/http.dart';
import 'package:subscriptions_repository/subscriptions_repository.dart';
import 'package:template_engine/template_engine.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(
        provider<BlogRepository>(
          (context) => BlogRepository(
            cmsClient: context.read<ButterCmsClient>(),
            templateEngine: context.read<TemplateEngine>(),
          ),
        ),
      )
      .use(
        provider<SubscriptionsRepository>(
          (context) => SubscriptionsRepository(
            blogNewsletterClient: context.read<BlogNewsletterClient>(),
            templateEngine: context.read<TemplateEngine>(),
          ),
        ),
      )
      .use(
    provider<TemplateEngine>(
      (_) {
        final currentPath = Directory.current.path;
        final base = currentPath.endsWith('/') ? currentPath : '$currentPath/';

        return TemplateEngine(
          basePath: '${base}templates',
        );
      },
    ),
  ).use(
    provider<BlogNewsletterClient>(
      (context) {
        final baseUrl = Platform.environment['NEWSLETTER_BASE_URL'];

        if (baseUrl == null) {
          throw StateError('Could not fetch NEWSLETTER_BASE_URL');
        }

        return BlogNewsletterClient(
          apiClient: context.read<ApiClient>(),
          baseUrl: baseUrl,
        );
      },
    ),
  ).use(
    provider<ButterCmsClient>(
      (context) {
        final apiKey = Platform.environment['BUTTER_CMS_API_KEY'];

        if (apiKey == null) {
          throw StateError('Could not fetch secret BUTTER_CMS_API_KEY');
        }

        return ButterCmsClient(
          apiClient: context.read<ApiClient>(),
          apiKey: apiKey,
        );
      },
    ),
  ).use(
    provider<ApiClient>((_) => ApiClient(client: Client())),
  );
}
