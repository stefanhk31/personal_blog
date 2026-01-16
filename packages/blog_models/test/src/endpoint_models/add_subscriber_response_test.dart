import 'package:blog_models/blog_models.dart';
import 'package:test/test.dart';

void main() {
  group('AddSubscriberResponse', () {
    const emailID = 'email-123';
    const htmlContent = '<p>Test HTML</p>';
    const textContent = 'Test Text';
    const response = AddSubscriberResponse(
      id: emailID,
      htmlContent: htmlContent,
      textContent: textContent,
    );

    test('can be instantiated', () {
      expect(response, isNotNull);
    });

    test('supports value equality', () {
      expect(
        AddSubscriberResponse(
          id: emailID,
          htmlContent: htmlContent,
          textContent: textContent,
        ),
        equals(response),
      );
    });

    group('JSON serialization', () {
      final jsonMap = {
        'id': 'email-123',
        'html_content': '<p>Test HTML</p>',
        'text_content': 'Test Text',
      };

      test('can be created from JSON', () {
        final deserialized = AddSubscriberResponse.fromJson(jsonMap);
        expect(deserialized, isA<AddSubscriberResponse>());
        expect(deserialized.id, equals(emailID));
        expect(deserialized.htmlContent, equals(htmlContent));
        expect(deserialized.textContent, equals(textContent));
      });

      test('can be mapped to JSON', () {
        final serialized = response.toJson();
        expect(serialized['id'], equals(emailID));
        expect(serialized['html_content'], equals(htmlContent));
        expect(serialized['text_content'], equals(textContent));
      });
    });
  });
}
