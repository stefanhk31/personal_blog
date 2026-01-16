import 'package:api_client/api_client.dart';
import 'package:blog_models/blog_models.dart';

/// {@template captcha_client}
/// Client to verify captcha tokens with a captcha service.
/// {@endtemplate}
class CaptchaClient {
  /// {@macro captcha_client}
  const CaptchaClient({
    required ApiClient apiClient,
    required String secretKey,
    String verifyUrl = 'https://www.google.com/recaptcha/api/siteverify',
  }) : _apiClient = apiClient,
       _secretKey = secretKey,
       _verifyUrl = verifyUrl;

  final ApiClient _apiClient;
  final String _secretKey;
  final String _verifyUrl;

  /// Verifies a captcha token.
  ///
  /// Takes a nullable [token] from the captcha widget.
  ///
  /// Returns `true` if the token is valid, `false` otherwise.
  /// Returns `false` if [token] is null or empty.
  Future<bool> verifyCaptcha(String? token) async {
    if (token == null || token.isEmpty) {
      return false;
    }

    try {
      final uri = Uri.parse(_verifyUrl);
      final encodedSecret = Uri.encodeComponent(_secretKey);
      final encodedToken = Uri.encodeComponent(token);

      final response = await _apiClient.sendRequest<CaptchaResponse>(
        uri,
        method: HttpMethod.post,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'secret=$encodedSecret&response=$encodedToken',
        fromJson: CaptchaResponse.fromJson,
      );

      // Log error codes if verification fails for debugging
      if (!response.success && response.errorCodes != null) {
        print('Captcha verification failed: ${response.errorCodes}');
      }

      return response.success;
    } catch (e) {
      // Log error if needed, return false for safety
      return false;
    }
  }
}
