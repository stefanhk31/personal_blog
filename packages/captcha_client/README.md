# Captcha Client

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

## Introduction

This Dart package provides a client for verifying captcha tokens with reCAPTCHA or other captcha services. It helps protect your application from spam and bot submissions by verifying user-completed captcha challenges.

## Features
- Verify captcha tokens with Google reCAPTCHA
- Support for custom captcha verification URLs
- Automatic URL encoding of tokens and secrets
- Fail-safe error handling (returns false on errors)
- Configurable secret key via environment variables

## Installation 💻

**❗ In order to start using Captcha Client you must have the [Dart SDK][dart_install_link] installed on your machine.**

Install via `dart pub add`:

```sh
dart pub add captcha_client
```

---

## Usage

```dart
import 'package:api_client/api_client.dart';
import 'package:captcha_client/captcha_client.dart';
import 'package:http/http.dart' as http;

// Initialize the client
final apiClient = ApiClient(client: http.Client());
final captchaClient = CaptchaClient(
  apiClient: apiClient,
  secretKey: 'your-recaptcha-secret-key',
  // Optional: defaults to Google reCAPTCHA verify URL
  verifyUrl: 'https://www.google.com/recaptcha/api/siteverify',
);

// Verify a captcha token
final token = 'user-captcha-response-token';
final isValid = await captchaClient.verifyCaptcha(token);

if (isValid) {
  print('Captcha verified successfully!');
} else {
  print('Captcha verification failed.');
}
```

## API Reference

### `CaptchaClient`

#### Constructor

```dart
CaptchaClient({
  required ApiClient apiClient,
  required String secretKey,
  String verifyUrl = 'https://www.google.com/recaptcha/api/siteverify',
})
```

- `apiClient`: Instance of `ApiClient` for making HTTP requests
- `secretKey`: Your captcha service secret key (keep this private!)
- `verifyUrl`: (Optional) Custom verification URL. Defaults to Google reCAPTCHA.

#### Methods

##### `verifyCaptcha(String? token)`

Verifies a captcha token with the captcha service.

**Parameters:**
- `token`: The response token from the captcha widget (nullable)

**Returns:**
- `Future<bool>`: `true` if verification succeeds, `false` otherwise

**Behavior:**
- Returns `false` if token is `null` or empty (no API call made)
- Returns `false` if the API call fails or throws an exception
- Logs error codes to console when verification fails

---

## Continuous Integration 🤖

Captcha Client comes with a built-in [GitHub Actions workflow][github_actions_link] powered by [Very Good Workflows][very_good_workflows_link] but you can also add your preferred CI/CD solution.

Out of the box, on each pull request and push, the CI `formats`, `lints`, and `tests` the code. This ensures the code remains consistent and behaves correctly as you add functionality or make changes. The project uses [Very Good Analysis][very_good_analysis_link] for a strict set of analysis options used by our team. Code coverage is enforced using the [Very Good Workflows][very_good_coverage_link].

---

## Running Tests 🧪

To run all unit tests:

```sh
dart pub global activate coverage 1.15.0
dart test --coverage=coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

[dart_install_link]: https://dart.dev/get-dart
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
