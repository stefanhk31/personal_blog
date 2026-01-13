// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_subscriber_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoveSubscriberResponse _$RemoveSubscriberResponseFromJson(
        Map<String, dynamic> json) =>
    RemoveSubscriberResponse(
      statusCode: (json['statusCode'] as num).toInt(),
      body: json['body'] as String?,
    );

Map<String, dynamic> _$RemoveSubscriberResponseToJson(
        RemoveSubscriberResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'body': instance.body,
    };
