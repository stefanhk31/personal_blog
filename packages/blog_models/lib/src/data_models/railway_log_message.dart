import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'railway_log_message.g.dart';

/// Log level for Railway console messages
enum LogLevel {
  /// Informational log message
  info,

  /// Error log message
  error,
}

/// {@template railway_log_message}
/// A structured log message for Railway console output.
/// {@endtemplate}
@JsonSerializable()
class RailwayLogMessage extends Equatable {
  /// {@macro railway_log_message}
  const RailwayLogMessage({
    required this.message,
    required this.timestamp,
    this.logLevel = LogLevel.info,
  });

  /// Deserialize a RailwayLogMessage from JSON
  factory RailwayLogMessage.fromJson(Map<String, dynamic> json) =>
      _$RailwayLogMessageFromJson(json);

  /// Serialize a RailwayLogMessage to JSON
  Map<String, dynamic> toJson() => _$RailwayLogMessageToJson(this);

  /// The log level (info or error)
  final LogLevel logLevel;

  /// The log message content
  final String message;

  /// The timestamp when the log was created
  final DateTime timestamp;

  @override
  List<Object?> get props => [logLevel, message, timestamp];
}
