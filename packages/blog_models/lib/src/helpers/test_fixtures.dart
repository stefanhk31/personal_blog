import 'package:blog_models/blog_models.dart';

/// Mock [Author] data. For testing purposes only.
const author = Author(
  firstName: 'John',
  lastName: 'Doe',
  email: 'johndoe@example.com',
  slug: 'john-doe',
  bio: 'Lorem ipsum dolor sit amet',
  title: 'Software Engineer',
  linkedinUrl: 'https://www.linkedin.com/in/johndoe',
  facebookUrl: 'https://www.facebook.com/johndoe',
  twitterHandle: '@johndoe',
);

/// Mock [Author] data in JSON format. For testing purposes only.
final authorJson = <String, String?>{
  'first_name': author.firstName,
  'last_name': author.lastName,
  'email': author.email,
  'slug': author.slug,
  'bio': author.bio,
  'title': author.title,
  'linkedin_url': author.linkedinUrl,
  'facebook_url': author.facebookUrl,
  'twitter_handle': author.twitterHandle,
  'profile_image': author.profileImage,
};

/// Mock [Blog] data. For testing purposes only.
final blog = Blog(
  created: DateTime.now(),
  updated: DateTime.now(),
  published: DateTime.now(),
  author: author,
  categories: const [category],
  tags: const [tag],
  featuredImageAlt: 'Featured Image',
  slug: 'my-blog-post',
  title: 'My Blog Post',
  summary: 'This is a summary of my blog post.',
  seoTitle: 'SEO Title',
  metaDescription: 'Meta Description',
  status: 'published',
);

/// Mock [Blog] data in JSON format. For testing purposes only.
final blogJson = <String, dynamic>{
  'url': blog.url,
  'created': blog.created.toIso8601String(),
  'updated': blog.updated.toIso8601String(),
  'published': blog.published.toIso8601String(),
  'author': authorJson,
  'categories': [category.toJson()],
  'tags': [tag.toJson()],
  'featured_image': blog.featuredImage,
  'featured_image_alt': blog.featuredImageAlt,
  'slug': blog.slug,
  'title': blog.title,
  'body': blog.body,
  'summary': blog.summary,
  'seo_title': blog.seoTitle,
  'meta_description': blog.metaDescription,
  'status': blog.status,
};

/// Mock [BlogSummary] data. For testing purposes only.
const blogSummary = BlogSummary(
  slug: 'my-blog-post',
  title: 'My Blog Post',
  featuredImage: 'https://example.com/featured-image.jpg',
);

/// Mock [BlogSummary] data in JSON format. For testing purposes only.
const blogSummaryJson = {
  'slug': 'my-blog-post',
  'title': 'My Blog Post',
  'featured_image': 'https://example.com/featured-image.jpg',
};

/// Mock [BlogMeta] data in JSON format. For testing purposes only.
const blogMetaJson = <String, dynamic>{
  'next_post': blogSummaryJson,
  'previous_post': blogSummaryJson,
};

/// Mock [BlogsMeta] data in JSON format. For testing purposes only.
const blogsMetaJson = <String, dynamic>{
  'count': 3,
  'next_post': blogSummaryJson,
  'previous_post': blogSummaryJson,
};

/// Mock [Category] data. For testing purposes only.
const category = Category(name: 'name', slug: 'slug');

/// Mock [Category] data in JSON format. For testing purposes only.
final categoryJson = {
  'name': 'name',
  'slug': 'slug',
};

/// Mock [Tag] data. For testing purposes only.
const tag = Tag(name: 'name', slug: 'slug');

/// Mock [Tag] data in JSON format. For testing purposes only.
final tagJson = {
  'name': 'name',
  'slug': 'slug',
};

/// Mock newsletter title. For testing purposes only.
const newsletterTitle = 'Newsletter Title';

/// Mock newsletter idempotency key. For testing purposes only.
const newsletterIdempotencyKey = 'idempotency-key-123';

/// Mock newsletter html content. For testing purposes only.
const newsletterHtmlContent = '<p>Hello, World!</p>';

/// Mock newsletter plain text content. For testing purposes only.
const newsletterTextContent = 'Hello, World!';

/// Mock [NewsletterContent] data. For testing purposes only.
const newsletterContent = NewsletterContent(
  html: newsletterHtmlContent,
  text: newsletterTextContent,
);

/// Mock [NewsletterContent] data in JSON format. For testing purposes only.
final newsletterContentJson = <String, String>{
  'html': newsletterContent.html,
  'text': newsletterContent.text,
};

/// Mock [RailwayLogMessage] data. For testing purposes only.
final railwayLogMessage = RailwayLogMessage(
  message: 'Hello',
  timestamp: DateTime(2026),
);

/// Mock [RailwayLogMessage] data in JSON format. For testing purposes only.
final railwayLogMessageJson = <String, String>{
  'message': railwayLogMessage.message,
  'timestamp': railwayLogMessage.timestamp.toIso8601String(),
  'log_level': 'info',
};
