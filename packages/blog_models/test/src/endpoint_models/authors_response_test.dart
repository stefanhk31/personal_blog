// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:blog_models/blog_models.dart';
import 'package:test/test.dart';

void main() {
  group('AuthorsResponse', () {
    final authorsResponse = AuthorsResponse(
      data: [author],
    );

    test('can be instantiated', () {
      expect(authorsResponse, isNotNull);
    });

    test('supports value equality', () {
      expect(
        AuthorsResponse(data: [author]),
        equals(authorsResponse),
      );
    });

    group('JSON Serialization', () {
      final authorsResponseJson = {
        'data': [authorJson],
      };

      test('can be created from JSON', () {
        final deserialized = AuthorsResponse.fromJson(authorsResponseJson);
        expect(deserialized, isA<AuthorsResponse>());
        expect(deserialized.data, hasLength(1));
        expect(deserialized.data.first, equals(author));
      });

      test('can be mapped to JSON', () {
        final serialized = authorsResponse.toJson();
        expect(serialized['data'], isA<List<Map<String, dynamic>>>());
        expect(serialized['data'], hasLength(1));
      });
    });

    group('with multiple authors', () {
      const author2 = Author(
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'janesmith@example.com',
        slug: 'jane-smith',
        bio: 'Another bio',
        title: 'Designer',
        linkedinUrl: 'https://www.linkedin.com/in/janesmith',
        facebookUrl: 'https://www.facebook.com/janesmith',
        twitterHandle: '@janesmith',
      );

      final multipleAuthorsResponse = AuthorsResponse(
        data: [author, author2],
      );

      test('can handle multiple authors', () {
        expect(multipleAuthorsResponse.data, hasLength(2));
        expect(multipleAuthorsResponse.data[0], equals(author));
        expect(multipleAuthorsResponse.data[1], equals(author2));
      });

      test('supports value equality with multiple authors', () {
        expect(
          AuthorsResponse(data: [author, author2]),
          equals(multipleAuthorsResponse),
        );
      });
    });

    group('with empty data', () {
      const emptyAuthorsResponse = AuthorsResponse(data: []);

      test('can be instantiated with empty list', () {
        expect(emptyAuthorsResponse.data, isEmpty);
      });

      test('can serialize empty list', () {
        final serialized = emptyAuthorsResponse.toJson();
        expect(serialized['data'], isEmpty);
      });
    });
  });
}
