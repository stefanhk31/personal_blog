import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'captcha_request.g.dart';

/// {@template captcha_request}
/// Request model for captcha verification.
/// {@endtemplate}
@JsonSerializable()
class CaptchaRequest extends Equatable {
  /// {@macro captcha_request}
  const CaptchaRequest({
    required this.secret,
    required this.response,
  });

  /// Factory for JSON deserialization
  factory CaptchaRequest.fromJson(Map<String, dynamic> json) =>
      _$CaptchaRequestFromJson(json);

  /// Method for JSON serialization
  Map<String, dynamic> toJson() => _$CaptchaRequestToJson(this);

  /// The shared secret key between your site and reCAPTCHA
  final String secret;

  /// The user response token provided by the reCAPTCHA client-side integration
  final String response;

  @override
  List<Object?> get props => [secret, response];
}
