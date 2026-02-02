import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// {@template project}
/// Data model representing a portfolio project.
/// {@endtemplate}
@JsonSerializable()
class Project extends Equatable {
  /// {@macro project}
  const Project({
    required this.name,
    required this.description,
    required this.image,
    required this.skills,
    required this.links,
  });

  /// Factory constructor for creating a [Project] from a JSON map.
  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  /// Converts a [Project] instance to a JSON map.
  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  /// The name of the project.
  final String name;

  /// A short description of the project.
  final String description;

  /// A URL for a featured image of the project.
  final String image;

  /// A comma-separated list of skills gained on the project.
  final String skills;

  /// An HTML String consisting of featured links for the project.
  final String links;

  @override
  List<Object?> get props => [name, description, image, skills, links];
}
