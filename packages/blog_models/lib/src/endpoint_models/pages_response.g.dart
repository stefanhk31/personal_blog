// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pages_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagesResponse _$PagesResponseFromJson(Map<String, dynamic> json) =>
    PagesResponse(
      meta: PagesMeta.fromJson(json['meta'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>)
          .map((e) => Page.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PagesResponseToJson(PagesResponse instance) =>
    <String, dynamic>{
      'meta': instance.meta.toJson(),
      'data': instance.data.map((e) => e.toJson()).toList(),
    };
