// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:blog_models/blog_models.dart';
import 'package:test/test.dart';

void main() {
  group('Page', () {
    test('can be instantiated', () {
      expect(page, isNotNull);
    });

    test('supports value equality', () {
      expect(
        Page(
          slug: 'about-page',
          name: 'About',
          published: DateTime(2023),
          updated: DateTime(2023, 6, 15),
          scheduled: DateTime(2023, 1, 15),
          status: 'published',
          pageType: 'custom',
          fields: {
            'title': 'About Me',
            'content': 'Lorem ipsum dolor sit amet',
          },
        ),
        equals(
          Page(
            slug: 'about-page',
            name: 'About',
            published: DateTime(2023),
            updated: DateTime(2023, 6, 15),
            scheduled: DateTime(2023, 1, 15),
            status: 'published',
            pageType: 'custom',
            fields: {
              'title': 'About Me',
              'content': 'Lorem ipsum dolor sit amet',
            },
          ),
        ),
      );
    });

    group('JSON Serialization', () {
      test('can be created from JSON', () {
        expect(Page.fromJson(pageJson), isA<Page>());
      });

      test('can be mapped to JSON', () {
        expect(page.toJson(), equals(pageJson));
      });
    });
  });
}
