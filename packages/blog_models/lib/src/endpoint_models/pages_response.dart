import 'package:blog_models/src/data_models/page.dart';
import 'package:blog_models/src/data_models/pages_meta.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pages_response.g.dart';

/// {@template pages_response}
/// Data model for the API response containing a list of Butter CMS pages.
/// {@endtemplate}
@JsonSerializable()
class PagesResponse extends Equatable {
  /// {@macro pages_response}
  const PagesResponse({
    required this.meta,
    required this.data,
  });

  /// Factory constructor for creating a [PagesResponse]
  /// instance from a JSON map.
  factory PagesResponse.fromJson(Map<String, dynamic> json) =>
      _$PagesResponseFromJson(json);

  /// Converts this [PagesResponse] instance to a JSON map.
  Map<String, dynamic> toJson() => _$PagesResponseToJson(this);

  /// Metadata about the pages response.
  final PagesMeta meta;

  /// List of pages in the response.
  final List<Page> data;

  @override
  List<Object?> get props => [meta, data];
}
