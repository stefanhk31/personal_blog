/// {@template json_serialization_exception}
/// Exception thrown when a request fails to serialize or deserialize JSON.
/// {@endtemplate}
class JsonSerializationException implements Exception {
  /// {@macro json_serialization_exception}
  const JsonSerializationException({required this.message});

  /// Message describing the error.
  final String message;

  @override
  String toString() => 'JsonSerializationException: $message';
}
