import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:admin_dashboard_v3/views/login/widgets/login_form.dart';
import 'package:admin_dashboard_v3/views/login/widgets/login_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/sizes.dart';
import '../../common/styles/spacingstyles.dart';
import '../../common/widgets/login_signup/form_divider.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/helpers/helper_functions.dart';
import '../signup/widgets/sociol_buttons.dart';
// ignore_for_file: prefer_const_constructors

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: TRoundedContainer(
            width: TDeviceUtils.isMobileScreen(context) ? double.infinity : 500,
          //  height: 500,
            padding: EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TLoginHeader(dark: dark),
                TLoginForm(),
                TFormDivider(
                  dividerText: TTexts.orSignInWith.capitalize!,
                ),
                SizedBox(
                  height: TSizes.spaceBtwItems,
                ),
                TLoginSocialButtons()
              ],
            ),
          ),
        ),
      ),
    );
  }
}