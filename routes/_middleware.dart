import 'dart:convert';
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
          basePath: '${base}packages/blog_repository/templates',
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

        final secretJson = Platform.environment['BUTTER_CMS_API_KEY'];

        if (secretJson == null) {
          throw StateError('Could not fetch secret BUTTER_CMS_API_KEY');
        }

        final secret = jsonDecode(secretJson) as Map<String, dynamic>;
        //final apiKey = secret['BUTTER_CMS_API_KEY'] as String?;

        if (apiKey == null) {
          throw StateError('Could not resolve apiKey value from secret');
        }

        return ButterCmsClient(
          httpClient: Client(),
          apiKey: apiKey,
        );
      },
    ),
  );
}
