import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supabase configuration loaded from .env file
class SupabaseStrings {
  /// Supabase project URL
  static String get projectUrl => dotenv.env['SUPABASE_URL'] ?? '';

  /// Supabase anonymous key (for client-side usage)
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  /// Supabase service role key (for admin operations, debug mode only)
  static String get serviceKey => dotenv.env['SUPABASE_SERVICE_KEY'] ?? '';
}
