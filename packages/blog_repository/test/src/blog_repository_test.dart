// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages
import 'package:api_client/api_client.dart';
import 'package:blog_models/blog_models.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:butter_cms_client/butter_cms_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

class _MockButterCmsClient extends Mock implements ButterCmsClient {}

class _MockTemplateEngine extends Mock implements TemplateEngine {}

void main() {
  group('BlogRepository', () {
    late ButterCmsClient cmsClient;
    late TemplateEngine templateEngine;
    late BlogRepository blogRepository;

    setUp(() {
      cmsClient = _MockButterCmsClient();
      templateEngine = _MockTemplateEngine();
      blogRepository = BlogRepository(
        cmsClient: cmsClient,
        templateEngine: templateEngine,
      );
    });

    test('can be instantiated', () {
      expect(blogRepository, isNotNull);
    });

    group('getBlogDetailHtml', () {
      test('uses template engine to render blog detail page '
          'when api call is successful', () async {
        final blogResponse = BlogResponse(
          meta: BlogMeta.fromJson(blogMetaJson),
          data: Blog.fromJson(blogJson),
        );

        when(
          () => cmsClient.fetchBlogPost(slug: any(named: 'slug')),
        ).thenAnswer((_) async => blogResponse);

        when(
          () => templateEngine.render(
            filePath: 'blog_detail_page.html',
            context: any(named: 'context'),
          ),
        ).thenAnswer((_) async => '<html></html>');

        await blogRepository.getBlogDetailHtml('my-blog-post');
        verify(
          () => templateEngine.render(
            filePath: 'blog_detail_page.html',
            context: any(named: 'context'),
          ),
        ).called(1);
      });

      test('uses template engine to render error page '
          'when api call throws RequestFailedException', () async {
        final exception = RequestFailedException(
          message: 'bad request',
          statusCode: 400,
        );

        when(
          () => cmsClient.fetchBlogPost(slug: any(named: 'slug')),
        ).thenThrow(exception);

        when(
          () => templateEngine.renderErrorPage(
            message:
                'Reqeust Failed. \nstatus code: 400 \nmessage: bad request',
          ),
        ).thenAnswer(
          (_) async => HtmlResponse(statusCode: 500, html: '<html></html>'),
        );

        await blogRepository.getBlogDetailHtml('my-blog-post');
        verify(
          () => templateEngine.renderErrorPage(
            message:
                'Reqeust Failed. \nstatus code: 400 \nmessage: bad request',
          ),
        ).called(1);
      });

      test('uses template engine to render error page '
          'when an unexpected error occurs', () async {
        final blogResponse = BlogResponse(
          meta: BlogMeta.fromJson(blogMetaJson),
          data: Blog.fromJson(blogJson),
        );

        when(
          () => cmsClient.fetchBlogPost(slug: any(named: 'slug')),
        ).thenAnswer((_) async => blogResponse);

        const errorMessage = 'error rendering template';
        when(
          () => templateEngine.render(
            filePath: 'blog_detail_page.html',
            context: any(named: 'context'),
          ),
        ).thenThrow(Exception(errorMessage));

        when(
          () => templateEngine.renderErrorPage(
            message: 'Exception: $errorMessage',
          ),
        ).thenAnswer(
          (_) async => HtmlResponse(statusCode: 500, html: '<html></html>'),
        );

        await blogRepository.getBlogDetailHtml('my-blog-post');
        verify(
          () => templateEngine.renderErrorPage(
            message: 'Exception: $errorMessage',
          ),
        ).called(1);
      });
    });

    group('getBlogOverviewHtml', () {
      test('uses template engine to render blog overview page '
          'when api call is successful and offset is zero', () async {
        final blogsResponse = BlogsResponse(
          meta: BlogsMeta.fromJson(blogsMetaJson),
          data: [Blog.fromJson(blogJson)],
        );

        when(
          () => cmsClient.fetchBlogPosts(
            excludeBody: true,
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => blogsResponse);

        when(
          () => templateEngine.render(
            filePath: 'blog_overview_page.html',
            context: any(named: 'context'),
          ),
        ).thenAnswer((_) async => '<html></html>');

        await blogRepository.getBlogOverviewHtml();
        verify(
          () => templateEngine.render(
            filePath: 'blog_overview_page.html',
            context: any(named: 'context'),
          ),
        ).called(1);
      });

      test('uses template engine to render new blog preview list data '
          'when api call is successful '
          'and offset is greater than zero', () async {
        final blogsResponse = BlogsResponse(
          meta: BlogsMeta.fromJson(blogsMetaJson),
          data: [Blog.fromJson(blogJson)],
        );

        when(
          () => cmsClient.fetchBlogPosts(
            excludeBody: true,
            limit: any(named: 'limit'),
            offset: 1,
          ),
        ).thenAnswer((_) async => blogsResponse);

        when(
          () => templateEngine.render(
            filePath: 'blog_preview_list.html',
            context: any(named: 'context'),
          ),
        ).thenAnswer((_) async => '<html></html>');

        await blogRepository.getBlogOverviewHtml(offset: 1);
        verify(
          () => templateEngine.render(
            filePath: 'blog_preview_list.html',
            context: any(named: 'context'),
          ),
        ).called(1);
      });

      test('uses template engine to render error page '
          'when api call throws RequestFailedException', () async {
        final exception = RequestFailedException(
          message: 'bad request',
          statusCode: 400,
        );

        when(
          () => cmsClient.fetchBlogPosts(
            excludeBody: true,
            limit: any(named: 'limit'),
          ),
        ).thenThrow(exception);

        when(
          () => templateEngine.renderErrorPage(
            message:
                'Reqeust Failed. \nstatus code: 400 \nmessage: bad request',
          ),
        ).thenAnswer(
          (_) async => HtmlResponse(statusCode: 500, html: '<html></html>'),
        );

        await blogRepository.getBlogOverviewHtml();
        verify(
          () => templateEngine.renderErrorPage(
            message:
                'Reqeust Failed. \nstatus code: 400 \nmessage: bad request',
          ),
        ).called(1);
      });

      test('uses template engine to render error page '
          'when an unexpected error occurs', () async {
        final blogsResponse = BlogsResponse(
          meta: BlogsMeta.fromJson(blogsMetaJson),
          data: [Blog.fromJson(blogJson)],
        );

        when(
          () => cmsClient.fetchBlogPosts(
            excludeBody: true,
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => blogsResponse);

        const errorMessage = 'error rendering template';
        when(
          () => templateEngine.render(
            filePath: 'blog_overview_page.html',
            context: any(named: 'context'),
          ),
        ).thenThrow(Exception(errorMessage));

        when(
          () => templateEngine.renderErrorPage(
            message: 'Exception: $errorMessage',
          ),
        ).thenAnswer(
          (_) async => HtmlResponse(statusCode: 500, html: '<html></html>'),
        );

        await blogRepository.getBlogOverviewHtml();
        verify(
          () => templateEngine.renderErrorPage(
            message: 'Exception: $errorMessage',
          ),
        ).called(1);
      });
    });
  });
}
