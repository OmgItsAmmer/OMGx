
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../controllers/forget_password/forget_password.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/validators/validation.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(children: [
          //Headings
          Text(TTexts.forgetPasswordTitle,style: Theme.of(context).textTheme.labelMedium,),
          SizedBox(height: TSizes.spaceBtwItems,),
          Text(TTexts.forgetPasswordSubTitle,style: Theme.of(context).textTheme.labelMedium,),
          SizedBox(height: TSizes.spaceBtwSections*2,),


          //TextFields
          TextFormField(
            key: controller.forgetPasswordFormKey,
            controller: controller.email,
            validator: TValidator.validateEmail,
            decoration: InputDecoration(labelText: TTexts.email,prefixIcon: Icon(Iconsax.direct_right)),),
          SizedBox(height: TSizes.spaceBtwSections,),
          SizedBox(
              width: double.infinity
              ,
              child: ElevatedButton(onPressed: ()=> controller.sendPasswordResetEmail, child: Text(TTexts.submit))),





          //Submit Butoon
        ],),
      ),
    );
  }
}
