// ignore_for_file: prefer_const_constructors

import 'package:blog_models/blog_models.dart';
import 'package:test/test.dart';

void main() {
  group('BlogNewsletterPublishRequest', () {
    final blogNewsletterPublishRequest = BlogNewsletterPublishRequest(
      title: newsletterTitle,
      content: newsletterContent,
      idempotencyKey: newsletterIdempotencyKey,
    );

    test('can be instantiated', () {
      expect(blogNewsletterPublishRequest, isNotNull);
    });

    test('supports value equality', () {
      expect(
        BlogNewsletterPublishRequest(
          title: newsletterTitle,
          content: newsletterContent,
          idempotencyKey: newsletterIdempotencyKey,
        ),
        equals(
          BlogNewsletterPublishRequest(
            title: newsletterTitle,
            content: newsletterContent,
            idempotencyKey: newsletterIdempotencyKey,
          ),
        ),
      );
    });

    group('JSON Serialization', () {
      final blogNewsletterPublishRequestJson = {
        'title': newsletterTitle,
        'content': newsletterContentJson,
        'idempotency_key': newsletterIdempotencyKey,
      };

      test('can be created from JSON', () {
        expect(
          BlogNewsletterPublishRequest.fromJson(
            blogNewsletterPublishRequestJson,
          ),
          isA<BlogNewsletterPublishRequest>(),
        );
      });

      test('can be mapped to JSON', () {
        expect(
          blogNewsletterPublishRequest.toJson(),
          equals(blogNewsletterPublishRequestJson),
        );
      });
    });
  });
}
