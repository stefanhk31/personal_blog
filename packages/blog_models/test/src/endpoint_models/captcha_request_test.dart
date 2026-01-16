import 'package:blog_models/blog_models.dart';
import 'package:test/test.dart';

void main() {
  group('CaptchaRequest', () {
    const secret = 'test-secret-key';
    const response = 'test-captcha-response-token';
    const request = CaptchaRequest(
      secret: secret,
      response: response,
    );

    test('can be instantiated', () {
      expect(request, isNotNull);
    });

    test('supports value equality', () {
      expect(
        CaptchaRequest(
          secret: secret,
          response: response,
        ),
        equals(request),
      );
    });

    group('JSON serialization', () {
      final jsonMap = {
        'secret': 'test-secret-key',
        'response': 'test-captcha-response-token',
      };

      test('can be created from JSON', () {
        final deserialized = CaptchaRequest.fromJson(jsonMap);
        expect(deserialized, isA<CaptchaRequest>());
        expect(deserialized.secret, equals(secret));
        expect(deserialized.response, equals(response));
      });

      test('can be mapped to JSON', () {
        final serialized = request.toJson();
        expect(serialized['secret'], equals(secret));
        expect(serialized['response'], equals(response));
      });
    });
  });
}
