import 'package:blog_models/blog_models.dart';
import 'package:test/test.dart';

void main() {
  group('BaseHttpResponse', () {
    const response = BaseHttpResponse(
      statusCode: 200,
      body: '{"success": true}',
    );

    test('can be instantiated', () {
      expect(response, isNotNull);
    });

    test('supports value equality', () {
      expect(
        BaseHttpResponse(statusCode: 200, body: '{"success": true}'),
        equals(response),
      );
    });

    group('JSON serialization', () {
      final jsonMap = {
        'statusCode': 200,
        'body': '{"success": true}',
      };

      test('can be created from JSON', () {
        expect(
          BaseHttpResponse.fromJson(jsonMap),
          isA<BaseHttpResponse>(),
        );
      });

      test('can be mapped to JSON', () {
        expect(response.toJson(), equals(jsonMap));
      });
    });

    test('supports optional body', () {
      const responseWithoutBody = BaseHttpResponse(statusCode: 204);
      expect(responseWithoutBody.body, isNull);
      expect(responseWithoutBody.statusCode, equals(204));
    });
  });
}
