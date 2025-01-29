import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/installments/installments_controller.dart';
import '../../../utils/validators/validation.dart';

class AdvanceInfo extends StatelessWidget {
  const AdvanceInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final InstallmentController installmentController = Get.find<InstallmentController>();

    return  TRoundedContainer(
      backgroundColor: TColors.primaryBackground,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          const SizedBox(height: TSizes.spaceBtwItems,),
          // bill amount
          SizedBox(
            width: double.infinity,
            // height: 80,
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(labelText: 'Frequency in month'),
              maxLines: 1,
              controller: installmentController.frequencyInMonth ,
              validator: (value) =>
                  TValidator.validateEmptyText('Frequency in month', value),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*\.?\d{0,2}'), // Allows numbers with up to 2 decimal places
                ),
              ],
              onChanged: (val){
                installmentController.updateINCLExMargin();


              },
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields,),
          SizedBox(
            width: double.infinity,
            // height: 80,
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(labelText: 'Other Charges'),
              maxLines: 1,
              controller: installmentController.otherCharges ,
              validator: (value) =>
                  TValidator.validateEmptyText('Other Charges', value),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*\.?\d{0,2}'), // Allows numbers with up to 2 decimal places
                ),
              ],
              onChanged: (val){
                installmentController.updateINCLExMargin();


              },
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields,),
          SizedBox(
            width: double.infinity,
            // height: 80,
            child: Obx(
                () => TextFormField(
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: const InputDecoration(labelText: 'Payable Ex-Margin'),
                maxLines: 1,
                readOnly: true,
                  controller: installmentController.payableExMargin.value ,

              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields,),
          SizedBox(
            width: double.infinity,
            // height: 80,
            child: Obx(
                () => TextFormField(
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: const InputDecoration(labelText: 'Payable INCL-Margin'),
                maxLines: 1,
                controller: installmentController.payableINCLMargin.value ,

                readOnly: true,
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields,),


        ],

      ),

    );
  }
}
