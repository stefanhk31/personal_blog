// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publish_newsletter_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublishNewsletterResponse _$PublishNewsletterResponseFromJson(
  Map<String, dynamic> json,
) => PublishNewsletterResponse(
  statusCode: (json['statusCode'] as num?)?.toInt() ?? 200,
  body: json['body'] as String?,
);

Map<String, dynamic> _$PublishNewsletterResponseToJson(
  PublishNewsletterResponse instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'body': instance.body,
};
