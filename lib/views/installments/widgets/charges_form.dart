import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/installments/installments_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../utils/validators/validation.dart';

class ChargesForm extends StatelessWidget {
  const ChargesForm({super.key});

  @override
  Widget build(BuildContext context) {
    final InstallmentController installmentController = Get.find<InstallmentController>();

    return  TRoundedContainer(
      backgroundColor: TColors.primaryBackground,
      padding: EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          const SizedBox(height: TSizes.spaceBtwItems,),
          // bill amount
          SizedBox(
            width: double.infinity,
            // height: 80,
            child: Obx(
                () => TextFormField(
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: const InputDecoration(labelText: 'Bill Amount'),
                readOnly: true,
                maxLines: 1,
                controller: installmentController.billAmount.value ,
                validator: (value) =>
                    TValidator.validateEmptyText('Bill Amount', value),
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
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields,),
          SizedBox(
            width: double.infinity,
            // height: 80,
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(labelText: 'No of Installments'),
              maxLines: 1,
              controller: installmentController.NoOfInstallments ,
              validator: (value) =>
                  TValidator.validateEmptyText('No of Installments', value),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*\.?\d{0,2}'), // Allows numbers with up to 2 decimal places
                ),
              ],
              onChanged: (val){
                //installmentController.updateINCLExMargin();


              },
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields,),
          SizedBox(
            width: double.infinity,
            // height: 80,
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(labelText: 'ADV/Down Payment'),
              maxLines: 1,
              controller: installmentController.DownPayment ,
              validator: (value) =>
                  TValidator.validateEmptyText('Down Payment', value),
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
              decoration: const InputDecoration(labelText: 'Document Charges'),
              maxLines: 1,
              controller: installmentController.DocumentCharges ,
              validator: (value) =>
                  TValidator.validateEmptyText('Document Charges', value),
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
              decoration: const InputDecoration(labelText: 'MARGIN-%'),
              maxLines: 1,
              controller: installmentController.margin ,
              validator: (value) =>
                  TValidator.validateEmptyText('Margin', value),
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
              decoration: const InputDecoration(labelText: 'NOTE (Optional)'),
              maxLines: 5,
              controller: installmentController.note ,
            ),
          ),

        ],

      ),

    );
  }
}
