import 'package:blog_models/src/data_models/data_models.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'authors_response.g.dart';

/// {@template authors_response}
/// Data model for the API response containing a list of authors.
/// {@endtemplate}
@JsonSerializable()
class AuthorsResponse extends Equatable {
  /// {@macro authors_response}
  const AuthorsResponse({
    required this.data,
  });

  /// Deserialize an Authors list from a Map
  factory AuthorsResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthorsResponseFromJson(json);

  /// Serialize an Authors list to a Map
  Map<String, dynamic> toJson() => _$AuthorsResponseToJson(this);

  /// List of authors
  final List<Author> data;

  @override
  List<Object?> get props => [data];
}
