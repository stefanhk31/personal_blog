// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
  name: json['name'] as String,
  description: json['description'] as String,
  image: json['image'] as String,
  skills: json['skills'] as String,
  links: json['links'] as String,
);

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'image': instance.image,
  'skills': instance.skills,
  'links': instance.links,
};
