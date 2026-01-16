import 'package:api_client/api_client.dart';
import 'package:blog_models/blog_models.dart';
import 'package:captcha_client/captcha_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group('CaptchaClient', () {
    late ApiClient apiClient;
    late CaptchaClient captchaClient;
    const secretKey = 'test-secret-key';
    const verifyUrl = 'https://example.com';

    setUpAll(() {
      registerFallbackValue(Uri());
      registerFallbackValue(HttpMethod.post);
    });

    setUp(() {
      apiClient = _MockApiClient();
      captchaClient = CaptchaClient(
        apiClient: apiClient,
        secretKey: secretKey,
        verifyUrl: verifyUrl,
      );
    });

    group('verifyCaptcha', () {
      test('returns true when verification succeeds', () async {
        const token = 'valid-token';
        const expectedResponse = CaptchaResponse(success: true);

        when(
          () => apiClient.sendRequest<CaptchaResponse>(
            any(),
            method: HttpMethod.post,
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            fromJson: CaptchaResponse.fromJson,
          ),
        ).thenAnswer((_) async => expectedResponse);

        final result = await captchaClient.verifyCaptcha(token);

        expect(result, isTrue);
        verify(
          () => apiClient.sendRequest<CaptchaResponse>(
            any(),
            method: HttpMethod.post,
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            fromJson: CaptchaResponse.fromJson,
          ),
        ).called(1);
      });

      test('returns false when verification fails', () async {
        const token = 'invalid-token';
        const expectedResponse = CaptchaResponse(
          success: false,
          errorCodes: ['invalid-input-response'],
        );

        when(
          () => apiClient.sendRequest<CaptchaResponse>(
            any(),
            method: HttpMethod.post,
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            fromJson: CaptchaResponse.fromJson,
          ),
        ).thenAnswer((_) async => expectedResponse);

        final result = await captchaClient.verifyCaptcha(token);

        expect(result, isFalse);
      });

      test('returns false when token is null', () async {
        final result = await captchaClient.verifyCaptcha(null);

        expect(result, isFalse);
        verifyNever(
          () => apiClient.sendRequest<CaptchaResponse>(
            any(),
            method: any(named: 'method'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            fromJson: any(named: 'fromJson'),
          ),
        );
      });

      test('returns false when token is empty', () async {
        final result = await captchaClient.verifyCaptcha('');

        expect(result, isFalse);
        verifyNever(
          () => apiClient.sendRequest<CaptchaResponse>(
            any(),
            method: any(named: 'method'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            fromJson: any(named: 'fromJson'),
          ),
        );
      });

      test('encodes secret and token in form-urlencoded body', () async {
        const token = 'test-token';
        const expectedResponse = CaptchaResponse(success: true);

        when(
          () => apiClient.sendRequest<CaptchaResponse>(
            any(),
            method: HttpMethod.post,
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            fromJson: CaptchaResponse.fromJson,
          ),
        ).thenAnswer((_) async => expectedResponse);

        await captchaClient.verifyCaptcha(token);

        verify(
          () => apiClient.sendRequest<CaptchaResponse>(
            any(),
            method: HttpMethod.post,
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'secret=$secretKey&response=$token',
            fromJson: CaptchaResponse.fromJson,
          ),
        ).called(1);
      });

      test('properly URL encodes special characters in token', () async {
        const token = 'token+with/special=chars';
        const expectedResponse = CaptchaResponse(success: true);

        when(
          () => apiClient.sendRequest<CaptchaResponse>(
            any(),
            method: HttpMethod.post,
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            fromJson: CaptchaResponse.fromJson,
          ),
        ).thenAnswer((_) async => expectedResponse);

        await captchaClient.verifyCaptcha(token);

        verify(
          () => apiClient.sendRequest<CaptchaResponse>(
            any(),
            method: HttpMethod.post,
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'secret=$secretKey&response=token%2Bwith%2Fspecial%3Dchars',
            fromJson: CaptchaResponse.fromJson,
          ),
        ).called(1);
      });

      test('calls correct verify URL', () async {
        const token = 'test-token';
        const expectedResponse = CaptchaResponse(success: true);

        when(
          () => apiClient.sendRequest<CaptchaResponse>(
            any(
              that: isA<Uri>().having(
                (uri) => uri.toString(),
                'url',
                verifyUrl,
              ),
            ),
            method: HttpMethod.post,
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            fromJson: CaptchaResponse.fromJson,
          ),
        ).thenAnswer((_) async => expectedResponse);

        await captchaClient.verifyCaptcha(token);

        verify(
          () => apiClient.sendRequest<CaptchaResponse>(
            any(
              that: isA<Uri>().having(
                (uri) => uri.toString(),
                'url',
                verifyUrl,
              ),
            ),
            method: HttpMethod.post,
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            fromJson: CaptchaResponse.fromJson,
          ),
        ).called(1);
      });

      test('returns false when ApiClient throws exception', () async {
        const token = 'test-token';

        when(
          () => apiClient.sendRequest<CaptchaResponse>(
            any(),
            method: HttpMethod.post,
            headers: any(named: 'headers'),
            body: any(named: 'body'),
            fromJson: CaptchaResponse.fromJson,
          ),
        ).thenThrow(Exception('Network error'));

        final result = await captchaClient.verifyCaptcha(token);

        expect(result, isFalse);
      });

      test(
        'returns false when ApiClient throws RequestFailedException',
        () async {
          const token = 'test-token';

          when(
            () => apiClient.sendRequest<CaptchaResponse>(
              any(),
              method: HttpMethod.post,
              headers: any(named: 'headers'),
              body: any(named: 'body'),
              fromJson: CaptchaResponse.fromJson,
            ),
          ).thenThrow(
            RequestFailedException(
              message: 'Server error',
              statusCode: 500,
            ),
          );

          final result = await captchaClient.verifyCaptcha(token);

          expect(result, isFalse);
        },
      );
    });
  });
}
