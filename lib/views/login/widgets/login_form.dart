import 'package:admin_dashboard_v3/repositories/authentication/authicatioon_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/login/login_controller.dart';
import '../../../utils/validators/validation.dart';
import '../../forgetpassword/forget_password.dart';
import '../../signup/signup.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    Get.put(AuthenticationRepository());

    return Form(
        key: controller.loginFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
          child: Column(
            children: [
              TextFormField(
                validator: (value) => TValidator.validateEmail(value),
                controller: controller.email,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: TTexts.email),
              ),
              const SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),
              Obx(
                    () => TextFormField(
                  validator: (value)=> TValidator.validatePassword(value),
                  obscureText: controller.hidePassword.value,
                  controller: controller.password,
                  expands: false,
                  decoration: InputDecoration(
                      labelText: TTexts.password,
                      prefixIcon: const Icon(Iconsax.password_check ),
                      suffixIcon: IconButton(onPressed: ()=> controller.hidePassword.value = !controller.hidePassword.value,icon:  Icon(controller.hidePassword.value ?Iconsax.eye_slash:Iconsax.eye),)),
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwInputFields / 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Remeber me
                  Row(
                    children: [
                      Obx(()=> Checkbox(value: controller.rememberMe.value, onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value)),
                      const Text(TTexts.rememberMe),
                    ],
                  ),
                  TextButton(onPressed: () => Get.to(()=>const ForgetPassword()), child: const Text(TTexts.forgetPassword)),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              SizedBox(
                  width: double.infinity,
                  child:
                  ElevatedButton(onPressed: () => controller.emailAndPasswordSignIn(), child: const Text(TTexts.signIn))),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                              vertical:
                              16.0), // Same vertical padding as ElevatedButton
                        ),
                        side: WidgetStateProperty.all<BorderSide>(
                          const BorderSide(
                              color:
                              Colors.white), // Border color to match the theme
                        ),
                      ),
                      onPressed: () => Get.to(()=> const SignUpScreen()),
                      child: const Text(TTexts.createAccount))),
            ],
          ),
        ));
  }
}
