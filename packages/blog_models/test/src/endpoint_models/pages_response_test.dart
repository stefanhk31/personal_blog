// ignore: lines_longer_than_80_chars
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:blog_models/blog_models.dart';
import 'package:test/test.dart';

void main() {
  group('PagesResponse', () {
    final page = Page(
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
    );

    test('can be instantiated', () {
      expect(pagesResponse, isNotNull);
    });

    test('supports value equality', () {
      expect(
        PagesResponse(
          meta: PagesMeta(count: 1),
          data: [page],
        ),
        equals(
          PagesResponse(
            meta: PagesMeta(count: 1),
            data: [page],
          ),
        ),
      );
    });

    group('JSON Serialization', () {
      test('can be created from JSON', () {
        expect(PagesResponse.fromJson(pagesResponseJson), isA<PagesResponse>());
      });

      test('can be mapped to JSON', () {
        expect(pagesResponse.toJson(), equals(pagesResponseJson));
      });
    });
  });
}
