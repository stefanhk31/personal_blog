import 'package:blog_models/src/endpoint_models/base_http_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'publish_newsletter_response.g.dart';

/// {@template publish_newsletter_response}
/// Response model for publishing a newsletter.
/// {@endtemplate}
@JsonSerializable()
class PublishNewsletterResponse extends BaseHttpResponse {
  /// {@macro publish_newsletter_response}
  const PublishNewsletterResponse({
    required super.statusCode,
    super.body,
  });

  /// Factory for JSON deserialization
  factory PublishNewsletterResponse.fromJson(Map<String, dynamic> json) =>
      _$PublishNewsletterResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PublishNewsletterResponseToJson(this);
}
