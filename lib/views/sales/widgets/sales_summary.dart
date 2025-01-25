

import 'package:admin_dashboard_v3/common/widgets/chips/rounded_choice_chips.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/sales/sales_controller.dart';
import '../../../utils/validators/validation.dart';

class SalesSummary extends StatelessWidget {
  const SalesSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesController salesController = Get.find<SalesController>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 100,
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Profiles'),
                    content: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: SizedBox(
                            width: 150  ,
                             child: TChoiceChip(text: 'Profile 1', selected: true))),
                        const SizedBox(width: TSizes.spaceBtwItems,),
                        Expanded(child: TChoiceChip(text: 'Profile 2', selected: false)),
                        const SizedBox(width: TSizes.spaceBtwItems,),

                        Expanded(child: TChoiceChip(text: 'Profile 3', selected: false)),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              'Profile',
              style: Theme.of(context).textTheme.bodyMedium!.apply(
                color: TColors.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        SizedBox(
          width: 200,
          child: TextFormField(
            controller: salesController.discountController, // Attach the controller
            onChanged: (value) {
              // Parse the entered value and compare with netTotal
              double enteredValue = double.tryParse(value) ?? 0.0;

              if (enteredValue > salesController.netTotal.value) {
                // Reset TextFormField and discount value to 0.0
                salesController.discountController.text = "0.0";
                salesController.discount.value = "0.0";

                // Optionally show a message to the user
                TLoader.errorsnackBar(title: "Invalid Discount", message: "Discount cannot exceed total amount.",
                  );
              } else {
                salesController.discount.value = value;
              }
            },
            validator: (value) => TValidator.validateEmptyText('Discount', value),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d*\.?\d{0,2}'), // Allows numbers with up to 2 decimal places
              ),
            ],
            decoration: const InputDecoration(labelText: 'Discount'),
          ),

        ),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        TRoundedContainer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'NET TOTAL',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                width: TSizes.spaceBtwItems,
              ),
              Obx(
                () => TRoundedContainer(
                  backgroundColor: TColors.primaryBackground,
                  width: 150,
                  height: 50,
                  child: Text(
                    (salesController.netTotal.value -
                        (double.tryParse(salesController.discount.value) ?? 0.0))
                        .toString(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
