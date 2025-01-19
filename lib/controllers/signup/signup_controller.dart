import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../main.dart';
import '../../common/widgets/loaders/tloaders.dart';
import '../../network_manager.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/exceptions/format_exceptions.dart';
import '../../utils/exceptions/platform_exceptions.dart';
import '../../utils/popups/full_screen_loader.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  //Variables
  final privacyPolicy = true.obs;
  final hidePassword = true.obs; //Obsrable for hiding
  final email = TextEditingController(); // Controller for email input :
  final lastName = TextEditingController(); // Controller for last name input
  final username = TextEditingController(); // Controller for username input
  final password = TextEditingController(); // Controller for password input
  final firstName = TextEditingController(); // Controller for first name input
  final phoneNumber =
  TextEditingController(); // Controller for phone number input
  GlobalKey<FormState> signupFormkey =
  GlobalKey<FormState>(); // Form key for form validation


  Future<void> saveUserRecord() async {
    try {
      await supabase.from('users').insert([
        {
          'first_name': firstName.text.trim(),
          'last_name': lastName.text.trim(),
          'phone_number': phoneNumber.text.trim(),
          'email':email.text.trim()
        }
      ]);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoader.errorsnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }


//Signup
  void signup() async {
    try {
      //Start loadin
      TFullScreenLoader.openLoadingDialog(
          "We are processing your information....", TImages.docerAnimation);

      //Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }
      //Form validation
      if (!signupFormkey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        TLoader.errorsnackBar(title: "Invalid Data");
        return;
      }

      //privacy Policy Check
      if (!privacyPolicy.value) {
        TLoader.warningSnackBar(
            title: "Accept Privacy Policy",
            message:
            'In order to create account, you must have to read and accept privacy policy & Terms of Use');
        return;
      }

      //Register user in the Supabase Authentication & Save user data in the

      final AuthResponse res = await supabase.auth.signUp(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      final Session? session = res.session;
      final User? user = res.user;

      saveUserRecord();

      //Show Success message
      TLoader.successSnackBar(
          title: "Congratulations",
          message: "Your account has been created! verify email to continue.");
      //move to verify Email Screen
  //    Get.to(() => VerifyEmailScreen(email: email.text.trim(),));
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoader.errorsnackBar(title: 'Oh Snap!', message: e.toString());
      print(e.toString());
    }
  }
}