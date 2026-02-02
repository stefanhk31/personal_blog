import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pages_meta.g.dart';

/// {@template pages_meta}
/// Data class representing metadata for a list of pages.
/// {@endtemplate}
@JsonSerializable()
class PagesMeta extends Equatable {
  /// {@macro pages_meta}
  const PagesMeta({
    required this.count,
    this.nextPage,
    this.previousPage,
  });

  /// Deserialize a Meta object from a Map
  factory PagesMeta.fromJson(Map<String, dynamic> json) =>
      _$PagesMetaFromJson(json);

  /// Serialize a Meta object to a Map
  Map<String, dynamic> toJson() => _$PagesMetaToJson(this);

  /// Total number of pages
  final int count;

  /// Optional page number for the next page of pages
  final int? nextPage;

  /// Optional page number for the previous page of pages
  final int? previousPage;

  @override
  List<Object?> get props => [count, nextPage, previousPage];
}
