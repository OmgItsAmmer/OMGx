import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';

class AdminKeyChecker {
  // Use this method to check if your admin key exists in the database
  static Future<void> checkKeyExists(String keyToCheck) async {
    try {
      final response =
          await supabase.from('extras').select('*').eq('AdminKey', keyToCheck);

      if (kDebugMode) {
        print("AdminKeyChecker: Response from database: $response");
        print("AdminKeyChecker: Key exists: ${response.isNotEmpty}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("AdminKeyChecker: Error checking key: $e");
      }
    }
  }
}
