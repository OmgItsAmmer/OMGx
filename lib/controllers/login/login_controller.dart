import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:flutter/cupertino.dart';
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
  final mediaController = Get.find<MediaController>();

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? "";
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? "";
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

      //Save Data of Remember me is Selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());
      await UserController.instance.fetchUserRecord();
      UserController.instance.setupProfileDetails();

      // Clear profile image cache to ensure fresh image load
      mediaController.refreshUserImage();
      clearCredentials();
      //Remove Loader
      TFullScreenLoader.stopLoading();

      //Redirect
      // AuthenticationRepository.instance.screenRedirect();
      Get.toNamed(TRoutes.dashboard);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoader.errorSnackBar(title: 'Oh Snap', message: e.toString());
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
      TLoader.errorSnackBar(title: "Not available at the moment");
      return;
      //  Get.to(()=> NavigationMenu());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoader.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  void clearCredentials() {
    email.clear();
    password.clear();
  }
}
