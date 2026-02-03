// ignore_for_file: prefer_const_constructors

import 'package:blog_models/blog_models.dart';
import 'package:test/test.dart';

void main() {
  group('Project', () {
    test('can be instantiated', () {
      expect(project, isNotNull);
    });

    test('supports value equality', () {
      expect(
        Project(
          name: 'Personal Blog',
          description: 'A modern blog built with Flutter and Dart',
          image: 'https://example.com/project-image.jpg',
          skills: 'Flutter, Dart, Web Development',
          links: '<a href="https://github.com/example/blog">GitHub</a>',
        ),
        equals(
          Project(
            name: 'Personal Blog',
            description: 'A modern blog built with Flutter and Dart',
            image: 'https://example.com/project-image.jpg',
            skills: 'Flutter, Dart, Web Development',
            links: '<a href="https://github.com/example/blog">GitHub</a>',
          ),
        ),
      );
    });

    group('JSON Serialization', () {
      test('can be created from JSON', () {
        expect(Project.fromJson(projectJson), isA<Project>());
      });

      test('can be mapped to JSON', () {
        expect(project.toJson(), equals(projectJson));
      });
    });
  });
}
