import 'package:ecommerce_dashboard/common/layouts/templates/site_template.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../common/widgets/loaders/tloaders.dart';
import '../../controllers/media/media_controller.dart';
import '../../main.dart';
import '../../utils/security/secure_keys.dart';

import '../../supabase_strings.dart';
import '../../utils/exceptions/format_exceptions.dart';
import '../../views/login/login.dart';
import '../../views/orders/all_orders/table/order_table.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //Variables
  final deviceStorage = GetStorage();
  final _requireLoginEveryTime =
      true; // Set to true to require login every time

  @override
  void onReady() {
    // Clear any existing sessions if we want to require login every time
    if (_requireLoginEveryTime) {
      clearSessionOnStartup();
    }
  }

  // Clear any existing session on app startup
  Future<void> clearSessionOnStartup() async {
    try {
      if (kDebugMode) {
        print("Clearing session on startup to require new login");
      }

      // Sign out from Supabase to clear the current session
      await supabase.auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print("Error clearing session: $e");
      }
    }
  }

  screenRedirect() async {
    try {
      // If we require login every time, just go to login screen
      if (_requireLoginEveryTime) {
        await Get.offAll(() => const LoginScreen());
        return;
      }

      // Otherwise, check session status
      final Session? session = supabase.auth.currentSession;
      final User? user = supabase.auth.currentUser;

      if (user != null && session != null) {
        if (user.emailConfirmedAt != null) {
          // Navigate to NavigationMenu only after confirming email is verified
          await Get.offAll(() => const TSiteTemplate(
                desktop: Column(
                  children: [
                    Expanded(
                      child: TRoundedContainer(
                        child: OrderTable(),
                      ),
                    )
                  ],
                ),
              ));
        } else {
          // Navigate to VerifyEmailScreen for unverified emails
          // await Get.offAll(() => VerifyEmailScreen(email: user.email));
        }
      } else {
        // Local Storage
        deviceStorage.writeIfNull('IsFirstTime', true);

        // Check if it's the first time launching the app
        bool isFirstTime = deviceStorage.read('IsFirstTime') ?? true;

        // Navigate to LoginScreen or OnBoardingScreen based on the first-time check
        if (isFirstTime) {
          await Get.offAll(() => const LoginScreen());
        } else {
          //await Get.offAll(() => const OnBoardingScreen());
        }
      }
    } catch (e) {
      print('Error during redirection: $e');
      // Optionally show an error snack bar or handle navigation errors
      TLoaders.errorSnackBar(
          title: 'Error',
          message: 'An error occurred during screen redirection.');
    }
  }

  /*-------- Email & PasSSWOrd Sign-in --------*/
  /// [EmailAuthentication] - Sign in
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final Session? session = res.session;
      final User? user = res.user;
    } on FormatException catch (_) {
      throw const TFormatException();
    }
  }

  Future<void> deleteAccount() async {
    try {
      // Get secure service key
      final serviceKey = await SecureKeys.instance.getSupabaseServiceKey();

      if (serviceKey == null) {
        if (kDebugMode) {
          print("Error: Service key not available for admin operations");
        }
        TLoaders.errorSnackBar(
            title: "Error",
            message:
                "This operation is not available in release mode. Please contact support.");
        return;
      }

      // Admin client with Service Role key (retrieved securely)
      final supabaseAdmin = SupabaseClient(
        await SecureKeys.instance.getSupabaseUrl() ??
            SupabaseStrings.projectUrl,
        serviceKey,
      );

      final User? currentUser = Supabase.instance.client.auth.currentUser;

      // Ensure the user is logged in before proceeding
      if (currentUser == null) {
        TLoaders.errorSnackBar(title: "Error", message: "User is Null");
        return;
      }

      // Clear the profile image cache
      if (Get.isRegistered<MediaController>()) {
        final mediaController = Get.find<MediaController>();
        mediaController.refreshUserImage();
      }

      // Delete user with the admin client
      await supabaseAdmin.auth.admin.deleteUser(currentUser.id);
      TLoaders.successSnackBar(title: "Account Deleted Successfully");
      Get.to(() => const LoginScreen());
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting account: $e");
      }
      TLoaders.errorSnackBar(
          title: "Error",
          message: "Could not delete account. Please try again later.");
    }
  }

  Future<void> logout() async {
    try {
      // Clear the profile image cache first
      if (Get.isRegistered<MediaController>()) {
        final mediaController = Get.find<MediaController>();
        mediaController.refreshUserImage();
      }

      // Sign out from Supabase
      await supabase.auth.signOut();

      // Navigate to login screen
      Get.offAll(() => const LoginScreen());

      TLoaders.successSnackBar(title: "Logged out successfully");
    } catch (e) {
      TLoaders.errorSnackBar(title: "Logout Error", message: e.toString());
    }
  }
}
