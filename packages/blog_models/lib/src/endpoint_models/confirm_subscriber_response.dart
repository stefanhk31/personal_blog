import 'package:blog_models/src/endpoint_models/base_http_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'confirm_subscriber_response.g.dart';

/// {@template confirm_subscriber_response}
/// Response model for confirming a subscriber.
/// {@endtemplate}
@JsonSerializable()
class ConfirmSubscriberResponse extends BaseHttpResponse {
  /// {@macro confirm_subscriber_response}
  const ConfirmSubscriberResponse({
    required super.statusCode,
    super.message,
  });

  /// Factory for JSON deserialization
  factory ConfirmSubscriberResponse.fromJson(Map<String, dynamic> json) =>
      _$ConfirmSubscriberResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ConfirmSubscriberResponseToJson(this);
}
