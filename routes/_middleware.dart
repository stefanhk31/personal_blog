import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:blog_newsletter_client/blog_newsletter_client.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:butter_cms_client/butter_cms_client.dart';
import 'package:captcha_client/captcha_client.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:http/http.dart' hide Response;
import 'package:subscriptions_repository/subscriptions_repository.dart';
import 'package:template_engine/template_engine.dart';

Handler middleware(Handler handler) {
  return handler
      .use(_trailingSlashRedirect)
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
        final baseUrl = Platform.environment['BASE_NEWSLETTER_URL'];

        if (baseUrl == null) {
          throw StateError('Could not fetch BASE_NEWSLETTER_URL');
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
    provider<CaptchaClient>(
      (context) {
        final secretKey = Platform.environment['CAPTCHA_SECRET_KEY'];

        if (secretKey == null) {
          throw StateError('Could not fetch CAPTCHA_SECRET_KEY');
        }

        return CaptchaClient(
          apiClient: context.read<ApiClient>(),
          secretKey: secretKey,
        );
      },
    ),
  ).use(
    provider<ApiClient>((_) => ApiClient(client: Client())),
  );
}

/// Redirects any request whose path ends in a trailing `/` (except the root)
/// to the equivalent path without the trailing slash, preserving the query
/// string. E.g. `/blogs/{slug}/` -> `/blogs/{slug}`.
Handler _trailingSlashRedirect(Handler handler) {
  return (context) {
    final uri = context.request.uri;
    final path = uri.path;

    if (path.length > 1 && path.endsWith('/')) {
      final normalized = path.substring(0, path.length - 1);
      return Response(
        statusCode: 301,
        headers: {'location': uri.replace(path: normalized).toString()},
      );
    }

    return handler(context);
  };
}
