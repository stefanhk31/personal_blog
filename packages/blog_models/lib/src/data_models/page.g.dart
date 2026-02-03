// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Page _$PageFromJson(Map<String, dynamic> json) => Page(
  slug: json['slug'] as String,
  name: json['name'] as String,
  published: DateTime.parse(json['published'] as String),
  updated: DateTime.parse(json['updated'] as String),
  scheduled: json['scheduled'] == null
      ? null
      : DateTime.parse(json['scheduled'] as String),
  status: json['status'] as String,
  pageType: json['page_type'] as String,
  fields: json['fields'] as Map<String, dynamic>,
);

Map<String, dynamic> _$PageToJson(Page instance) => <String, dynamic>{
  'slug': instance.slug,
  'name': instance.name,
  'published': instance.published.toIso8601String(),
  'updated': instance.updated.toIso8601String(),
  'scheduled': instance.scheduled?.toIso8601String(),
  'status': instance.status,
  'page_type': instance.pageType,
  'fields': instance.fields,
};
