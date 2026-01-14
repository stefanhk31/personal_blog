// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_newsletter_publish_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogNewsletterPublishRequest _$BlogNewsletterPublishRequestFromJson(
  Map<String, dynamic> json,
) => BlogNewsletterPublishRequest(
  title: json['title'] as String,
  content: NewsletterContent.fromJson(json['content'] as Map<String, dynamic>),
  idempotencyKey: json['idempotency_key'] as String,
);

Map<String, dynamic> _$BlogNewsletterPublishRequestToJson(
  BlogNewsletterPublishRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'content': instance.content.toJson(),
  'idempotency_key': instance.idempotencyKey,
};
