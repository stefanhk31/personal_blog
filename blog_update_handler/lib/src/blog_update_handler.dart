import 'dart:convert';

import 'package:blog_models/blog_models.dart';
import 'package:blog_newsletter_client/blog_newsletter_client.dart';
import 'package:butter_cms_client/butter_cms_client.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:uuid/uuid.dart';

/// {@template blog_update_handler}
/// Scheduled job to check for new blog posts and send them to
/// the email newsletter when available.
/// {@endtemplate}
class BlogUpdateHandler {
  /// {@macro blog_update_handler}
  const BlogUpdateHandler({
    required ButterCmsClient butterCmsClient,
    required BlogNewsletterClient blogNewsletterClient,
    required Duration publishDuration,
  }) : _butterCmsClient = butterCmsClient,
       _blogNewsletterClient = blogNewsletterClient,
       _publishDuration = publishDuration;

  final ButterCmsClient _butterCmsClient;
  final BlogNewsletterClient _blogNewsletterClient;
  final Duration _publishDuration;

  /// Fetches blog within `_publishDuration`
  /// and publishes them to the newsletter service
  Future<void> publishRecentPosts() async {
    logMessage('Starting blog update handler');

    try {
      logMessage('Fetching blog posts from Butter CMS');
      final response = await _butterCmsClient.fetchBlogPosts();

      logMessage('Fetched ${response.data.length} total blog posts');

      final cutoffDate = DateTime.now().subtract(_publishDuration);
      final recentBlogs = response.data.where((blog) {
        return blog.published.isAfter(cutoffDate) ||
            blog.published.isAtSameMomentAs(cutoffDate);
      }).toList();

      logMessage(
        'Found ${recentBlogs.length} blogs published after $cutoffDate',
      );

      if (recentBlogs.isEmpty) {
        logMessage('No recent blogs to publish');
        return;
      }

      for (final blog in recentBlogs) {
        await _publishBlog(blog);
      }

      logMessage('Completed publishing ${recentBlogs.length} blog posts');
    } on Exception catch (e, stackTrace) {
      logMessage(
        'Error in publishRecentPosts: $e\n$stackTrace',
        LogLevel.error,
      );
    }
  }

  /// Publishes a single blog to the newsletter service
  Future<void> _publishBlog(Blog blog) async {
    try {
      logMessage('Publishing blog: ${blog.title}');

      if (blog.body == null || blog.body!.isEmpty) {
        logMessage(
          'Skipping blog "${blog.title}" - no body content',
          LogLevel.error,
        );
        return;
      }

      final body = blog.body!;

      const uuid = Uuid();
      final request = BlogNewsletterPublishRequest(
        title: blog.title,
        content: NewsletterContent(
          html: body,
          text: stripHtml(body),
        ),
        idempotencyKey: uuid.v4(),
      );

      final response = await _blogNewsletterClient.publishNewsletter(
        request: request,
      );

      if (response.statusCode == 200) {
        logMessage('Successfully published: ${blog.title}');
      } else {
        logMessage(
          'Failed to publish "${blog.title}": '
          '${response.statusCode} - ${response.body}',
          LogLevel.error,
        );
      }
    } on Exception catch (e, stackTrace) {
      logMessage(
        'Error publishing blog "${blog.title}": $e\n$stackTrace',
        LogLevel.error,
      );
    }
  }

  /// Helper method to HTML tags from string content and return plain text
  String stripHtml(String html) {
    final document = html_parser.parse(html);
    return document.body?.text ?? '';
  }

  /// Helper method to log message to the Railway console in JSON format
  void logMessage(String message, [LogLevel logLevel = LogLevel.info]) {
    final logMsg = RailwayLogMessage(
      message: message,
      timestamp: DateTime.now(),
      logLevel: logLevel,
    );
    print(jsonEncode(logMsg.toJson()));
  }
}
