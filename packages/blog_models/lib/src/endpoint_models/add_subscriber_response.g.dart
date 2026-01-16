// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_subscriber_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddSubscriberResponse _$AddSubscriberResponseFromJson(
  Map<String, dynamic> json,
) => AddSubscriberResponse(
  id: json['id'] as String,
  htmlContent: json['html_content'] as String,
  textContent: json['text_content'] as String,
);

Map<String, dynamic> _$AddSubscriberResponseToJson(
  AddSubscriberResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'html_content': instance.htmlContent,
  'text_content': instance.textContent,
};
