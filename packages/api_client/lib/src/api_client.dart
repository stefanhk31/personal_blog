import 'dart:convert';

import 'package:api_client/src/exceptions/exceptions.dart';
import 'package:http/http.dart';

/// Function to return a given type from json.
typedef FromJson<T> = T Function(Map<String, dynamic> json);

/// Possible HTTP methods.
enum HttpMethod {
  /// HTTP GET method.
  get,

  /// HTTP POST method.
  post,

  /// HTTP PUT method.
  put,

  /// HTTP PATCH method.
  patch,

  /// HTTP DELETE method.
  delete,
}

/// {@template api_client}
/// A simple wrapper around Dart's http client
/// to handle common api request logic.
/// {@endtemplate}
class ApiClient {
  /// {@macro api_client}
  const ApiClient({required Client client}) : _client = client;

  final Client _client;

  /// Generic method to send an API request using Dart's HTTP client
  /// and deserialize the body.
  /// Requires [uri], the [HttpMethod], and the [FromJson] deserializer.
  /// Can also provide optional [headers] and [body].
  Future<T> sendRequest<T>(
    Uri uri, {
    required HttpMethod method,
    required FromJson<T> fromJson,
    Map<String, String>? headers,
    Object? body,
  }) async {
    final response = await switch (method) {
      HttpMethod.get => _client.get(
        uri,
        headers: headers,
      ),
      HttpMethod.post => _client.post(
        uri,
        headers: headers,
        body: body,
      ),
      HttpMethod.put => _client.put(
        uri,
        headers: headers,
        body: body,
      ),
      HttpMethod.patch => _client.patch(
        uri,
        headers: headers,
        body: body,
      ),
      HttpMethod.delete => _client.delete(
        uri,
        headers: headers,
        body: body,
      ),
    };

    if (response.statusCode >= 400) {
      throw RequestFailedException(
        message: response.body,
        statusCode: response.statusCode,
      );
    }

    Map<String, dynamic>? json;
    try {
      json = jsonDecode(response.body) as Map<String, dynamic>;
    } on Exception catch (e) {
      throw JsonDecodeException(message: e.toString());
    }

    return fromJson(json);
  }
}
