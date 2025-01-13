import 'package:admin_dashboard_v3/views/login/widgets/login_form.dart';
import 'package:admin_dashboard_v3/views/login/widgets/login_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/form_divider.dart';
import '../../../../common/widgets/sociol_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../common/styles/spacingstyles.dart';
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

      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              TLoginHeader(dark: dark),
              TLoginForm(),
              TFormDivider(divierText: TTexts.orSignInWith.capitalize!,dark: dark),
              SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              TLoginSocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}


