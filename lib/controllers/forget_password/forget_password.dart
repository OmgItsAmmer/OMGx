
import 'package:admin_dashboard_v3/controllers/forget_password/widgets/reset_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/tloaders.dart';
import '../../network_manager.dart';
import '../../repositories/authentication/authicatioon_repository.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/popups/full_screen_loader.dart';

class ForgetPasswordController extends GetxController{
  static ForgetPasswordController get instance => Get.find();

  //Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

//Send Reset Passwoed Email
  sendPasswordResetEmail() async {
    try {
      TFullScreenLoader.openLoadingDialog("Processing your request...", TImages.verifyIllustration);
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected) {TFullScreenLoader.stopLoading(); return;}

//form validatiom
      if(!forgetPasswordFormKey.currentState!.validate()){
        TFullScreenLoader.stopLoading();
        return;
      }
//Send mail to reset password
  //    await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      TFullScreenLoader.stopLoading();

      TLoader.successSnackBar(title: 'Email snap',message: "Email Link send to Reset your Password".tr);

      //Redirect
      Get.to(()=> ResetPassword(email: email.text.trim(),));
    }
    catch(e)
    {
      TFullScreenLoader.stopLoading();

      TLoader.errorSnackBar(title: "Oh Snap!",message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      TFullScreenLoader.openLoadingDialog("Processing your request...", TImages.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected) {TFullScreenLoader.stopLoading(); return;}


//Send mail to reset password
//      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      TFullScreenLoader.stopLoading();

      TLoader.successSnackBar(title: 'Email sent',message: "Email Link send to Reset your Password".tr);

    }
    catch(e)
    {
      TFullScreenLoader.stopLoading();
      TLoader.errorSnackBar(title: "Oh Snap!",message: e.toString());
    }
  }
}