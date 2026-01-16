// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captcha_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CaptchaRequest _$CaptchaRequestFromJson(Map<String, dynamic> json) =>
    CaptchaRequest(
      secret: json['secret'] as String,
      response: json['response'] as String,
    );

Map<String, dynamic> _$CaptchaRequestToJson(CaptchaRequest instance) =>
    <String, dynamic>{'secret': instance.secret, 'response': instance.response};
