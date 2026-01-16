import 'package:blog_models/blog_models.dart';
import 'package:test/test.dart';

void main() {
  group('CaptchaResponse', () {
    group('successful verification', () {
      const challengeTs = '2024-01-16T12:00:00Z';
      const hostname = 'example.com';
      const response = CaptchaResponse(
        success: true,
        challengeTs: challengeTs,
        hostname: hostname,
      );

      test('can be instantiated', () {
        expect(response, isNotNull);
      });

      test('supports value equality', () {
        expect(
          CaptchaResponse(
            success: true,
            challengeTs: challengeTs,
            hostname: hostname,
          ),
          equals(response),
        );
      });

      group('JSON serialization', () {
        final jsonMap = {
          'success': true,
          'challenge_ts': '2024-01-16T12:00:00Z',
          'hostname': 'example.com',
        };

        test('can be created from JSON', () {
          final deserialized = CaptchaResponse.fromJson(jsonMap);
          expect(deserialized, isA<CaptchaResponse>());
          expect(deserialized.success, isTrue);
          expect(deserialized.challengeTs, equals(challengeTs));
          expect(deserialized.hostname, equals(hostname));
          expect(deserialized.errorCodes, isNull);
        });

        test('can be mapped to JSON', () {
          final serialized = response.toJson();
          expect(serialized['success'], isTrue);
          expect(serialized['challenge_ts'], equals(challengeTs));
          expect(serialized['hostname'], equals(hostname));
        });
      });
    });

    group('failed verification', () {
      const errorCodes = ['invalid-input-response', 'timeout-or-duplicate'];
      const response = CaptchaResponse(
        success: false,
        errorCodes: errorCodes,
      );

      test('can be instantiated', () {
        expect(response, isNotNull);
      });

      test('supports value equality', () {
        expect(
          CaptchaResponse(
            success: false,
            errorCodes: errorCodes,
          ),
          equals(response),
        );
      });

      group('JSON serialization', () {
        final jsonMap = {
          'success': false,
          'error-codes': ['invalid-input-response', 'timeout-or-duplicate'],
        };

        test('can be created from JSON', () {
          final deserialized = CaptchaResponse.fromJson(jsonMap);
          expect(deserialized, isA<CaptchaResponse>());
          expect(deserialized.success, isFalse);
          expect(deserialized.errorCodes, equals(errorCodes));
          expect(deserialized.challengeTs, isNull);
          expect(deserialized.hostname, isNull);
        });

        test('can be mapped to JSON', () {
          final serialized = response.toJson();
          expect(serialized['success'], isFalse);
          expect(serialized['error-codes'], equals(errorCodes));
        });
      });
    });

    group('minimal response', () {
      const response = CaptchaResponse(success: true);

      test('can be instantiated with only required fields', () {
        expect(response, isNotNull);
        expect(response.success, isTrue);
        expect(response.challengeTs, isNull);
        expect(response.hostname, isNull);
        expect(response.errorCodes, isNull);
      });

      test('supports value equality', () {
        expect(
          CaptchaResponse(success: true),
          equals(response),
        );
      });

      group('JSON serialization', () {
        final jsonMap = {
          'success': true,
        };

        test('can be created from minimal JSON', () {
          final deserialized = CaptchaResponse.fromJson(jsonMap);
          expect(deserialized, isA<CaptchaResponse>());
          expect(deserialized.success, isTrue);
          expect(deserialized.challengeTs, isNull);
          expect(deserialized.hostname, isNull);
          expect(deserialized.errorCodes, isNull);
        });

        test('can be mapped to JSON', () {
          final serialized = response.toJson();
          expect(serialized['success'], isTrue);
          expect(serialized['challenge_ts'], isNull);
          expect(serialized['hostname'], isNull);
          expect(serialized['error-codes'], isNull);
        });
      });
    });
  });
}
