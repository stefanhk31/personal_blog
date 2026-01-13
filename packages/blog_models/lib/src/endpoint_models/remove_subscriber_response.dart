import 'package:blog_models/src/endpoint_models/base_http_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remove_subscriber_response.g.dart';

/// {@template remove_subscriber_response}
/// Response model for removing a newsletter subscriber.
/// {@endtemplate}
@JsonSerializable()
class RemoveSubscriberResponse extends BaseHttpResponse {
  /// {@macro remove_subscriber_response}
  const RemoveSubscriberResponse({
    required super.statusCode,
    super.body,
  });

  /// Factory for JSON deserialization
  factory RemoveSubscriberResponse.fromJson(Map<String, dynamic> json) =>
      _$RemoveSubscriberResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RemoveSubscriberResponseToJson(this);
}
