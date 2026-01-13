import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockClient extends Mock implements Client {}

void main() {
  group('ApiClient', () {
    late Client client;
    late ApiClient apiClient;
    late Uri uri;

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      client = _MockClient();
      apiClient = ApiClient(client: client);
      uri = Uri.parse('https://example.com/api/test');
    });

    test('can be instantiated', () {
      expect(apiClient, isNotNull);
    });

    group('sendRequest', () {
      const testJson = {'id': 1, 'name': 'Test'};
      const testModel = _TestModel(id: 1, name: 'Test');

      group('successful requests', () {
        test('makes successful GET request', () async {
          when(
            () => client.get(any(), headers: any(named: 'headers')),
          ).thenAnswer(
            (_) async => Response(jsonEncode(testJson), 200),
          );

          final result = await apiClient.sendRequest<_TestModel>(
            uri,
            method: HttpMethod.get,
            fromJson: _TestModel.fromJson,
          );

          expect(result.id, equals(testModel.id));
          expect(result.name, equals(testModel.name));
          verify(() => client.get(uri)).called(1);
        });

        test('makes successful POST request', () async {
          const body = {'key': 'value'};

          when(
            () => client.post(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
            ),
          ).thenAnswer(
            (_) async => Response(jsonEncode(testJson), 200),
          );

          final result = await apiClient.sendRequest<_TestModel>(
            uri,
            method: HttpMethod.post,
            fromJson: _TestModel.fromJson,
            body: body,
          );

          expect(result.id, equals(testModel.id));
          expect(result.name, equals(testModel.name));
          verify(() => client.post(uri, body: body)).called(1);
        });

        test('makes successful PUT request', () async {
          const body = {'key': 'value'};

          when(
            () => client.put(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
            ),
          ).thenAnswer(
            (_) async => Response(jsonEncode(testJson), 200),
          );

          final result = await apiClient.sendRequest<_TestModel>(
            uri,
            method: HttpMethod.put,
            fromJson: _TestModel.fromJson,
            body: body,
          );

          expect(result.id, equals(testModel.id));
          expect(result.name, equals(testModel.name));
          verify(() => client.put(uri, body: body)).called(1);
        });

        test('makes successful PATCH request', () async {
          const body = {'key': 'value'};

          when(
            () => client.patch(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
            ),
          ).thenAnswer(
            (_) async => Response(jsonEncode(testJson), 200),
          );

          final result = await apiClient.sendRequest<_TestModel>(
            uri,
            method: HttpMethod.patch,
            fromJson: _TestModel.fromJson,
            body: body,
          );

          expect(result.id, equals(testModel.id));
          expect(result.name, equals(testModel.name));
          verify(() => client.patch(uri, body: body)).called(1);
        });

        test('makes successful DELETE request', () async {
          when(
            () => client.delete(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
            ),
          ).thenAnswer(
            (_) async => Response(jsonEncode(testJson), 200),
          );

          final result = await apiClient.sendRequest<_TestModel>(
            uri,
            method: HttpMethod.delete,
            fromJson: _TestModel.fromJson,
          );

          expect(result.id, equals(testModel.id));
          expect(result.name, equals(testModel.name));
          verify(() => client.delete(uri)).called(1);
        });

        test('passes headers when provided', () async {
          const headers = {'Authorization': 'Bearer token'};

          when(
            () => client.get(any(), headers: any(named: 'headers')),
          ).thenAnswer(
            (_) async => Response(jsonEncode(testJson), 200),
          );

          await apiClient.sendRequest<_TestModel>(
            uri,
            method: HttpMethod.get,
            fromJson: _TestModel.fromJson,
            headers: headers,
          );

          verify(() => client.get(uri, headers: headers)).called(1);
        });
      });

      test('throws RequestFailedException when status code is 400', () {
        const errorMessage = 'Bad request';
        when(
          () => client.get(any(), headers: any(named: 'headers')),
        ).thenAnswer(
          (_) async => Response(errorMessage, 400),
        );

        expect(
          () => apiClient.sendRequest<_TestModel>(
            uri,
            method: HttpMethod.get,
            fromJson: _TestModel.fromJson,
          ),
          throwsA(
            isA<RequestFailedException>()
                .having((e) => e.statusCode, 'statusCode', 400)
                .having((e) => e.message, 'message', errorMessage),
          ),
        );
      });

      test('throws RequestFailedException when status code is 404', () {
        const errorMessage = 'Not found';
        when(
          () => client.get(any(), headers: any(named: 'headers')),
        ).thenAnswer(
          (_) async => Response(errorMessage, 404),
        );

        expect(
          () => apiClient.sendRequest<_TestModel>(
            uri,
            method: HttpMethod.get,
            fromJson: _TestModel.fromJson,
          ),
          throwsA(
            isA<RequestFailedException>()
                .having((e) => e.statusCode, 'statusCode', 404)
                .having((e) => e.message, 'message', errorMessage),
          ),
        );
      });

      test('throws RequestFailedException when status code is 500', () {
        const errorMessage = 'Internal server error';
        when(
          () => client.get(any(), headers: any(named: 'headers')),
        ).thenAnswer(
          (_) async => Response(errorMessage, 500),
        );

        expect(
          () => apiClient.sendRequest<_TestModel>(
            uri,
            method: HttpMethod.get,
            fromJson: _TestModel.fromJson,
          ),
          throwsA(
            isA<RequestFailedException>()
                .having((e) => e.statusCode, 'statusCode', 500)
                .having((e) => e.message, 'message', errorMessage),
          ),
        );
      });

      test(
        'throws JsonSerializationException when response body is invalid JSON',
        () {
          const invalidJson = 'not valid json';
          when(
            () => client.get(any(), headers: any(named: 'headers')),
          ).thenAnswer(
            (_) async => Response(invalidJson, 200),
          );

          expect(
            () => apiClient.sendRequest<_TestModel>(
              uri,
              method: HttpMethod.get,
              fromJson: _TestModel.fromJson,
            ),
            throwsA(
              isA<JsonSerializationException>().having(
                (e) => e.message,
                'message',
                contains('FormatException'),
              ),
            ),
          );
        },
      );

      test('throws JsonSerializationException when response body is empty', () {
        when(
          () => client.get(any(), headers: any(named: 'headers')),
        ).thenAnswer(
          (_) async => Response('', 200),
        );

        expect(
          () => apiClient.sendRequest<_TestModel>(
            uri,
            method: HttpMethod.get,
            fromJson: _TestModel.fromJson,
          ),
          throwsA(
            isA<JsonSerializationException>().having(
              (e) => e.message,
              'message',
              contains('FormatException'),
            ),
          ),
        );
      });

      test('throws JsonSerializationException '
          'when response body is JSON array instead of object', () {
        const jsonArray = '[{"id": 1, "name": "Test"}]';
        when(
          () => client.get(any(), headers: any(named: 'headers')),
        ).thenAnswer(
          (_) async => Response(jsonArray, 200),
        );

        expect(
          () => apiClient.sendRequest<_TestModel>(
            uri,
            method: HttpMethod.get,
            fromJson: _TestModel.fromJson,
          ),
          throwsA(isA<JsonSerializationException>()),
        );
      });
    });
  });
}

class _TestModel {
  const _TestModel({required this.id, required this.name});

  factory _TestModel.fromJson(Map<String, dynamic> json) {
    return _TestModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  final int id;
  final String name;
}
