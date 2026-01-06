import 'package:blog_models/blog_models.dart';
import 'package:test/test.dart';

void main() {
  group('HtmlResponse', () {
    test('supports value equality', () {
      const response1 = HtmlResponse(statusCode: 200, html: '<html></html>');
      const response2 = HtmlResponse(statusCode: 200, html: '<html></html>');

      expect(response1, equals(response2));
    });
  });
}
