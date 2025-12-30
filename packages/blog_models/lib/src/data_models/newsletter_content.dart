import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'newsletter_content.g.dart';

/// {@template newsletter_content}
/// Data model representing newsletter content.
/// {@endtemplate}
@JsonSerializable()
class NewsletterContent extends Equatable {
  /// {@macro newsletter_content}
  const NewsletterContent({
    required this.html,
    required this.text,
  });

  /// Creates a [NewsletterContent] instance from a JSON object.
  factory NewsletterContent.fromJson(Map<String, dynamic> json) =>
      _$NewsletterContentFromJson(json);

  /// Converts the [NewsletterContent] instance to a JSON object.
  Map<String, dynamic> toJson() => _$NewsletterContentToJson(this);

  /// The HTML content of the newsletter.
  final String html;

  /// The plain text content of the newsletter.
  final String text;

  @override
  List<Object?> get props => [html, text];
}
