// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pages_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagesMeta _$PagesMetaFromJson(Map<String, dynamic> json) => PagesMeta(
  count: (json['count'] as num).toInt(),
  nextPage: (json['next_page'] as num?)?.toInt(),
  previousPage: (json['previous_page'] as num?)?.toInt(),
);

Map<String, dynamic> _$PagesMetaToJson(PagesMeta instance) => <String, dynamic>{
  'count': instance.count,
  'next_page': instance.nextPage,
  'previous_page': instance.previousPage,
};
