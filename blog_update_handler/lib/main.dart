import 'dart:convert';
import 'dart:io';

void main() {
  final log = jsonEncode({
    'level': 'info',
    'message': 'Hello from blog_update_handler!',
    'timestamp': DateTime.now().toIso8601String(),
  });
  // Logger('BlogUpdateHandler')
  // .info(log);
  print(log);
  

  exit(0);
}
