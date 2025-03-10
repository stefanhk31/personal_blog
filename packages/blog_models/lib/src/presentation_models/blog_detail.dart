import 'package:blog_models/blog_models.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

/// {@template blog_detail}
/// Represents detailed content of a blog post.
/// {@endtemplate}
class BlogDetail extends Equatable {
  /// {@macro blog_detail}
  const BlogDetail({
    required this.title,
    required this.published,
    required this.body,
    required this.slug,
    required this.author,
    required this.tags,
    required this.categories,
    this.featuredImage,
    this.featuredImageAlt,
    this.seoTitle,
    this.metaDescription,
    this.url,
  });

  /// Creates a [BlogDetail] from the [Blog] data model.

  factory BlogDetail.fromBlog(Blog blog) => BlogDetail(
        title: blog.title,
        published: blog.published,
        body: blog.body ?? '',
        slug: blog.slug,
        url: blog.url,
        author: blog.author,
        tags: blog.tags,
        categories: blog.categories,
        featuredImage: blog.featuredImage,
        featuredImageAlt: blog.featuredImageAlt,
        seoTitle: blog.seoTitle,
        metaDescription: blog.metaDescription,
      );

  /// Returns the full name of the author.
  String get authorName => '${author.firstName} ${author.lastName}';

  /// Returns the date of publication in the format `Month Day, Year`.
  String get publishDateFormatted => DateFormat.yMMMMd().format(published);

  //// Title of the blog post
  final String title;

  /// Date of publication of the blog post.
  final DateTime published;

  /// Content of the blog post.
  final String body;

  /// Unique slug of the blog post.
  final String slug;

  /// Author of the blog post.
  final Author author;

  /// Tags associated with the blog post.
  final List<Tag> tags;

  /// Categories associated with the blog post.
  final List<Category> categories;

  /// Optional url to the featured image of the blog post.
  final String? featuredImage;

  /// Optional alternate text for a featured image.
  final String? featuredImageAlt;

  /// Optional url to access the blog post in Butter CMS.
  final String? url;

  /// Title of the blog post to be displayed in metadata for search engines.
  final String? seoTitle;

  /// Description of the blog post to be displayed in metadata.
  final String? metaDescription;

  @override
  List<Object?> get props => [
        title,
        published,
        body,
        slug,
        author,
        tags,
        categories,
        featuredImage,
        featuredImageAlt,
        url,
        seoTitle,
        metaDescription,
      ];
}
