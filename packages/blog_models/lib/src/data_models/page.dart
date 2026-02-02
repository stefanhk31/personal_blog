import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'page.g.dart';

/// {@template page}
/// Data model representing a Butter CMS custom page.
/// {@endtemplate}
@JsonSerializable()
class Page extends Equatable {
  /// {@macro page}
  const Page({
    required this.slug,
    required this.name,
    required this.published,
    required this.updated,
    required this.scheduled,
    required this.status,
    required this.pageType,
    required this.fields,
  });

  /// Factory constructor for creating a [Page] from a JSON map.
  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);

  /// Converts a [Page] instance to a JSON map.
  Map<String, dynamic> toJson() => _$PageToJson(this);

  /// Unique slug identifier for the page.
  final String slug;

  /// Name of the page.
  final String name;

  /// Date and time when the page was published.
  final DateTime published;

  /// Date and time when the page was last updated.
  final DateTime updated;

  /// Optional date and time when the page was scheduled for publication.
  final DateTime? scheduled;

  /// Status of the page.
  final String status;

  /// Type of the page.
  final String pageType;

  /// Custom fields associated with the page.
  final Map<String, dynamic> fields;

  @override
  List<Object?> get props => [
    slug,
    name,
    published,
    updated,
    scheduled,
    status,
    pageType,
    fields,
  ];
}
