import 'dart:io';

import 'package:blog_models/blog_models.dart';
import 'package:butter_cms_client/butter_cms_client.dart';
import 'package:template_engine/template_engine.dart';

/// {@template blog_repository}
/// A repository for fetching blog data from the CMS
/// and generating HTML for the client.
/// {@endtemplate}
class BlogRepository {
  /// {@macro blog_repository}
  BlogRepository({
    required ButterCmsClient cmsClient,
    required TemplateEngine templateEngine,
  }) : _cmsClient = cmsClient,
       _templateEngine = templateEngine;

  final ButterCmsClient _cmsClient;
  final TemplateEngine _templateEngine;

  /// Fetches a detailed blog post by [slug] and generates HTML for the client.
  Future<HtmlResponse> getBlogDetailHtml(String slug) async {
    try {
      final response = await _cmsClient.fetchBlogPost(slug: slug);

      final blogDetail = BlogDetail.fromBlog(response.data);

      final html = await _templateEngine.render(
        filePath: 'blog_detail_page.html',
        context: {
          'title': blogDetail.title,
          'published': blogDetail.publishDateFormatted,
          'body': blogDetail.body,
          'authorName': blogDetail.authorName,
          'authorImage': blogDetail.author.profileImage,
          'featuredImage': blogDetail.featuredImage,
          'metaTitle': blogDetail.seoTitle,
          'metaDescription': blogDetail.metaDescription,
          'metaImageUrl': blogDetail.featuredImage ?? defaultMetaImageUrl,
          ...globalContext,
        },
      );
      return HtmlResponse(statusCode: 200, html: html);
    } on Exception catch (e) {
      return _templateEngine.renderErrorPage(message: e.toString());
    }
  }

  /// Fetches a list of blog post previews and generates HTML for the client.
  Future<HtmlResponse> getBlogOverviewHtml({
    int limit = defaultRequestLimit,
    int offset = defaultRequestOffset,
  }) async {
    try {
      final response = await _cmsClient.fetchBlogPosts(
        excludeBody: true,
        limit: limit,
        offset: offset,
      );

      final blogPreviews = response.data.map((blog) {
        return BlogPreview.fromBlog(blog);
      }).toList();

      final posts = [
        for (final (index, preview) in blogPreviews.indexed)
          {
            'title': preview.title,
            'description': preview.description,
            'featuredImage': preview.image,
            'published': preview.publishDateFormatted,
            'slug': preview.slug,
            'isLast': preview == blogPreviews.last,
            'offset': offset + index + 1,
          },
      ];

      final html = offset == 0
          ? await _templateEngine.render(
              filePath: 'blog_overview_page.html',
              context: {
                'posts': posts,
                'blogTabSelected': true,
                ...defaultMetaContext,
                ...globalContext,
              },
            )
          : await _templateEngine.render(
              filePath: 'blog_preview_list.html',
              context: {
                'posts': posts,
                'blogTabSelected': true,
                'baseAppUrl': Platform.environment['BASE_APP_URL'] ?? '',
              },
            );

      return HtmlResponse(statusCode: 200, html: html);
    } on Exception catch (e) {
      return _templateEngine.renderErrorPage(message: e.toString());
    }
  }
}
