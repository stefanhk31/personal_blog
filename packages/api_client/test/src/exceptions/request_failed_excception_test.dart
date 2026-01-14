import 'package:api_client/src/exceptions/request_failed_exception.dart';
import 'package:test/test.dart';

void main() {
  group('RequestFailedException', () {
    group('toString', () {
      test('contains exception message and status code', () {
        final result = RequestFailedException(
          statusCode: 500,
          message: 'Error',
        ).toString();
        expect(
          result,
          contains('500'),
        );
        expect(result, contains('Error'));
      });
    });
  });
}
