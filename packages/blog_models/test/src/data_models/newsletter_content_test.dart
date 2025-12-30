// ignore_for_file: prefer_const_constructors

import 'package:blog_models/blog_models.dart';
import 'package:test/test.dart';

void main() {
  group('NewsletterContent', () {
    test('can be instantiated', () {
      expect(
        newsletterContent,
        isNotNull,
      );
    });

    test('supports value equality', () {
      expect(
        NewsletterContent(
          html: newsletterHtmlContent,
          text: newsletterTextContent,
        ),
        equals(
          NewsletterContent(
            html: newsletterHtmlContent,
            text: newsletterTextContent,
          ),
        ),
      );
    });

    group('JSON Serialization', () {
      test('can be created from JSON', () {
        expect(
          NewsletterContent.fromJson(newsletterContentJson),
          isA<NewsletterContent>(),
        );
      });

      test('can be mapped to JSON', () {
        expect(newsletterContent.toJson(), equals(newsletterContentJson));
      });
    });
  });
}
