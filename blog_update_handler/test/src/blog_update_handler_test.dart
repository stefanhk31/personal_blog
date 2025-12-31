import 'dart:convert';

import 'package:blog_models/blog_models.dart';
import 'package:blog_newsletter_client/blog_newsletter_client.dart';
import 'package:blog_update_handler/blog_update_handler.dart';
import 'package:butter_cms_client/butter_cms_client.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockButterCmsClient extends Mock implements ButterCmsClient {}

class MockBlogNewsletterClient extends Mock implements BlogNewsletterClient {}

class FakeBlogNewsletterPublishRequest extends Fake
    implements BlogNewsletterPublishRequest {}

void main() {
  late ButterCmsClient butterCmsClient;
  late BlogNewsletterClient blogNewsletterClient;
  late BlogUpdateHandler handler;

  setUpAll(() {
    registerFallbackValue(FakeBlogNewsletterPublishRequest());
  });

  setUp(() {
    butterCmsClient = MockButterCmsClient();
    blogNewsletterClient = MockBlogNewsletterClient();
    handler = BlogUpdateHandler(
      butterCmsClient: butterCmsClient,
      blogNewsletterClient: blogNewsletterClient,
      publishDuration: const Duration(minutes: 60),
    );
  });

  group('BlogUpdateHandler', () {
    group('stripHtml', () {
      test('strips HTML tags and returns plain text', () {
        const html = '<p>Hello <strong>World</strong>!</p>';
        final result = handler.stripHtml(html);
        expect(result, 'Hello World!');
      });

      test('handles nested HTML tags', () {
        const html = '<div><p>Nested <span>content</span></p></div>';
        final result = handler.stripHtml(html);
        expect(result, 'Nested content');
      });

      test('handles empty HTML', () {
        const html = '';
        final result = handler.stripHtml(html);
        expect(result, '');
      });

      test('handles HTML with attributes', () {
        const html = '<a href="https://example.com">Link</a>';
        final result = handler.stripHtml(html);
        expect(result, 'Link');
      });

      test('handles multiple paragraphs', () {
        const html = '<p>First paragraph</p><p>Second paragraph</p>';
        final result = handler.stripHtml(html);
        expect(result, contains('First paragraph'));
        expect(result, contains('Second paragraph'));
      });
    });

    group('publishRecentPosts', () {
      test('successfully fetches and publishes recent blogs', () async {
        final now = DateTime.now();
        final recentBlog = Blog(
          created: now.subtract(const Duration(minutes: 30)),
          updated: now.subtract(const Duration(minutes: 30)),
          published: now.subtract(const Duration(minutes: 30)),
          slug: 'recent-blog',
          title: 'Recent Blog',
          body: '<p>Recent blog content</p>',
          summary: 'Summary',
          seoTitle: 'SEO Title',
          metaDescription: 'Meta description',
          status: 'published',
          featuredImageAlt: 'Alt text',
          author: const Author(
            firstName: 'John',
            lastName: 'Doe',
            email: 'john@example.com',
            slug: 'john-doe',
            bio: 'Bio',
            title: 'Writer',
            linkedinUrl: '',
            facebookUrl: '',
            twitterHandle: '',
            profileImage: '',
          ),
          categories: const [],
          tags: const [],
        );

        final blogsResponse = BlogsResponse(
          meta: const BlogsMeta(count: 1),
          data: [recentBlog],
        );

        when(
          () => butterCmsClient.fetchBlogPosts(),
        ).thenAnswer(
          (_) async => http.Response(
            jsonEncode(blogsResponse.toJson()),
            200,
          ),
        );

        when(
          () => blogNewsletterClient.publishNewsletter(
            request: any(named: 'request'),
          ),
        ).thenAnswer((_) async => http.Response('{"success": true}', 200));

        // Act
        await handler.publishRecentPosts();

        // Assert
        verify(
          () => butterCmsClient.fetchBlogPosts(),
        ).called(1);
        verify(
          () => blogNewsletterClient.publishNewsletter(
            request: any(named: 'request'),
          ),
        ).called(1);
      });

      test('does not publish blogs older than publish duration', () async {
        final now = DateTime.now();
        final oldBlog = _TestData.blog(
          now.subtract(const Duration(hours: 2)),
          slug: 'old-blog',
          title: 'Old Blog',
          body: '<p>Old blog content</p>',
        );

        final blogsResponse = BlogsResponse(
          meta: const BlogsMeta(count: 1),
          data: [oldBlog],
        );

        when(
          () => butterCmsClient.fetchBlogPosts(),
        ).thenAnswer(
          (_) async => http.Response(
            jsonEncode(blogsResponse.toJson()),
            200,
          ),
        );

        await handler.publishRecentPosts();

        verify(
          () => butterCmsClient.fetchBlogPosts(),
        ).called(1);
        verifyNever(
          () => blogNewsletterClient.publishNewsletter(
            request: any(named: 'request'),
          ),
        );
      });

      test('handles fetch error gracefully', () async {
        when(
          () => butterCmsClient.fetchBlogPosts(),
        ).thenAnswer((_) async => http.Response('Error', 500));

        await handler.publishRecentPosts();

        verify(
          () => butterCmsClient.fetchBlogPosts(),
        ).called(1);
        verifyNever(
          () => blogNewsletterClient.publishNewsletter(
            request: any(named: 'request'),
          ),
        );
      });

      test('continues processing when individual blog publish fails', () async {
        final now = DateTime.now();
        final blog1 = _TestData.blog(
          now.subtract(const Duration(minutes: 30)),
          slug: 'blog-1',
          title: 'Blog 1',
          body: '<p>Blog 1 content</p>',
        );

        final blog2 = _TestData.blog(
          now.subtract(const Duration(minutes: 20)),
          slug: 'blog-2',
          title: 'Blog 2',
          body: '<p>Blog 2 content</p>',
        );

        final blogsResponse = BlogsResponse(
          meta: const BlogsMeta(count: 2),
          data: [blog1, blog2],
        );

        when(
          () => butterCmsClient.fetchBlogPosts(),
        ).thenAnswer(
          (_) async => http.Response(
            jsonEncode(blogsResponse.toJson()),
            200,
          ),
        );

        when(
          () => blogNewsletterClient.publishNewsletter(
            request: any(named: 'request'),
          ),
        ).thenAnswer(
          (_) async => http.Response('Error', 500),
        );

        await handler.publishRecentPosts();

        verify(
          () => butterCmsClient.fetchBlogPosts(),
        ).called(1);
        verify(
          () => blogNewsletterClient.publishNewsletter(
            request: any(named: 'request'),
          ),
        ).called(2);
      });

      test('skips blogs without body content', () async {
        // Arrange
        final now = DateTime.now();
        final blogWithoutBody = _TestData.blog(
          now.subtract(const Duration(minutes: 30)),

          slug: 'blog-no-body',
          title: 'Blog Without Body',
          body: '',
        );

        final blogsResponse = BlogsResponse(
          meta: const BlogsMeta(count: 1),
          data: [blogWithoutBody],
        );

        when(
          () => butterCmsClient.fetchBlogPosts(),
        ).thenAnswer(
          (_) async => http.Response(
            jsonEncode(blogsResponse.toJson()),
            200,
          ),
        );

        // Act
        await handler.publishRecentPosts();

        // Assert
        verify(
          () => butterCmsClient.fetchBlogPosts(),
        ).called(1);
        verifyNever(
          () => blogNewsletterClient.publishNewsletter(
            request: any(named: 'request'),
          ),
        );
      });

      test('handles exception during fetch gracefully', () async {
        // Arrange
        when(
          () => butterCmsClient.fetchBlogPosts(),
        ).thenThrow(Exception('Network error'));

        // Act & Assert - should not throw
        await handler.publishRecentPosts();

        verify(
          () => butterCmsClient.fetchBlogPosts(),
        ).called(1);
      });
    });
  });
}

abstract class _TestData {
  static const author = Author(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    slug: 'john-doe',
    bio: 'Bio',
    title: 'Writer',
    linkedinUrl: '',
    facebookUrl: '',
    twitterHandle: '',
    profileImage: '',
  );

  static Blog blog(
    DateTime date, {
    required String slug,
    required String title,
    required String body,
  }) => Blog(
    created: date,
    updated: date,
    published: date,
    slug: slug,
    title: title,
    body: body,
    summary: 'Summary',
    seoTitle: 'SEO Title',
    metaDescription: 'Meta description',
    status: 'published',
    featuredImageAlt: 'Alt text',
    author: author,
    categories: const [],
    tags: const [],
  );
}
