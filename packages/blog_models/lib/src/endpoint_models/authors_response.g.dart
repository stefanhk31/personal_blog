// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authors_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorsResponse _$AuthorsResponseFromJson(Map<String, dynamic> json) =>
    AuthorsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => Author.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AuthorsResponseToJson(AuthorsResponse instance) =>
    <String, dynamic>{'data': instance.data.map((e) => e.toJson()).toList()};
