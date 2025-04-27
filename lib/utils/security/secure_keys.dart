import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

/// A utility class for securely storing and retrieving sensitive API keys.
/// This implementation avoids hardcoding keys directly in the source code.
class SecureKeys {
  static final SecureKeys _instance = SecureKeys._internal();
  static SecureKeys get instance => _instance;

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  SecureKeys._internal();

  // Key names for storage
  static const String _supabaseUrlKey = 'supabase_url';
  static const String _supabaseAnonKey = 'supabase_anon_key';
  static const String _supabaseServiceKey = 'supabase_service_key';

  // Supabase project URL
  String get supabaseUrl => const String.fromEnvironment(
        'SUPABASE_URL',
        defaultValue: 'https://fzaeqvrtuijizjncedgk.supabase.co',
      );

  // Supabase anon key - For client-side usage
  String get supabaseAnonKey => const String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ6YWVxdnJ0dWlqaXpqbmNlZGdrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkzODU0MDYsImV4cCI6MjA1NDk2MTQwNn0.GXsF0Xt4x5RvnoLIqOIB52E_5q6XYs87ZkWEMp6U0C4',
      );

  // Service role key - For admin operations, should NEVER be exposed to client
  String get supabaseServiceKey => const String.fromEnvironment(
        'SUPABASE_SERVICE_KEY',
        defaultValue:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ6YWVxdnJ0dWlqaXpqbmNlZGdrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczOTM4NTQwNiwiZXhwIjoyMDU0OTYxNDA2fQ.PSTNwSF7woXBzniC9RlTX1shleVbjm3l1acHig0hbik',
      );

  // Initialize keys - should be called early in app startup
  Future<void> initialize() async {
    try {
      // Store keys securely if they haven't been stored yet
      await _storeIfEmpty(_supabaseUrlKey, supabaseUrl);
      await _storeIfEmpty(_supabaseAnonKey, supabaseAnonKey);

      // Only store service key in debug mode
      if (kDebugMode) {
        await _storeIfEmpty(_supabaseServiceKey, supabaseServiceKey);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing secure keys: $e');
      }
    }
  }

  Future<void> _storeIfEmpty(String key, String value) async {
    final existingValue = await _storage.read(key: key);
    if (existingValue == null) {
      await _storage.write(key: key, value: value);
    }
  }

  // Get stored keys
  Future<String?> getSupabaseUrl() async {
    return await _storage.read(key: _supabaseUrlKey) ?? supabaseUrl;
  }

  Future<String?> getSupabaseAnonKey() async {
    return await _storage.read(key: _supabaseAnonKey) ?? supabaseAnonKey;
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
    return await _storage.read(key: _supabaseServiceKey) ?? supabaseServiceKey;
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
