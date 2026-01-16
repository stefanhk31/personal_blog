import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_subscriber_response.g.dart';

/// {@template add_subscriber_response}
/// Response model for adding a newsletter subscriber.
/// {@endtemplate}
@JsonSerializable()
class AddSubscriberResponse extends Equatable {
  /// {@macro add_subscriber_response}
  const AddSubscriberResponse({
    required this.id,
    required this.htmlContent,
    required this.textContent,
  });

  /// Factory for JSON deserialization
  factory AddSubscriberResponse.fromJson(Map<String, dynamic> json) =>
      _$AddSubscriberResponseFromJson(json);

  /// Method for JSON serialization
  Map<String, dynamic> toJson() => _$AddSubscriberResponseToJson(this);

  /// Unique identifier for the email
  final String id;

  /// HTML content of the confirmation email sent to the subscriber.
  @JsonKey(name: 'html_content')
  final String htmlContent;

  /// Plain text content of the confirmation email sent to the subscriber.
  @JsonKey(name: 'text_content')
  final String textContent;

  @override
  List<Object?> get props => [id, htmlContent, textContent];
}
