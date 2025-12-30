import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

Future<void> main() async {
  final regLog = jsonEncode({
    'level': 'info',
    'message': 'Requesting health check from newsletter.',
    'timestamp': DateTime.now().toIso8601String(),
  });
  print(regLog);

  final uri = Uri.http(
    'blog_newsletter.railway.internal:8000',
    '/health_check',
  );
  final client = Client();
  final result = await client.get(uri);

  final resLog = jsonEncode({
    'level': 'info',
    'message': 'Response from health check is ${result.statusCode}',
    'timestamp': DateTime.now().toIso8601String(),
  });
  print(resLog);

  exit(0);
}
