import 'dart:io';

import 'package:blog_repository/blog_repository.dart';
import 'package:butter_cms_client/butter_cms_client.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:http/http.dart';
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
    provider<ButterCmsClient>(
      (_) {
        final apiKey = Platform.environment['BUTTER_CMS_API_KEY'];

        if (apiKey == null) {
          throw StateError('Could not fetch secret BUTTER_CMS_API_KEY');
        }

        return ButterCmsClient(
          httpClient: Client(),
          apiKey: apiKey,
        );
      },
    ),
  );
}
