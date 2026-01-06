import 'dart:async';
import 'dart:io';

import 'package:blog_models/blog_models.dart';
import 'package:logging/logging.dart';
import 'package:template_engine/src/constants.dart';

/// {@template TemplateEngine}
/// Engine to read the content of an HTML file and
/// replace placeholders with the provided properties.
/// {@endtemplate}
class TemplateEngine {
  /// {@macro TemplateEngine}
  TemplateEngine({required String basePath, Logger? logger})
    : _basePath = basePath,
      _logger = logger ?? Logger('TemplateEngine');

  final String _basePath;
  final Logger _logger;

  /// Renders the content of an HTML file and parses according to
  /// the properties in [context], using [mustache](https://mustache.github.io/mustache.5.html) syntax.
  /// Logic is adapted from the simple_mustache package:
  /// https://github.com/DavBfr/simple_mustache/blob/master/lib/src/mustache.dart
  ///
  Future<String> render({
    required String filePath,
    Map<String, dynamic> context = const {},
  }) async {
    String? file;
    try {
      file = await File('$_basePath/$filePath').readAsString();
    } on Exception catch (e) {
      final message = 'Error reading file: $e';
      _logger.severe(message);
      throw Exception(message);
    }

    final buffer = StringBuffer();
    final regex = RegExp(
      r'({{\s*([#/^>!]?) *([\w\d_]*)\s*\|?\s*([\w\d\s_\|]*)}})',
    );

    var startIndex = 0;
    var skip = false;
    var skipField = '';
    var listValues = <dynamic>[];
    var listLoop = 0;
    var listField = '';
    final tempCtx = <String, dynamic>{};
    final ctx = Map<String, dynamic>.from(context);

    while (true) {
      final matches = regex.allMatches(file, startIndex);
      if (matches.isEmpty) break;
      final match = matches.first;
      final modifier = match.group(2);
      final field = match.group(3);
      if (modifier == null || field == null) {
        continue;
      }

      // comment tag
      if (modifier == '!') {
        buffer.write(file.substring(startIndex, match.start));
        startIndex = match.end;
        continue;
      }

      // end tag
      if (modifier == '/') {
        if (!skip) {
          buffer.write(file.substring(startIndex, match.start));
          if (listValues.isNotEmpty &&
              listField.isNotEmpty &&
              field == listField) {
            startIndex = listLoop;
            ctx
              ..clear()
              ..addAll(tempCtx)
              ..addAll(listValues.first as Map<String, dynamic>);
            listValues.removeAt(0);
            continue;
          }
        }
        if (skipField == field) {
          skip = false;
          skipField = '';
        }

        startIndex = match.end;
        continue;
      }

      if (skip) {
        startIndex = match.end;
        continue;
      }

      // start tag
      if (modifier == '#') {
        buffer.write(file.substring(startIndex, match.start));
        if (ctx.containsKey(field)) {
          var value = ctx[field];
          if (value is bool) {
            skip = !value;
          } else {
            skip = value == null;
          }

          if (value is Map) {
            value = <dynamic>[value];
          }

          if (value is List) {
            if (value.isEmpty) {
              skip = true;
              skipField = field;
              startIndex = match.end;
              continue;
            }

            listField = field;

            tempCtx
              ..clear()
              ..addAll(ctx);
            listValues = <dynamic>[...value];
            ctx
              ..clear()
              ..addAll(tempCtx)
              ..addAll(listValues.first as Map<String, dynamic>);
            listValues.removeAt(0);
            listLoop = match.end;
          }
        } else {
          skip = true;
        }
        skipField = field;
        startIndex = match.end;
        continue;
      }

      // inverted start tag
      if (modifier == '^') {
        buffer.write(file.substring(startIndex, match.start));
        if (ctx.containsKey(field)) {
          final value = ctx[field];
          if (value is bool) {
            skip = value;
          } else if (value is List) {
            skip = value.isNotEmpty;
          } else {
            skip = true;
          }
        }
        skipField = field;
        startIndex = match.end;
        continue;
      }

      // partial tag
      if (modifier == '>') {
        buffer.write(file.substring(startIndex, match.start));
        final partial = await render(
          filePath: '/$field.html',
          context: context,
        );
        buffer.write(partial);
        startIndex = match.end;
        continue;
      }

      buffer.write(file.substring(startIndex, match.start));

      dynamic value;
      if (!ctx.containsKey(field)) {
        _logger.warning('field $field not found');
        value = field;
      } else {
        value = ctx[field];
      }
      buffer.write(value);
      startIndex = match.end;
    }

    buffer.write(file.substring(startIndex));
    return buffer.toString();
  }

  /// Renders an error page and returns it in a [HtmlResponse]
  /// with a given [statusCode].
  Future<HtmlResponse> renderErrorPage({
    required String message,
    int statusCode = 500,
  }) async {
    final errorHtml = await render(
      filePath: 'error_page.html',
      context: {'message': message, ...defaultMetaContext, ...globalContext},
    );
    return HtmlResponse(statusCode: statusCode, html: errorHtml);
  }
}
