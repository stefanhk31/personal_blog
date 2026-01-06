import 'package:equatable/equatable.dart';

/// {@template html_response}
/// Represents an HTML response with a status code and HTML content.
/// {@endtemplate}
class HtmlResponse extends Equatable {
  /// {@macro html_response}
  const HtmlResponse({
    required this.statusCode,
    required this.html,
  });

  /// The status code of the response.
  final int statusCode;

  /// The HTML content of the response.
  final String html;

  @override
  List<Object?> get props => [statusCode, html];
}
