import 'dart:convert';
import 'dart:io';

import 'package:blog_models/blog_models.dart';
import 'package:blog_repository/src/constants.dart';
import 'package:butter_cms_client/butter_cms_client.dart';
import 'package:template_engine/template_engine.dart';

/// {@template rendered_api_data}
/// A tuple containing the status code of the API call
/// and the rendered HTML content.
/// {@endtemplate}
typedef RenderedContent = (int, String);

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

  final _defaultMetaContext = {
    'metaTitle': defaultMetaTitle,
    'metaDescription': defaultMetaDescription,
  };

  final _globalContext = {
    'baseBlogsUrl': Platform.environment['BASE_BLOGS_URL'] ?? '',
    'year': currentYear,
  };

  /// Fetches a detailed blog post by [slug] and generates HTML for the client.
  Future<RenderedContent> getBlogDetailHtml(String slug) async {
    try {
      final response = await _cmsClient.fetchBlogPost(slug: slug);

      if (response.statusCode != 200) {
        return _renderErrorPage(
          message: _httpErrorMessage(response.statusCode, response.body),
          statusCode: response.statusCode,
        );
      }

      final blogResponse = BlogResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );

      final blogDetail = BlogDetail.fromBlog(blogResponse.data);

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
          ..._globalContext,
        },
      );
      return (200, html);
    } on Exception catch (e) {
      return _renderErrorPage(message: e.toString());
    }
  }

  /// Fetches a list of blog post previews and generates HTML for the client.
  Future<RenderedContent> getBlogOverviewHtml({
    int limit = defaultRequestLimit,
    int offset = defaultRequestOffset,
  }) async {
    try {
      final response = await _cmsClient.fetchBlogPosts(
        excludeBody: true,
        limit: limit,
        offset: offset,
      );

      if (response.statusCode != 200) {
        return _renderErrorPage(
          message: _httpErrorMessage(response.statusCode, response.body),
          statusCode: response.statusCode,
        );
      }

      final blogsResponse = BlogsResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );

      final blogPreviews = blogsResponse.data.map((blog) {
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
                ..._defaultMetaContext,
                ..._globalContext,
              },
            )
          : await _templateEngine.render(
              filePath: 'blog_preview_list.html',
              context: {
                'posts': posts,
                'baseBlogsUrl': Platform.environment['BASE_BLOGS_URL'] ?? '',
              },
            );

      return (200, html);
    } on Exception catch (e) {
      return _renderErrorPage(message: e.toString());
    }
  }

  String _httpErrorMessage(int statusCode, String body) {
    return 'Http call failed: \n '
        'Status Code: $statusCode \n '
        'Body: $body';
  }

  Future<RenderedContent> _renderErrorPage({
    required String message,
    int statusCode = 500,
  }) async {
    final errorHtml = await _templateEngine.render(
      filePath: 'error_page.html',
      context: {'message': message, ..._defaultMetaContext, ..._globalContext},
    );
    return (statusCode, errorHtml);
  }
}
