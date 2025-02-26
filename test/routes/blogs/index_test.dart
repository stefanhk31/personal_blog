// ignore_for_file: avoid_relative_lib_imports

import 'dart:io';

import 'package:blog_repository/blog_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/blogs/index.dart' as route;
import '../../helpers/method_not_allowed.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockBlogRepository extends Mock implements BlogRepository {}

void main() {
  group('index', () {
    group('GET /', () {
      late BlogRepository blogRepository;

      setUp(() {
        blogRepository = _MockBlogRepository();
      });
      test('responds with a 200', () async {
        final context = _MockRequestContext();
        final request = Request('GET', Uri.parse('http://127.0.0.1/'));
        const htmlResponse = '<html>test</html>';

        when(() => context.request).thenReturn(request);
        when(() => context.read<BlogRepository>()).thenReturn(blogRepository);
        when(
          () => blogRepository.getBlogOverviewHtml(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer(
          (_) async => (200, htmlResponse),
        );
        final response = await route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(
          response.body(),
          completion(
            equals(htmlResponse),
          ),
        );
      });
    });

    test('returns 405 for unsupported methods', () async {
      final context = _MockRequestContext();
      Future<Response> action() async => route.onRequest(context);

      await testMethodNotAllowed(
        context,
        () => route.onRequest(context),
        'POST',
      );
      await testMethodNotAllowed(
        context,
        () => route.onRequest(context),
        'PUT',
      );
      await testMethodNotAllowed(
        context,
        () => route.onRequest(context),
        'DELETE',
      );
      await testMethodNotAllowed(
        context,
        action,
        'PATCH',
      );
      await testMethodNotAllowed(
        context,
        action,
        'HEAD',
      );
      await testMethodNotAllowed(
        context,
        action,
        'OPTIONS',
      );
    });
  });
}
