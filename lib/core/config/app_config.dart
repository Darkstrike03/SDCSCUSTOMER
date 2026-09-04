import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get supabaseUrl {
    final url = dotenv.env['SUPABASE_URL'] ?? '';
    if (url.isEmpty) {
      throw Exception('SUPABASE_URL not found in .env');
    }
    return url;
  }

  static String get supabaseAnonKey {
    final key = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    if (key.isEmpty) {
      throw Exception('SUPABASE_ANON_KEY not found in .env');
    }
    return key;
  }
}
