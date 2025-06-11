import 'package:admin_dashboard_v3/controllers/forget_password/widgets/reset_password.dart';
import 'package:admin_dashboard_v3/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/tloaders.dart';
import '../../network_manager.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/popups/full_screen_loader.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  //Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();
  RxBool isAvaliable = false.obs;

//Send Reset Passwoed Email
  sendPasswordResetEmail() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Processing your request...", TImages.verifyIllustration);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Send mail to reset password using Supabase
      await supabase.auth.resetPasswordForEmail(email.text.trim());

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(
          title: 'Email Sent',
          message: "Email Link sent to Reset your Password".tr);

      // Redirect
      Get.to(() => ResetPassword(email: email.text.trim()));
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Processing your request...", TImages.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

//Send mail to reset password
//      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(
          title: 'Email sent',
          message: "Email Link send to Reset your Password".tr);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }
}
