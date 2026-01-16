import 'package:api_client/api_client.dart';
import 'package:blog_models/blog_models.dart';
import 'package:logging/logging.dart';

/// {@template captcha_client}
/// Client to verify captcha tokens with a captcha service.
/// {@endtemplate}
class CaptchaClient {
  /// {@macro captcha_client}
  CaptchaClient({
    required ApiClient apiClient,
    required String secretKey,
    String verifyUrl = 'https://www.google.com/recaptcha/api/siteverify',
    Logger? logger,
  }) : _apiClient = apiClient,
       _secretKey = secretKey,
       _verifyUrl = verifyUrl,
       _logger = logger ?? Logger('CaptchaClient');

  final ApiClient _apiClient;
  final Logger _logger;
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

      return response.success;
    } on Exception catch (e) {
      _logger.severe('Failed to verify captcha token', e);
      return false;
    }
  }
}
