// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_http_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseHttpResponse _$BaseHttpResponseFromJson(Map<String, dynamic> json) =>
    BaseHttpResponse(
      statusCode: (json['statusCode'] as num).toInt(),
      body: json['body'] as String?,
    );

Map<String, dynamic> _$BaseHttpResponseToJson(BaseHttpResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'body': instance.body,
    };
