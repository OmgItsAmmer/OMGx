import 'package:admin_dashboard_v3/Models/address/address_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../common/widgets/loaders/tloaders.dart';
import '../../../main.dart';
import '../../utils/exceptions/format_exceptions.dart';
import '../../utils/exceptions/platform_exceptions.dart';

class SignUpRepository extends GetxController {
  static SignUpRepository get instance => Get.find();

  Future<void> insertUserRecord(Map<String, dynamic> json) async {
    try {
      await supabase.from('users').insert(json);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<bool> verifyAdminKey(String inputKey) async {
    try {
      if (inputKey.isEmpty) return false;

      if (kDebugMode) {
        print("Repository: Verifying admin key: $inputKey");
      }

      // Simple direct check to debug the issue
      final response =
          await supabase.from('extras').select('*').eq('AdminKey', inputKey);

      if (kDebugMode) {
        print("Repository: Query response: $response");
      }

      // Check if any rows match
      return response.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('Repository: Admin key verification error: $e');
      }
      return false;
    }
  }

  // This method should only be used once to set up the initial admin key
  Future<void> setupDefaultAdminKey(String adminKey) async {
    try {
      // Check if any admin key exists
      final response = await supabase.from('extras').select('count()').single();

      final count = response['count'] as int;

      // If no admin key exists, add the default one
      if (count == 0) {
        await supabase.from('extras').insert({'AdminKey': adminKey});

        TLoaders.successSnackBar(
            title: 'Admin Key Created',
            message: 'Default admin key has been set up');
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Admin Key Setup Failed', message: e.toString());
    }
  }
}
