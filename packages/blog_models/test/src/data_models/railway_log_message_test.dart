import 'package:blog_models/blog_models.dart';
import 'package:test/test.dart';

void main() {
  final fixedDate = DateTime(2026);
  const message = 'Hello';

  group('RailwayLogMessage', () {
    test('can be instantiated', () {
      expect(
        railwayLogMessage,
        isNotNull,
      );
    });

    test('supports value equality', () {
      expect(
        RailwayLogMessage(
          message: message,
          timestamp: fixedDate,
        ),
        equals(railwayLogMessage),
      );
    });

    group('JSON Serialization', () {
      test('can be created from JSON', () {
        expect(
          RailwayLogMessage.fromJson(railwayLogMessageJson),
          isA<RailwayLogMessage>(),
        );
      });

      test('can be mapped to JSON', () {
        expect(
          railwayLogMessage.toJson(),
          equals(railwayLogMessageJson),
        );
      });
    });
  });
}
