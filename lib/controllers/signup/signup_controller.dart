import 'package:admin_dashboard_v3/repositories/signup/signup_repository.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../Models/user/user_model.dart';
import '../../common/widgets/loaders/tloaders.dart';
import '../../network_manager.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/popups/full_screen_loader.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();
  final signUpRepository = Get.put(SignUpRepository());

  //Variables
  final privacyPolicy = true.obs;
  final hidePassword = true.obs; //Observable for hiding
  final email = TextEditingController(); // Controller for email input :
  final lastName = TextEditingController(); // Controller for last name input
  final username = TextEditingController(); // Controller for username input
  final password = TextEditingController(); // Controller for password input
  final firstName = TextEditingController(); // Controller for first name input
  final adminKey = TextEditingController(); // Controller for admin key input
  final phoneNumber =
      TextEditingController(); // Controller for phone number input
  GlobalKey<FormState> signupFormkey = GlobalKey<FormState>();

  Future<void> saveUserRecord() async {
    // Create a UserModel object
    UserModel user = UserModel(
      userId: 0, // userId is excluded as it's auto-incremented by Supabase
      firstName: firstName.text.trim(),
      lastName: lastName.text.trim(),
      phoneNumber: phoneNumber.text.trim(),
      email: email.text.trim(),
      //  cnic: cnic.text.trim(),
      pfp: null, // Optional field, can be added later
    );

    // Convert the UserModel to JSON
    Map<String, dynamic> userJson = user.toJson();

    // Remove the 'user_id' field as it's auto-incremented by Supabase
    userJson.remove('user_id');

    //insert data
    await signUpRepository.insertUserRecord(userJson);
  }

//Signup
  void signup() async {
    try {
      //Start loading
      TFullScreenLoader.openLoadingDialog(
          "We are processing your information....", TImages.docerAnimation);

      //Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Form validation
      if (!signupFormkey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        TLoader.errorSnackBar(title: "Invalid Data");
        return;
      }

      //privacy Policy Check
      if (!privacyPolicy.value) {
        TFullScreenLoader.stopLoading();
        TLoader.warningSnackBar(
            title: "Accept Privacy Policy",
            message:
                'In order to create account, you must have to read and accept privacy policy & Terms of Use');
        return;
      }

      // For debugging - print the key being used
      if (kDebugMode) {
        print("Attempting to verify admin key: ${adminKey.text.trim()}");
      }

      // Verify admin key - using the inputKey directly to avoid storing in variables
      final submittedKey = adminKey.text.trim();
      final isValid = await signUpRepository.verifyAdminKey(submittedKey);

      if (kDebugMode) {
        print("Admin key verification result: $isValid");
      }

      if (!isValid) {
        TFullScreenLoader.stopLoading();
        TLoader.errorSnackBar(
            title: "Access Denied",
            message: "You need a valid admin key to create an account.");

        return;
      }

      //Register user in the Supabase Authentication & Save user data in the
      await supabase.auth.signUp(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      saveUserRecord();

      // Clear sensitive data after successful signup
      adminKey.clear();
      password.clear();

      //Show Success message
      TLoader.successSnackBar(
          title: "Congratulations",
          message: "Your account has been created! verify email to continue.");
      //move to verify Email Screen
      //    Get.to(() => VerifyEmailScreen(email: email.text.trim(),));
      Get.offAndToNamed(TRoutes.dashboard);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoader.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
