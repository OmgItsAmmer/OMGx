import 'package:ecommerce_dashboard/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../main.dart';

import '../../common/widgets/loaders/tloaders.dart';
import '../../network_manager.dart';
import '../../repositories/authentication/authicatioon_repository.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../media/media_controller.dart';
import '../user/user_controller.dart';

class LoginController extends GetxController {
  // variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());

  @override
  void onInit() {
    // Check if MediaController is registered before finding
    if (!Get.isRegistered<MediaController>()) {
      Get.put(MediaController());
    }
    final mediaController = Get.find<MediaController>();

    // Load saved credentials if remember me was selected
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? "";
    //password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? "";

    // Load the saved remember me state
    rememberMe.value = localStorage.read('REMEMBER_ME_CHECKED') ?? false;

    super.onInit();
  }

  Future<void> emailAndPasswordSignIn() async {
    try {
      //start Loading
      TFullScreenLoader.openLoadingDialog(
          'Logging you in...', TImages.docerAnimation);

      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Always save the current state of the remember me checkbox
      localStorage.write('REMEMBER_ME_CHECKED', rememberMe.value);

      //Save Data of Remember me is Selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        //   localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      } else {
        // Clear saved credentials if remember me is not selected
        localStorage.remove('REMEMBER_ME_EMAIL');
        //     localStorage.remove('REMEMBER_ME_PASSWORD');
      }

      // Log in the user
      await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Fetch user data
      await userController.setUpApp();
     

      // Clear profile image cache to ensure fresh image load
      if (Get.isRegistered<MediaController>()) {
        final mediaController = Get.find<MediaController>();
        mediaController.refreshUserImage();
      }

      // Clear password field for security
      if (!rememberMe.value) {
        clearCredentials();
      }

      //Remove Loader
      TFullScreenLoader.stopLoading();

      //Redirect to dashboard
      Get.offAllNamed(TRoutes.dashboard);

      if (kDebugMode) {
        print("Login successful - redirecting to dashboard");
      }
    } catch (e) {
      print(e);
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
          title: 'Login Failed',
          message: 'Please check your credentials and try again.');
    }
  }

  // Toggle remember me value and save it immediately
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
    localStorage.write('REMEMBER_ME_CHECKED', rememberMe.value);

    // If remember me is turned off, clear saved credentials
    if (!rememberMe.value) {
      localStorage.remove('REMEMBER_ME_EMAIL');
      //  localStorage.remove('REMEMBER_ME_PASSWORD');
      // Don't clear the input fields while the user is still on the login screen
    }
  }

  Future<void> googleSignIn() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Logging you in....", TImages.docerAnimation);

      //Check internet COnnectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Google Authentication
      // final userCredentional = await AuthenticationRepository.instance.signInWithGoogle();

      //Save user Record
      //  await userController.saveUserRecord(userCredentional);
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
          title: "Google Sign-In",
          message:
              "Google sign-in is currently unavailable. Please try another method.");
      return;
      //  Get.to(()=> NavigationMenu());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
          title: 'Login Failed',
          message:
              'An error occurred during Google sign-in. Please try again.');
    }
  }

  void clearCredentials() {
    // Only clear password, keep email for user convenience
    password.clear();
  }
}
