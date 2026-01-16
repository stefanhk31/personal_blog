import 'package:captcha_client/captcha_client.dart';
import 'package:dart_frog/dart_frog.dart';

import '../../utils/utils.dart';

Handler middleware(Handler handler) {
  return handler.use(_captchaMiddleware());
}

Middleware _captchaMiddleware() {
  return (handler) {
    return (context) async {
      if (context.request.method != HttpMethod.post) {
        return handler(context);
      }

      final formData = await context.request.formData();
      final captchaToken = formData.fields['g-recaptcha-response'];

      final captchaClient = context.read<CaptchaClient>();
      final isValid = await captchaClient.verifyCaptcha(captchaToken);

      if (!isValid) {
        return badRequestMessage(
          'Captcha verification failed. Please try again.',
        );
      }

      return handler(context);
    };
  };
}
