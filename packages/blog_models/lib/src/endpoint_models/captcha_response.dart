import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'captcha_response.g.dart';

/// {@template captcha_response}
/// Response model for captcha verification.
/// {@endtemplate}
@JsonSerializable()
class CaptchaResponse extends Equatable {
  /// {@macro captcha_response}
  const CaptchaResponse({
    required this.success,
    this.challengeTs,
    this.hostname,
    this.errorCodes,
  });

  /// Factory for JSON deserialization
  factory CaptchaResponse.fromJson(Map<String, dynamic> json) =>
      _$CaptchaResponseFromJson(json);

  /// Method for JSON serialization
  Map<String, dynamic> toJson() => _$CaptchaResponseToJson(this);

  /// Whether the verification was successful
  final bool success;

  /// Timestamp of the challenge load (ISO format)
  @JsonKey(name: 'challenge_ts')
  final String? challengeTs;

  /// The hostname of the site where the reCAPTCHA was solved
  final String? hostname;

  /// Optional list of error codes
  @JsonKey(name: 'error-codes')
  final List<String>? errorCodes;

  @override
  List<Object?> get props => [success, challengeTs, hostname, errorCodes];
}
