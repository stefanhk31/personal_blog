import 'dart:io';

import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

void main() {
  group('TemplateEngine', () {
    late Logger logger;
    final basePath = '${Directory.current.path}/test/src/fixtures';
    const title = 'Test Title';
    const imageUrl = 'https://example.com/image.png';
    const header = 'Test Header';
    const people = [
      {'name': 'John Doe', 'dob': '01/01/2000'},
      {'name': 'Jane Doe', 'dob': '02/02/2000'},
    ];

    setUp(
      () {
        logger = _MockLogger();
        when(
          () => logger.warning(any()),
        ).thenAnswer((_) {});
        when(
          () => logger.severe(any()),
        ).thenAnswer((_) {});
      },
    );

    group('render', () {
      test('inserts fields into template', () async {
        final context = {
          'title': title,
          'imageUrl': imageUrl,
          'header': header,
          'people': people,
        };
        final engine = TemplateEngine(
          basePath: basePath,
          logger: logger,
        );
        final result =
            await engine.render(filePath: '/template.html', context: context);
        expect(result, contains('<title>$title</title>'));
        expect(
          result,
          contains('<meta property="og:image" content="$imageUrl">'),
        );
        expect(result, contains('<h1>$header</h1>'));
        for (final person in people) {
          expect(result, contains('<p>${person['name']}</p>'));
          expect(result, contains('<p>${person['dob']}</p>'));
        }
      });

      test('omits comments', () async {
        final context = {
          'title': title,
          'imageUrl': imageUrl,
          'header': header,
          'people': people,
        };
        final engine = TemplateEngine(
          basePath: basePath,
          logger: logger,
        );
        final result =
            await engine.render(filePath: '/template.html', context: context);
        expect(result, isNot(contains('This is a comment')));
      });

      test('omits null values', () async {
        final context = {
          'title': title,
          'people': people,
          'header': null,
          'imageUrl': null,
        };
        final engine = TemplateEngine(
          basePath: basePath,
          logger: logger,
        );
        final result =
            await engine.render(filePath: '/template.html', context: context);
        expect(
          result,
          isNot(contains('<meta property="og:image"')),
        );
        expect(result, isNot(contains('<h1>')));
      });

      test('handles optional null values', () async {
        final people = [
          {'name': 'John Doe', 'dob': null},
          {'name': 'Jane Doe', 'dob': '02/02/2000'},
        ];
        final context = {
          'title': title,
          'people': people,
          'header': null,
          'imageUrl': null,
        };
        final engine = TemplateEngine(
          basePath: basePath,
          logger: logger,
        );
        final result =
            await engine.render(filePath: '/template.html', context: context);
        expect(result, isNot(contains(people[0]['dob'])));
        expect(result, contains(people[1]['dob']));
      });
      test('displays content for negative conditions', () async {
        final context = {
          'title': title,
          'imageUrl': imageUrl,
          'header': header,
        };
        final engine = TemplateEngine(
          basePath: basePath,
          logger: logger,
        );
        final result =
            await engine.render(filePath: '/template.html', context: context);
        expect(result, contains('<p>No people</p>'));
      });

      test('inserts fields into partials', () async {
        final context = {
          'people': people,
        };
        final engine = TemplateEngine(
          basePath: basePath,
          logger: logger,
        );
        final result = await engine.render(
          filePath: '/template_with_partial.html',
          context: context,
        );
        for (final person in people) {
          expect(result, contains('<p>${person['name']}</p>'));
        }
      });
    });
  });
}
