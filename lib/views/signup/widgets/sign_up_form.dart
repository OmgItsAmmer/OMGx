import 'package:admin_dashboard_v3/views/signup/widgets/terms_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/signup/signup_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/setup/check_admin_key.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    return Form(
        key: controller.signupFormkey,
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: (value) =>
                          TValidator.validateEmptyText('First name', value),
                      controller: controller.firstName,
                      expands: false,
                      decoration: const InputDecoration(
                          labelText: TTexts.firstName,
                          prefixIcon: Icon(Iconsax.user)),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwInputFields),
                  Expanded(
                    child: TextFormField(
                      validator: (value) =>
                          TValidator.validateEmptyText('Last name', value),
                      controller: controller.lastName,
                      expands: false,
                      decoration: const InputDecoration(
                          labelText: TTexts.lastName,
                          prefixIcon: Icon(Iconsax.user)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),
              //UserName
              TextFormField(
                validator: (value) =>
                    TValidator.validateEmptyText('User name', value),
                controller: controller.username,
                expands: false,
                decoration: const InputDecoration(
                    labelText: TTexts.username,
                    prefixIcon: Icon(Iconsax.user_edit)),
              ),
              //Email
              const SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),
              //UserName
              TextFormField(
                validator: (value) => TValidator.validateEmail(value),
                controller: controller.email,
                expands: false,
                decoration: const InputDecoration(
                    labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct)),
              ),
              //Phone Number
              const SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),
              //UserName
              TextFormField(
                validator: (value) =>
                    TValidator.validateEmptyText('Phone Number', value),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: controller.phoneNumber,
                expands: false,
                decoration: const InputDecoration(
                    labelText: TTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
              ),
              //Password
              const SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),

              //UserName
              //Password
              Obx(
                () => TextFormField(
                  validator: (value) => TValidator.validatePassword(value),
                  obscureText: controller.hidePassword.value,
                  controller: controller.password,
                  expands: false,
                  decoration: InputDecoration(
                      labelText: TTexts.password,
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                        onPressed: () => controller.hidePassword.value =
                            !controller.hidePassword.value,
                        icon: Icon(controller.hidePassword.value
                            ? Iconsax.eye_slash
                            : Iconsax.eye_slash),
                      )),
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),

              // Admin Key with test button
              TextFormField(
                validator: (value) =>
                    TValidator.validateEmptyText('Admin Key', value),
                controller: controller.adminKey,
                expands: false,
                decoration: const InputDecoration(
                    labelText: TTexts.adminKey,
                    prefixIcon: Icon(Iconsax.key)),
              ),

              //Password
              const SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),
              //Terms and Conditions
              const TTermsAndConditions(),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Test admin key directly
                    final keyToCheck = controller.adminKey.text.trim();
                    if (keyToCheck.isNotEmpty) {
                      AdminKeyChecker.checkKeyExists(keyToCheck);
                    }
                    // Proceed with signup
                    controller.signup();
                  },
                  child: const Text(TTexts.createAccount),
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections / 2,
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Get.offAllNamed(TRoutes.login);
                  },
                  child: const Text('Cancel'),
                ),
              )
            ],
          ),
        ));
  }
}
