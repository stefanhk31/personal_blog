// Not required for test files
// ignore_for_file: prefer_const_constructors
import 'package:blog_newsletter_client/blog_newsletter_client.dart';
import 'package:test/test.dart';

void main() {
  group('BlogNewsletterClient', () {
    test('can be instantiated', () {
      expect(BlogNewsletterClient(), isNotNull);
    });
  });
}
