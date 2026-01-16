// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captcha_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CaptchaResponse _$CaptchaResponseFromJson(Map<String, dynamic> json) =>
    CaptchaResponse(
      success: json['success'] as bool,
      challengeTs: json['challenge_ts'] as String?,
      hostname: json['hostname'] as String?,
      errorCodes: (json['error-codes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CaptchaResponseToJson(CaptchaResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'challenge_ts': instance.challengeTs,
      'hostname': instance.hostname,
      'error-codes': instance.errorCodes,
    };
