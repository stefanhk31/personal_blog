import 'package:api_client/src/exceptions/exceptions.dart';
import 'package:test/test.dart';

void main() {
  group('JsonSerializationException', () {
    group('toString', () {
      test('contains exception message', () {
        expect(
          const JsonSerializationException(
            message: 'FormatException',
          ).toString(),
          contains('FormatException'),
        );
      });
    });
  });
}
