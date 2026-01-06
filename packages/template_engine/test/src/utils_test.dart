import 'package:template_engine/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('httpErrorMessage', () {
    test('should return a formatted error message', () {
      final errorMessage = httpErrorMessage(404, 'Not Found');
      expect(
        errorMessage,
        equals(
          'Http call failed: \n '
          'Status Code: 404 \n '
          'Body: Not Found',
        ),
      );
    });
  });
}
