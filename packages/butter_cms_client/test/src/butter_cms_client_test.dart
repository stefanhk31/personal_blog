import 'package:api_client/api_client.dart';
import 'package:blog_models/blog_models.dart';
import 'package:butter_cms_client/butter_cms_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group('ButterCmsClient', () {
    late ApiClient apiClient;
    late ButterCmsClient butterCmsClient;
    const baseUrl = '127.0.0.1';
    const apiKey = '12345';
    final notFoundException = RequestFailedException(
      message: 'Not found',
      statusCode: 404,
    );

    setUpAll(() {
      registerFallbackValue(Uri());
      registerFallbackValue(HttpMethod.get);
    });

    setUp(() {
      apiClient = _MockApiClient();
      butterCmsClient = ButterCmsClient(
        apiClient: apiClient,
        apiKey: apiKey,
        baseUrl: baseUrl,
      );
    });

    test('can be instantiated', () {
      expect(butterCmsClient, isNotNull);
    });

    group('fetchBlogPosts', () {
      const path = '/v2/posts';

      test(
          'returns BlogsResponse '
          'when the call completes successfully', () async {
        const expectedResponse = BlogsResponse(
          meta: BlogsMeta(count: 1),
          data: [],
        );

        when(
          () => apiClient.sendRequest<BlogsResponse>(
            any(
              that: isA<Uri>().having(
                (uri) => uri.path,
                'path',
                path,
              ),
            ),
            method: HttpMethod.get,
            fromJson: BlogsResponse.fromJson,
          ),
        ).thenAnswer((_) async => expectedResponse);

        final result = await butterCmsClient.fetchBlogPosts();
        expect(result, equals(expectedResponse));
        expect(result.meta.count, equals(1));
      });

      test('throws RequestFailedException when call fails', () async {
        when(
          () => apiClient.sendRequest<BlogsResponse>(
            any(
              that: isA<Uri>().having(
                (uri) => uri.path,
                'path',
                path,
              ),
            ),
            method: HttpMethod.get,
            fromJson: BlogsResponse.fromJson,
          ),
        ).thenThrow(notFoundException);

        expect(
          () => butterCmsClient.fetchBlogPosts(),
          throwsA(
            isA<RequestFailedException>()
                .having((e) => e.statusCode, 'statusCode', 404)
                .having((e) => e.message, 'message', 'Not found'),
          ),
        );
      });
    });

    group('fetchBlogPost', () {
      const path = '/v2/posts/blog-post-slug';
      const slug = 'blog-post-slug';

      test(
          'returns BlogResponse '
          'when the call completes successfully', () async {
        final expectedResponse = BlogResponse(
          meta: const BlogMeta(),
          data: Blog(
            created: DateTime(2024),
            updated: DateTime(2024),
            published: DateTime(2024),
            slug: slug,
            title: 'Test',
            body: '<p>Test</p>',
            summary: 'Test',
            seoTitle: 'Test',
            metaDescription: 'Test',
            status: 'published',
            featuredImageAlt: '',
            author: const Author(
              firstName: 'Test',
              lastName: 'User',
              email: 'test@example.com',
              slug: 'test-user',
              bio: '',
              title: '',
              linkedinUrl: '',
              facebookUrl: '',
              twitterHandle: '',
              profileImage: '',
            ),
            categories: const [],
            tags: const [],
          ),
        );

        when(
          () => apiClient.sendRequest<BlogResponse>(
            any(
              that: isA<Uri>().having(
                (uri) => uri.path,
                'path',
                path,
              ),
            ),
            method: HttpMethod.get,
            fromJson: BlogResponse.fromJson,
          ),
        ).thenAnswer((_) async => expectedResponse);

        final result = await butterCmsClient.fetchBlogPost(slug: slug);
        expect(result, equals(expectedResponse));
        expect(result.data.slug, equals(slug));
      });

      test('throws RequestFailedException when call fails', () async {
        when(
          () => apiClient.sendRequest<BlogResponse>(
            any(
              that: isA<Uri>().having(
                (uri) => uri.path,
                'path',
                path,
              ),
            ),
            method: HttpMethod.get,
            fromJson: BlogResponse.fromJson,
          ),
        ).thenThrow(notFoundException);

        expect(
          () => butterCmsClient.fetchBlogPost(slug: slug),
          throwsA(
            isA<RequestFailedException>()
                .having((e) => e.statusCode, 'statusCode', 404)
                .having((e) => e.message, 'message', 'Not found'),
          ),
        );
      });
    });

    group('fetchAuthors', () {
      const path = '/v2/authors';

      test(
          'returns AuthorsResponse '
          'when the call completes successfully', () async {
        const expectedResponse = AuthorsResponse(
          data: [author],
        );

        when(
          () => apiClient.sendRequest<AuthorsResponse>(
            any(
              that: isA<Uri>().having(
                (uri) => uri.path,
                'path',
                path,
              ),
            ),
            method: HttpMethod.get,
            fromJson: AuthorsResponse.fromJson,
          ),
        ).thenAnswer((_) async => expectedResponse);

        final result = await butterCmsClient.fetchAuthors();
        expect(result, equals(expectedResponse));
        expect(result.data.first, equals(author));
      });

      test('throws RequestFailedException when call fails', () async {
        when(
          () => apiClient.sendRequest<AuthorsResponse>(
            any(
              that: isA<Uri>().having(
                (uri) => uri.path,
                'path',
                path,
              ),
            ),
            method: HttpMethod.get,
            fromJson: AuthorsResponse.fromJson,
          ),
        ).thenThrow(notFoundException);

        expect(
          () => butterCmsClient.fetchAuthors(),
          throwsA(
            isA<RequestFailedException>()
                .having((e) => e.statusCode, 'statusCode', 404)
                .having((e) => e.message, 'message', 'Not found'),
          ),
        );
      });
    });
  });
}
