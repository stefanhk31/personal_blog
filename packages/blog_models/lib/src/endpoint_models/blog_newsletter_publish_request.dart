import 'package:blog_models/blog_models.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blog_newsletter_publish_request.g.dart';

/// {@template blog_newsletter_publish_request}
/// Data model for the API request to publish a blog newsletter.
/// {@endtemplate}
@JsonSerializable()
class BlogNewsletterPublishRequest extends Equatable {
  /// {@macro blog_newsletter_publish_request}
  const BlogNewsletterPublishRequest({
    required this.title,
    required this.content,
    required this.idempotencyKey,
  });

  /// Creates a [BlogNewsletterPublishRequest] instance from a JSON object.
  factory BlogNewsletterPublishRequest.fromJson(Map<String, dynamic> json) =>
      _$BlogNewsletterPublishRequestFromJson(json);

  /// Converts the [BlogNewsletterPublishRequest] instance to a JSON object.
  Map<String, dynamic> toJson() => _$BlogNewsletterPublishRequestToJson(this);

  /// The title of the newsletter.
  final String title;

  /// The content of the newsletter.
  final NewsletterContent content;

  /// The idempotency key for the request.
  @JsonKey(name: 'idempotency_key')
  final String idempotencyKey;

  @override
  List<Object?> get props => [title, content, idempotencyKey];
}
