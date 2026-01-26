import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

/// A utility class for retrieving sensitive API keys from .env file.
/// This implementation loads keys from environment variables instead of hardcoding.
class SecureKeys {
  static final SecureKeys _instance = SecureKeys._internal();
  static SecureKeys get instance => _instance;

  SecureKeys._internal();

  // Supabase project URL
  String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';

  // Supabase anon key - For client-side usage
  String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Service role key - For admin operations, should NEVER be exposed to client
  String get supabaseServiceKey => dotenv.env['SUPABASE_SERVICE_KEY'] ?? '';

  // Get Supabase URL from .env
  Future<String?> getSupabaseUrl() async {
    return dotenv.env['SUPABASE_URL'];
  }

  // Get Supabase anon key from .env
  Future<String?> getSupabaseAnonKey() async {
    return dotenv.env['SUPABASE_ANON_KEY'];
  }

  // ⚠️ Only use this method in secure code paths that run on the server
  // or for admin operations that require higher privileges
  Future<String?> getSupabaseServiceKey() async {
    if (!kDebugMode) {
      if (kDebugMode) {
        print('Warning: Attempted to access service key in release mode!');
      }
      return null;
    }
    return dotenv.env['SUPABASE_SERVICE_KEY'];
  }

  // Helper method for admin operations that need service key
  // Use this instead of directly exposing the service key
  Future<String?> getAdminKey() async {
    // In release mode, you would implement this differently
    // e.g. call a secure backend service that performs the admin operation
    if (!kDebugMode) {
      return null; // Don't expose in release mode
    }
    return await getSupabaseServiceKey();
  }
}
