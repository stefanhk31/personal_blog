import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_http_response.g.dart';

/// {@template base_http_response}
/// Base class for HTTP response models.
/// {@endtemplate}
@JsonSerializable()
class BaseHttpResponse extends Equatable {
  /// {@macro base_http_response}
  const BaseHttpResponse({
    required this.statusCode,
    this.message,
  });

  /// Factory for JSON deserialization
  factory BaseHttpResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseHttpResponseFromJson(json);

  /// Method for JSON serialization
  Map<String, dynamic> toJson() => _$BaseHttpResponseToJson(this);

  /// HTTP status code of the response
  @JsonKey(name: 'statusCode', defaultValue: 200)
  final int statusCode;

  /// Optional response message
  final String? message;

  @override
  List<Object?> get props => [statusCode, message];
}
