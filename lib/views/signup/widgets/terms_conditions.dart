import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/signup/signup_controller.dart';

class TTermsAndConditions extends StatelessWidget {
  const TTermsAndConditions({super.key});

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Got it"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = SignUpController.instance;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Obx(() => Checkbox(
                value: controller.privacyPolicy.value,
                onChanged: (value) =>
                    controller.privacyPolicy.value = !controller.privacyPolicy.value,
              )),
        ),
        SizedBox(width: TSizes.spaceBtwItems),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${TTexts.iAgreeTo} ',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        _showDialog(context, 'Privacy Policy', '''
We collect limited data (e.g., sales, inventory, and user credentials) to run your POS system effectively. Your data is stored securely and never shared with third parties without your consent.

By using this POS software, you agree that your input data (products, customer info, etc.) may be used internally for analytics to improve features. We do not store financial data like credit card numbers.

You can contact the POS provider for any privacy concerns or to delete data.

This policy aligns with general retail software practices worldwide.
                        ''');
                      },
                      child: Text(
                        TTexts.privacyPolicy,
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                              color: dark ? TColors.white : TColors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: dark ? TColors.white : TColors.primary,
                            ),
                      ),
                    ),
                  ),
                  TextSpan(
                    text: ' ${TTexts.and} ',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        _showDialog(context, 'Terms of Use', '''
By using this POS system, you agree to the following:

1. You are responsible for maintaining the confidentiality of all login credentials.
2. This software is provided “as is” without any warranties.
3. The developer is not liable for loss of data or business interruptions.
4. You may not reverse-engineer or redistribute the app.
5. Software updates may occur to ensure continued performance.

These terms reflect global standards for point-of-sale software.
                        ''');
                      },
                      child: Text(
                        TTexts.termsOfUse,
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                              color: dark ? TColors.white : TColors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: dark ? TColors.white : TColors.primary,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
