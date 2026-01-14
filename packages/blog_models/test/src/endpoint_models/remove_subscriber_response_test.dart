import 'package:blog_models/blog_models.dart';
import 'package:test/test.dart';

void main() {
  group('RemoveSubscriberResponse', () {
    const response = RemoveSubscriberResponse(
      statusCode: 200,
      message: '{"success": true}',
    );

    test('can be instantiated', () {
      expect(response, isNotNull);
    });

    test('supports value equality', () {
      expect(
        RemoveSubscriberResponse(statusCode: 200, message: '{"success": true}'),
        equals(response),
      );
    });

    group('JSON serialization', () {
      final jsonMap = {
        'statusCode': 200,
        'message': '{"success": true}',
      };

      test('can be created from JSON', () {
        expect(
          RemoveSubscriberResponse.fromJson(jsonMap),
          isA<RemoveSubscriberResponse>(),
        );
      });

      test('can be mapped to JSON', () {
        expect(response.toJson(), equals(jsonMap));
      });
    });

    test('extends BaseHttpResponse', () {
      expect(response, isA<BaseHttpResponse>());
    });

    test('supports optional body', () {
      const responseWithoutBody = RemoveSubscriberResponse(statusCode: 204);
      expect(responseWithoutBody.message, isNull);
      expect(responseWithoutBody.statusCode, equals(204));
    });
  });
}
