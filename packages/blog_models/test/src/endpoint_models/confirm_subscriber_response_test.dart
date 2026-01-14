import 'package:blog_models/blog_models.dart';
import 'package:test/test.dart';

void main() {
  group('ConfirmSubscriberResponse', () {
    const response = ConfirmSubscriberResponse(
      statusCode: 200,
      message: '{"success": true}',
    );

    test('can be instantiated', () {
      expect(response, isNotNull);
    });

    test('supports value equality', () {
      expect(
        ConfirmSubscriberResponse(
          statusCode: 200,
          message: '{"success": true}',
        ),
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
          ConfirmSubscriberResponse.fromJson(jsonMap),
          isA<ConfirmSubscriberResponse>(),
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
      const responseWithoutBody = ConfirmSubscriberResponse(statusCode: 204);
      expect(responseWithoutBody.message, isNull);
      expect(responseWithoutBody.statusCode, equals(204));
    });
  });
}
