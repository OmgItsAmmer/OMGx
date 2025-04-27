import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:admin_dashboard_v3/views/signup/widgets/sign_up_form.dart';
import 'package:admin_dashboard_v3/views/signup/widgets/sociol_buttons.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/login_signup/form_divider.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/helpers/helper_functions.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: TRoundedContainer(
              width:
                  TDeviceUtils.isMobileScreen(context) ? double.infinity : 500,
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  //Title
                  Text(
                    TTexts.signupTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  //Form
                  const SignUpForm(),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  //Divider
                  TFormDivider(
                
                    dividerText: TTexts.orSignUpWith.capitalize!,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  //Social buttons
                  const TLoginSocialButtons()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
