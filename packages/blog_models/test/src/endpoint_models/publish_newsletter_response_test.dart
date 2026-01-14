import 'package:blog_models/blog_models.dart';
import 'package:test/test.dart';

void main() {
  group('PublishNewsletterResponse', () {
    const response = PublishNewsletterResponse(
      statusCode: 200,
      message: '{"success": true}',
    );

    test('can be instantiated', () {
      expect(response, isNotNull);
    });

    test('supports value equality', () {
      expect(
        PublishNewsletterResponse(
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
          PublishNewsletterResponse.fromJson(jsonMap),
          isA<PublishNewsletterResponse>(),
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
      const responseWithoutBody = PublishNewsletterResponse(statusCode: 204);
      expect(responseWithoutBody.message, isNull);
      expect(responseWithoutBody.statusCode, equals(204));
    });
  });
}
