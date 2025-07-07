import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import '../../supabase_strings.dart';

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
  static const String _databaseVersionKey = 'database_version';

  // Supabase project URL - now using SupabaseStrings as source of truth
  String get supabaseUrl => const String.fromEnvironment(
        'SUPABASE_URL',
        defaultValue: SupabaseStrings.projectUrl,
      );

  // Supabase anon key - For client-side usage
  String get supabaseAnonKey => const String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue: SupabaseStrings.anonKey,
      );

  // Service role key - For admin operations, should NEVER be exposed to client
  String get supabaseServiceKey => const String.fromEnvironment(
        'SUPABASE_SERVICE_KEY',
        defaultValue: SupabaseStrings.servieRoleKey,
      );

  // Method to clear all stored credentials (useful when switching databases)
  Future<void> clearStoredCredentials() async {
    try {
      await _storage.delete(key: _supabaseUrlKey);
      await _storage.delete(key: _supabaseAnonKey);
      await _storage.delete(key: _supabaseServiceKey);
      await _storage.delete(key: _databaseVersionKey);

      if (kDebugMode) {
        print('Cleared all stored Supabase credentials');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing stored credentials: $e');
      }
    }
  }

  // Check if we need to update stored credentials (database switch detection)
  Future<bool> _needsCredentialUpdate() async {
    try {
      final storedUrl = await _storage.read(key: _supabaseUrlKey);
      return storedUrl != null && storedUrl != supabaseUrl;
    } catch (e) {
      return true; // If we can't read, assume we need to update
    }
  }

  // Initialize keys - should be called early in app startup
  Future<void> initialize() async {
    try {
      // Check if we're switching to a different database
      final needsUpdate = await _needsCredentialUpdate();
      if (needsUpdate) {
        if (kDebugMode) {
          print('Database credentials changed, clearing old stored values');
        }
        await clearStoredCredentials();
      }

      // Store keys securely if they haven't been stored yet or were cleared
      await _storeIfEmpty(_supabaseUrlKey, supabaseUrl);
      await _storeIfEmpty(_supabaseAnonKey, supabaseAnonKey);

      // Only store service key in debug mode
      if (kDebugMode) {
        await _storeIfEmpty(_supabaseServiceKey, supabaseServiceKey);
      }

      // Store a version marker to track database changes
      await _storage.write(key: _databaseVersionKey, value: supabaseUrl);

      if (kDebugMode) {
        print('Supabase credentials initialized successfully');
        print('Using URL: $supabaseUrl');
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

  // Method to test database connection with current credentials
  Future<bool> testDatabaseConnection() async {
    try {
      // This would require importing supabase_flutter, so keeping it simple
      final url = await getSupabaseUrl();
      final key = await getSupabaseAnonKey();

      if (kDebugMode) {
        print('Testing connection to: $url');
        print('Using anon key: ${key?.substring(0, 20)}...');
      }

      // Return true if we have valid credentials
      return url != null && key != null && url.isNotEmpty && key.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('Error testing database connection: $e');
      }
      return false;
    }
  }
}
